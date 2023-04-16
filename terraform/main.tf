module "k8s_service_account" {
  source       = "./modules/service_accounts"
  account_id   = var.k8s_account_id
  display_name = var.k8s_display_name
  roles        = var.k8s_roles
}
