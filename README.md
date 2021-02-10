# Interview

This is a self contained environment that creates the following resources:

 - VPC
 - Public and Private subnets
 - Internet Gateway and relevant route tables
 - Elastic IP for NAT Gateway
 - NAT Gateway (single instance) and relevant route tables
 - Public ALB
 - 3 EC2 instances in private subnets
 - Required target groups for Public ALB
 - Security groups

The outcome is, all 3 ec2 instances allowing you to reach the default nginx page from the ALB DNS name path /* from a public location.

## Additional

I wanted to create the EC2 instances with an AMI that already had nginx installed, but I couldn't find one that didn't require a subscription.  I wanted this to just work, so I created the NAT gateway so that the EC2 instances could install nginx using user_data.

Also tried to write it ready to be modularised, but I think I might be going overboard?
