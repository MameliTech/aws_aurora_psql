#==================================================================
# aurora-psql - outputs.tf
#==================================================================

#------------------------------------------------------------------
# KMS Key
#------------------------------------------------------------------
output "kms-key_outputs" {
  description = "Todos os outputs do modulo KMS Key."
  value       = module.kms-key
}


#------------------------------------------------------------------
# Security Group
#------------------------------------------------------------------
output "security-group_outputs" {
  description = "Todos os outputs do modulo Security Group."
  value       = module.security-group
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster - Subnet Group
#------------------------------------------------------------------
output "subnet-group_id" {
  description = "O ID do Subnet Group do DB."
  value       = aws_db_subnet_group.this.id
}

output "subnet-group_name" {
  description = "O nome do Subnet Group do DB."
  value       = aws_db_subnet_group.this.name
}

output "subnet-group_description" {
  description = "A descrição do Subnet Group do DB."
  value       = aws_db_subnet_group.this.description
}

output "subnet-group_associated-subnets" {
  description = "As Subnets associadas ao Subnet Group do DB."
  value       = aws_db_subnet_group.this.subnet_ids
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster - Parameter Group
#------------------------------------------------------------------
output "cluster-parameter-group_id" {
  description = "O ID do Parameter Group."
  value       = aws_rds_cluster_parameter_group.this.id
}

output "cluster-parameter-group_name" {
  description = "O nome do Parameter Group."
  value       = aws_rds_cluster_parameter_group.this.name
}

output "cluster-parameter-group_family" {
  description = "A familia de parametros do Parameter Group."
  value       = aws_rds_cluster_parameter_group.this.family
}

output "cluster-parameter-group_description" {
  description = "A descricao do Parameter Group."
  value       = aws_rds_cluster_parameter_group.this.description
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster
#------------------------------------------------------------------
output "cluster_id" {
  description = "O ID do RDS Cluster."
  value       = aws_rds_cluster.this.id
}

output "cluster_arn" {
  description = "O ARN do RDS Cluster."
  value       = aws_rds_cluster.this.arn
}

output "cluster_endpoint" {
  description = "O endpoint do RDS Cluster."
  value       = aws_rds_cluster.this.endpoint
}

output "cluster_reader-endpoint" {
  description = "O endpoint de leitura do RDS Cluster."
  value       = aws_rds_cluster.this.reader_endpoint
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster - Instance
#------------------------------------------------------------------
output "cluster-instance_id" {
  description = "O ID da Instancia do RDS Cluster."
  value       = aws_rds_cluster_instance.this[*].id
}

output "cluster-instance_name" {
  description = "O nome da Instancia do RDS Cluster."
  value       = aws_rds_cluster_instance.this[*].identifier
}

output "cluster-instance_port" {
  description = "A porta da Instancia do RDS Cluster."
  value       = aws_rds_cluster_instance.this[*].port
}


#------------------------------------------------------------------
# Secrets Manager
#------------------------------------------------------------------
output "secret_id" {
  description = "O ID do Secret."
  value       = aws_secretsmanager_secret.this.id
}


#------------------------------------------------------------------
# IAM Policy
#------------------------------------------------------------------
output "policy_map" {
  description = "Mapa com ARNs de politicas de acesso ('acao' : 'arn')."
  value = {
    "aurora-psql_read-only" : aws_iam_policy.aurora-psql_ro.arn
    "aurora-psql_operator" : aws_iam_policy.aurora-psql_op.arn
    "aurora-psql_power-user" : aws_iam_policy.aurora-psql_pu.arn
    "secret_read-only" : aws_iam_policy.secret_ro.arn
    "cloudwatch_read-write" : aws_iam_policy.cloudwatch_rw.arn
  }
}
