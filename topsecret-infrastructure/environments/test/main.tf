module "network" {
    source = "../../modules/network"
     
    project_name = var.project_name
    environment_tag = var.environment_tag
    owner_tag = var.owner_tag
    prefix    = var.prefix 
}
module "ec2_key_pair_01" {
    source = "../../modules/services/ec2-key-pair"
    name_of_key = "ec2_key_pair_01"
  public_key_path = "~/.ssh/id_rsa.pub"
}
module "cloudfront_oai_wp_01" {
  //for later purposes
  source = "../../modules/data-stores/cdn/cloudfront_oai_wp_01"
}

module "cdn_01" {
  source = "../../modules/data-stores/cdn"
  //depends_on = [ module.cloudfront_oai_wp_01 ]
  //oai_id = "origin-access-identity/cloudfront/
  prefix    = var.prefix  
  environment_tag = var.environment_tag
  media_s3_name = var.media_s3_name
  code_s3_name = var.code_s3_name
}

module "ec2_write_node_primary" {
    depends_on = [ module.network, module.ec2_key_pair_01, module.cdn_01 ]
    source = "../../modules/services/ec2"
    instance_ami = "ami-0e472933a1395e172"
    instance_type = "t2.micro"
    subnet_for_ec2 = module.network.subnet_03_id
  
    key_pair_for_ec2 = module.ec2_key_pair_01.key_pair_name
    security_groups_for_ec2 = [
        module.network.security_group_01_id,
        module.network.security_group_02_id,
        module.network.security_group_03_id
  ]
    
    project_name = var.project_name
    environment_tag = var.environment_tag
    owner_tag = var.owner_tag
    prefix    = var.prefix 
}


module "rds_db_instance_01" {
  source = "../../modules/data-stores/rds-db-instance"
  depends_on = [ module.network ]
  subnets_ids_list = [
    module.network.subnet_05_id,
    module.network.subnet_06_id]
  security_groups_ids_list = [
    module.network.security_group_04_id
  ]
  environment_tag = var.environment_tag
  prefix    = var.prefix  
}


module "web_server_cluster_01" {
    source = "../../modules/services/web-server-cluster"
    depends_on = [ module.network, module.ec2_key_pair_01, module.cdn_01, module.ec2_write_node_primary]

    //launch configuration
    instance_ami = "ami-0fd6e421ea040d53e" //custom read node ami
    instance_type = "t2.micro"
    key_pair_for_ec2 = module.ec2_key_pair_01.key_pair_name
    security_groups_for_ec2 = [
    module.network.security_group_01_id,
    module.network.security_group_02_id,
    module.network.security_group_03_id
  ]
  //asg
  min_size = 3
  max_size = 4
  health_check_grace_period = 30


  asg_subnets_ids_list = [
      module.network.subnet_03_id,
      module.network.subnet_04_id
  ]

  //alb
  load_balancer_name = "alb01"
  load_balancer_type = "application"
  load_balancer_subnets = [
    module.network.subnet_01_id,
    module.network.subnet_02_id
  ]
  load_balancer_security_groups    = [
    module.network.security_group_02_id,
    module.network.security_group_03_id
  ]


  //alb listener
  listener_content_type = "text/plain"
  listener_message_body = "404: page not found"
  listener_status_code  = 404

  //alb target group
  vpc_id   = module.network.vpc_01_id
  //listener rule 1
  //listener rule 2

  //target group attachment
  //target_group_arn = module.alb_target_group_02.alb_target_group_arn
  target_id        = module.ec2_write_node_primary.ec2_instance_id
  
  


    project_name = var.project_name
    environment_tag = var.environment_tag
    owner_tag = var.owner_tag
    prefix    = var.prefix 
}
