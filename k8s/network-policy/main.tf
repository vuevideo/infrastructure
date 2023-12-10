resource "kubernetes_network_policy" "allow_backend_ingress" {
  metadata {
    name      = "allow-backend-ingress"
    namespace = "backend"
  }

  spec {
    policy_types = ["Ingress"]

    pod_selector {
      match_labels = {
        component = "backend"
      }
    }

    ingress {

      ports {
        port     = "3000"
        protocol = "TCP"
      }

      from {
        namespace_selector {
          match_labels = {
            name = "frontend"
          }
        }

        pod_selector {
          match_labels = {
            component = "frontend"
          }
        }
      }
    }
  }
}

resource "kubernetes_network_policy" "allow_backend_egress" {
  metadata {
    name      = "allow-backend-egress"
    namespace = "backend"
  }

  spec {
    policy_types = ["Egress"]

    pod_selector {
      match_labels = {
        component = "backend"
      }
    }

    egress {

      ports {
        port     = "3001"
        protocol = "TCP"
      }
    }
  }
}

resource "kubernetes_network_policy" "allow_frontend_ingress" {
  metadata {
    name      = "allow-frontend-ingress"
    namespace = "frontend"
  }

  spec {
    policy_types = ["Ingress"]

    pod_selector {
      match_labels = {
        component = "frontend"
      }
    }

    ingress {
      ports {
        port     = "3001"
        protocol = "TCP"
      }
    }
  }
}