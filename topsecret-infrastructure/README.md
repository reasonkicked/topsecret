A terraform project for creating HA infrastructure for wordpress site.

Modules:
1. "netwrork" - VPC containing IGW, subnets in two different AZ-s, private and public subnets with NAT GW-s
2. "cdn" - s3 buckets for media and code objects and cloudfront distribution for media objects
3. "ec2" - ec2 instance with launch configuration for setup wordpress engine and write node (temporary in private subnet with eip)
4. "rds-db-instance" - mysql RDS db with multi-az
5. "web-server-cluster" - ASG as a read nodes target group for ALB 
6. temporary module ec2-key-pair for ssh

How to run:
1. run modules network, cdn, ec2, ec2-key-pair using terraform.tfvars
2. configure ec2 connection between RDS and CDN (instructions in projekt.docx) for read node
3. make AMI of configured ec2 instance and use this AMI for launching web-server-cluster module
4. run additional setup from project.docx for write node

5. manually create and validate certificate in aws certificate manager
