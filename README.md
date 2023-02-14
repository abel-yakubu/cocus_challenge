# AWS Infrastructure as Code (IAC)
This code provides a Terraform configuration that creates an AWS infrastructure including a VPC with a public and a private subnet, an internet gateway, two route table associations, two security groups, and two instances (web server and database server). The resources are created in the us-west-2 region as specified in the variables.

## Prerequisites
The following is needed to use this code:

1. An AWS account with credentials (access key and secret key)
2. Terraform installed on your machine

### Resources
The following resources are created by this code:

AWS VPC: The virtual private cloud for the infrastructure.
AWS Subnets: One public subnet and one private subnet for the infrastructure.
AWS Internet Gateway: The gateway that enables communication between the VPC and the internet.
AWS Route Table Associations: Two associations that associate the public and private subnets with the default route table of the VPC.
AWS Route: A route that enables the instances in the public subnet to access the internet through the internet gateway.
AWS Security Groups: Two security groups for the instances in the public and private subnets.
AWS Instances: Two instances (web server and database server) in the public and private subnets, respectively.

#### Authors
This code was written by Abel Yakubu 