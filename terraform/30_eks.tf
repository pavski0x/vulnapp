module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name = var.cluster_name
  cluster_version = "1.27"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  
  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 10
  }

  eks_managed_node_groups = {
    general = {
        desired_size = 1
        min_size = 1
        max_sixe = 2

        labels = {
            role = "general"
        }
        instance_types = ["t3.small"]
        capacity_type = "ON_DEMAND"
    }
  }

  manage_aws_auth_configmap = true
#   create_aws_auth_configmap = true

}