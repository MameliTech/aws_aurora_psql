#==================================================================
# aurora-psql - security-group.tf
#==================================================================

module "security-group" {
  source = "git@github.com:MameliTech/aws_security_group.git"
  count  = length(var.security_group_ids) == 0 ? 1 : 0

  foundation_squad           = var.foundation_squad
  foundation_application     = var.foundation_application
  foundation_environment     = var.foundation_environment
  foundation_role            = var.foundation_role
  rn_squad                   = var.rn_squad
  rn_application             = var.rn_application
  rn_environment             = var.rn_environment
  rn_role                    = var.rn_role
  resource_type_abbreviation = "aurorapsql"
  ingress = [{
    description     = "Allows access to port ${var.port}"
    from_port       = var.port
    to_port         = var.port
    protocol        = "TCP"
    cidr_blocks     = var.security_group_ingress_cidr_blocks
    security_groups = var.security_group_ingress_sg_ids
  }]
}
