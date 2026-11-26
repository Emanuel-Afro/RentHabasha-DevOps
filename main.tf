module "Networking" {
  source                      = "./modules/Networking"
  enviroment                  = var.enviroment
  rent_habesha_vpc            = var.rent_habesha_vpc
  region                      = var.region
  rent_habesha_public_subnet  = var.rent_habesha_public_subnet
  rent_habesha_private_subnet = var.rent_habesha_private_subnet
  public_rt                   = var.public_rt
  private_rt                  = var.private_rt
}
module "Compute" {
  source                        = "./modules/Compute"
  rent_habesha_vpc              = module.Networking.rent_habesha_vpc
  rent_habesha_private_subnet   = module.Networking.rent_habesha_private_subnet
  enviroment                    = var.enviroment
  cluster_version               = var.cluster_version
  worker_node_policy            = var.worker_node_policy
  rent_habesha_alb_ingress_rule = var.rent_habesha_alb_ingress_rule
}