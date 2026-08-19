# Terraform AWS VPC
This module creates following resources 

1. VPC 
2. IGW with VPC association
3. Subnets -> public private database
4. Route tables -> Publlic private database
5. Associtaions and Routes
6. EIP
7. NAT gateway 
8. VPC peering with default VPC on condition
9. Route tables entries through peering

## Inputs
Project - (Required ) must provide
Environment - (Required ) must provide ex dev, prod, testing.

## Outputs
