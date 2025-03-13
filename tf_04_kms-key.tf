#==================================================================
# aurora-psql - kms-key.tf
#==================================================================

module "kms-key" {
  source = "git@github.com:MameliTech/aws_kms_key.git"
  count  = var.create_kms_key && var.kms_key_id == "" ? 1 : 0

  foundation_squad           = var.foundation_squad
  foundation_application     = var.foundation_application
  foundation_environment     = var.foundation_environment
  foundation_role            = var.foundation_role
  rn_squad                   = var.rn_squad
  rn_application             = var.rn_application
  rn_environment             = var.rn_environment
  rn_role                    = var.rn_role
  resource_type_abbreviation = "aurorapsql"
}
