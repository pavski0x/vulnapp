module "mongodb_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/mongodb"

  name        = "mongo-sg"
  description = "Security group for mongo-db"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.mongodb_allowed_prefix]
}

module "mongo_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "mongo_ssh_sg"
  description = "Security group allowing ssh to DB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.mongodb_allowed_prefix]
}

module "bastion_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "bastion_ssh_sg"
  description = "Security group allowing ssh to public bastion"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [var.bastion_allowed_prefix]
}

module "mongodb_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "mongodb_instance"

  instance_type = "t3.small"
  associate_public_ip_address = false
  private_ip = "10.0.10.10"
  monitoring             = true
  vpc_security_group_ids = [ module.mongodb_sg.security_group_id, module.mongo_ssh_sg.security_group_id ]
  subnet_id              = module.vpc.private_subnets.0

  iam_instance_profile = aws_iam_instance_profile.mongodb_instance_profile.name


  # Private AMI al2-2021-mongodb5.0
  ami = "ami-02390f43b7e3851aa"
}



module "bastion_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "bastion_instance"

  instance_type = "t3.small"
  associate_public_ip_address = true
  monitoring             = true
  vpc_security_group_ids = [ module.bastion_ssh_sg.security_group_id ]
  subnet_id              = module.vpc.public_subnets.0
  
  iam_instance_profile = aws_iam_instance_profile.bastion_instance_profile.name

  # Amazon Linux 2 AMI (HVM) - Kernel 5.10
  # ami = "ami-0094635555ed28881"
  
  # Private with mongodb backups scheduled
  ami = "ami-0309ae3c27ab2652d"
}



