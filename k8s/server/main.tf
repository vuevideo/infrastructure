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
  namespace           = kubernetes_namespace.backend_namespace.metadata
  project_id          = var.project_id
}

resource "kubernetes_deployment" "backend_deployment" {
  metadata {
    name      = "server-deployment"
    namespace = kubernetes_namespace.backend_namespace.metadata
    labels = {
      app       = "vuevideo"
      component = "server"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app       = "vuevideo"
        component = "server"
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
          component = "server"
        }
      }

      spec {
        service_account_name = module.backend-workload-identity.k8s_service_account_name
        container {
          name  = "server"
          image = "docker.io/vuevideo/server:${var.backend_version}"

          port {
            container_port = 8080
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
