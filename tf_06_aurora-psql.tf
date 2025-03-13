#==================================================================
# aurora-psql.tf
#==================================================================

#------------------------------------------------------------------
# Random Password
#------------------------------------------------------------------
resource "random_password" "password" {
  length           = var.password_length
  special          = var.password_special_char
  override_special = "*-_[}<>:?"

  lifecycle {
    ignore_changes = [
      length,
      special,
      override_special
    ]
  }
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster - Subnet Group
#------------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name        = local.subnet_group
  description = "Database Subnet Group used by ${local.cluster_identifier}"
  subnet_ids  = data.aws_subnets.private_subnets.ids

  tags = { "Name" : local.subnet_group }
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster - Parameter Group
#------------------------------------------------------------------
locals {
  parameter_group_parameters = merge(var.parameter_group_default_parameters, var.parameter_group_aditional_parameters)
  parameter_list = flatten([
    for param_name, param_data in local.parameter_group_parameters :
    {
      name         = param_name
      value        = param_data.value
      apply_method = param_data.apply_method
    }
  ])
}


resource "aws_rds_cluster_parameter_group" "this" {
  name        = local.parameter_group
  description = "Parameter Group used by ${local.cluster_identifier}"
  family      = var.family

  dynamic "parameter" {
    for_each = local.parameter_group_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = { "Name" : local.parameter_group }
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster
#------------------------------------------------------------------
resource "aws_rds_cluster" "this" {
  apply_immediately                   = var.apply_immediately
  backtrack_window                    = var.backtrack_window
  backup_retention_period             = var.backup_retention_period
  cluster_identifier                  = local.cluster_identifier
  copy_tags_to_snapshot               = true
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.this.name
  db_subnet_group_name                = aws_db_subnet_group.this.name
  deletion_protection                 = var.deletion_protection
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  engine                              = "aurora-postgresql"
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version
  iam_database_authentication_enabled = true
  kms_key_id                          = var.kms_key_id != "" ? var.kms_key_id : (var.create_kms_key ? module.kms-key[0].kms-key_arn : null)
  master_password                     = random_password.password.result
  master_username                     = var.master_username
  port                                = var.port
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  skip_final_snapshot                 = var.skip_final_snapshot
  storage_type                        = var.storage_type
  storage_encrypted                   = true
  vpc_security_group_ids              = length(var.security_group_ids) > 0 ? var.security_group_ids : [module.security-group[0].id]

  tags = { "Name" : local.cluster_identifier }

  lifecycle {
    ignore_changes = [
      availability_zones,
      engine_version,
      master_password,
      master_username,
      tags
    ]
  }
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster - Instance
#------------------------------------------------------------------
resource "aws_rds_cluster_instance" "this" {
  count                                 = var.instance_count
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  availability_zone                     = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
  ca_cert_identifier                    = var.ca_cert_identifier
  cluster_identifier                    = aws_rds_cluster.this.id
  engine_version                        = aws_rds_cluster.this.engine_version
  engine                                = aws_rds_cluster.this.engine
  identifier                            = "${local.cluster_identifier}-inst${count.index}"
  instance_class                        = var.instance_class
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = aws_iam_role.cloudwatch_rw.arn
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.kms_key_id != "" ? var.kms_key_id : (var.create_kms_key ? module.kms-key[0].kms-key_arn : null) : null
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  preferred_maintenance_window          = var.preferred_maintenance_window

  tags = var.code_guru_tag_name == "" ? { "Name" : "${local.cluster_identifier}${count.index}" } : {
    "Name" : "${local.cluster_identifier}${count.index}"
    "${var.code_guru_tag_name}" : var.code_guru_tag_value
  }
}
