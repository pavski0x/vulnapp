module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "eks_vpc"
  cidr = "10.0.0.0/16"

  azs = [ "eu-central-1a", "eu-central-1b" ]
  public_subnets = [ "10.0.1.0/24", "10.0.2.0/24" ]
  private_subnets = [ "10.0.10.0/24", "10.0.20.0/24" ]


  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

   enable_dns_hostnames = true
   enable_dns_support = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}