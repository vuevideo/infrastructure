resource "google_firebase_web_app" "frontend" {
  provider     = google-beta
  project      = var.project_id
  display_name = "VueVideo Frontend"
}

data "google_firebase_web_app_config" "basic" {
  provider   = google-beta
  web_app_id = google_firebase_web_app.frontend.app_id
}

resource "kubernetes_namespace" "frontend_namespace" {
  metadata {
    name = "frontend"
  }
}

module "backend-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_gcp_sa = true
  name                = var.frontend_iam_name
  namespace           = "frontend"
  project_id          = var.project_id

  depends_on = [kubernetes_namespace.frontend_namespace]
}

resource "kubernetes_deployment" "frontend_deployment" {
  metadata {
    name      = "frontend-deployment"
    namespace = "frontend"
    labels = {
      app       = "vuevideo"
      component = "frontend"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app       = "vuevideo"
        component = "frontend"
      }
    }

    strategy {
      rolling_update {
        max_surge       = 1
        max_unavailable = 0
      }
    }

    template {
      metadata {
        labels = {
          app       = "vuevideo"
          component = "frontend"
        }
      }

      spec {
        service_account_name = module.backend-workload-identity.k8s_service_account_name
        container {
          name  = "frontend"
          image = "docker.io/vuevideo/client:${var.frontend_version}"

          port {
            container_port = 3001
          }

          env {
            name  = "NUXT_PUBLIC_PROXY_URL"
            value = "http://backend-service.backend.svc.cluster.local"
          }

          env {
            name  = "NUXT_PUBLIC_API_KEY"
            value = data.google_firebase_web_app_config.basic.api_key
          }

          env {
            name  = "NUXT_PUBLIC_AUTH_DOMAIN"
            value = data.google_firebase_web_app_config.basic.auth_domain
          }

          env {
            name  = "NUXT_PUBLIC_PROJECT_ID"
            value = var.project_id
          }

          env {
            name  = "NUXT_PUBLIC_STORAGE_BUCKET"
            value = lookup(data.google_firebase_web_app_config.basic, "storage_bucket", "")
          }

          env {
            name  = "NUXT_PUBLIC_MESSAGING_SENDER_ID"
            value = lookup(data.google_firebase_web_app_config.basic, "messaging_sender_id", "")
          }

          env {
            name  = "NUXT_PUBLIC_APP_ID"
            value = google_firebase_web_app.frontend.app_id
          }

          resources {
            requests = {
              "memory" = "1Gi"
              "cpu"    = "0.5"
            }
            limits = {
              "memory" = "1Gi"
              "cpu"    = "0.5"
            }
          }

          liveness_probe {
            http_get {
              path = "/api/v1/hello"
              port = "3001"
            }

            success_threshold = 1
            failure_threshold = 3
            initial_delay_seconds = 60
          }

          readiness_probe {
            http_get {
              path = "/api/v1/hello"
              port = "3001"
            }

            success_threshold = 3
            failure_threshold = 3
            initial_delay_seconds = 60
          }

          startup_probe {
            http_get {
              path = "/api/v1/hello"
              port = "3001"
            }

            success_threshold = 1
            failure_threshold = 3
            initial_delay_seconds = 60
          }
        }

        toleration {
          key    = "artifact-type"
          value  = "frontend"
          effect = "NoSchedule"
        }

        node_selector = {
          "iam.gke.io/gke-metadata-server-enabled" = "true"
          "vuevideo/artifact-type"                 = "frontend"
        }
      }
    }
  }
}

resource "kubernetes_service" "front-service" {
  metadata {
    name      = "frontend-service"
    namespace = "frontend"
    labels = {
      app       = "vuevideo"
      component = "frontend"
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app       = "vuevideo"
      component = "frontend"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3001
    }
  }

  wait_for_load_balancer = true
  depends_on             = [kubernetes_deployment.frontend_deployment]
}

