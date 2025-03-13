#==================================================================
# aurora-psql - resource-names.tf
#==================================================================

locals {
  cluster_identifier = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-aurpsql"
  subnet_group       = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-aurpsql-snetgrp"
  parameter_group    = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-aurpsql-paramgrp"
  secret_manager     = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-aurpsql-sm"
  iam_db_ro          = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToDB_aurpsql_ro"
  iam_db_op          = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToDB_aurpsql_op"
  iam_db_pu          = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToDB_aurpsql_pu"
  iam_secret_ro      = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToSM_aurpsql_ro"
  iam_cw_rw          = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToCW_aurpsql_rw"
}
