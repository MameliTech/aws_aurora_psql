#==================================================================
# aurora-psql - datasource.tf
#==================================================================

#------------------------------------------------------------------
# Account ID
#------------------------------------------------------------------
data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}

output "account_id" {
  description = "O ID da conta AWS."
  value       = data.aws_caller_identity.current.account_id
}


#------------------------------------------------------------------
# Region
#------------------------------------------------------------------
data "aws_region" "current" {}
locals {
  account_region = data.aws_region.current.name
}

output "account_region" {
  description = "A regiao que hospeda os recursos."
  value       = data.aws_region.current.name
}


#------------------------------------------------------------------
# VPC
#------------------------------------------------------------------
data "aws_vpc" "this" {
  tags = {
    Name = "${var.foundation_squad}-${var.foundation_application}-${var.foundation_environment}-${var.foundation_role}-vpc"
  }
}


#------------------------------------------------------------------
# Private Subnets
#------------------------------------------------------------------
data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.foundation_squad}-${var.foundation_application}-${var.foundation_environment}-${var.foundation_role}-snet-priv*"]
  }
}


#------------------------------------------------------------------
# Public Subnets
#------------------------------------------------------------------
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.foundation_squad}-${var.foundation_application}-${var.foundation_environment}-${var.foundation_role}-snet-publ*"]
  }
}


#------------------------------------------------------------------
# Availability Zones
#------------------------------------------------------------------
data "aws_availability_zones" "available" {}


#------------------------------------------------------------------
# Default TAGs
#------------------------------------------------------------------
data "aws_default_tags" "tags" {}
