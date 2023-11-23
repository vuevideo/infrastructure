module "cloud_sql" {
  source                 = "./modules/sql"
  database_availability  = var.database_availability
  database_instance_name = var.database_instance_name
  database_name          = var.database_name
  database_network_link  = module.k8s_cluster_network.network_self_link
  database_password      = var.database_password
  database_tier          = var.database_tier
  database_user          = var.database_user
  database_version       = var.database_version

  depends_on = [module.k8s_cluster]
}
