data "google_sql_database_instance" "sql" {
  name = var.database_instance_name
}

resource "kubernetes_namespace" "backend_namespace" {
  metadata {
    name = "backend"
  }
}

module "backend-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_gcp_sa = true
  name                = var.backend_iam_name
  namespace           = "backend"
  project_id          = var.project_id

  depends_on = [kubernetes_namespace.backend_namespace]
}

resource "kubernetes_deployment" "backend_deployment" {
  metadata {
    name      = "backend-deployment"
    namespace = "backend"
    labels = {
      app       = "vuevideo"
      component = "backend"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app       = "vuevideo"
        component = "backend"
      }
    }

    strategy {
      rolling_update {
        max_surge       = 1
        max_unavailable = 1
      }
    }

    template {
      metadata {
        labels = {
          app       = "vuevideo"
          component = "backend"
        }
      }

      spec {
        service_account_name = module.backend-workload-identity.k8s_service_account_name
        container {
          name  = "backend"
          image = "docker.io/vuevideo/server:${var.backend_version}"

          port {
            container_port = 3000
          }

          env {
            name  = "DATABASE_URL"
            value = "postgresql://${var.database_user}:${var.database_password}@localhost:5432/${var.database_name}"
          }

          resources {
            requests = {
              "memory" = "1Gi"
              "cpu"    = "0.5"
            }
            limits = {
              "memory" = "1Gi"
              "cpu"    = "1"
            }
          }

          liveness_probe {
            http_get {
              path = "/api/v1/hello"
              host = "127.0.0.1"
              port = "3000"
            }

            success_threshold = 3
            failure_threshold = 3
            initial_delay_seconds = 60
          }

          readiness_probe {
            http_get {
              path = "/api/v1/hello"
              host = "127.0.0.1"
              port = "3000"
            }

            success_threshold = 3
            failure_threshold = 3
            initial_delay_seconds = 60
          }

          startup_probe {
            http_get {
              path = "/api/v1/hello"
              host = "127.0.0.1"
              port = "3000"
            }

            success_threshold = 3
            failure_threshold = 3
            initial_delay_seconds = 60
          }
        }

        container {
          name  = "cloud-sql-proxy"
          image = "gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.1.0"

          args = [
            "--private-ip",
            "--structured-logs",
            "--port=5432",
            data.google_sql_database_instance.sql.connection_name
          ]

          security_context {
            run_as_non_root = true
          }

          resources {
            requests = {
              "memory" = "1Gi"
              "cpu"    = "0.5"
            }
            limits = {
              "memory" = "1Gi"
              "cpu"    = "1"
            }
          }
        }

        toleration {
          key    = "artifact-type"
          value  = "backend"
          effect = "NoSchedule"
        }

        node_selector = {
          "iam.gke.io/gke-metadata-server-enabled" = "true"
          "vuevideo/artifact-type"                 = "backend"
        }
      }
    }
  }
}

resource "kubernetes_service" "backend-service" {
  metadata {
    name      = "backend-service"
    namespace = "backend"
    labels = {
      app       = "vuevideo"
      component = "backend"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app       = "vuevideo"
      component = "backend"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }
  }

  wait_for_load_balancer = true
  depends_on             = [kubernetes_deployment.backend_deployment]
}