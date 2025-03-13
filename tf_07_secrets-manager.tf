#==================================================================
# aurora-psql - secrets-manager.tf
#==================================================================

#------------------------------------------------------------------
# Secrets Manager
#------------------------------------------------------------------
resource "aws_secretsmanager_secret" "this" {
  name        = local.secret_manager
  description = "Secret to access ${local.cluster_identifier}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "secretsmanager.amazonaws.com"
        },
        "Action" : "secretsmanager:GetSecretValue",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "secretsmanager.amazonaws.com"
        },
        "Action" : [
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = { "Name" : local.secret_manager }

  lifecycle {
    create_before_destroy = true
  }
}


#------------------------------------------------------------------
# Secrets Manager - Version
#------------------------------------------------------------------
resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = <<EOF
    {
      "username" : "${aws_rds_cluster.this.master_username}",
      "password" : "${aws_rds_cluster.this.master_password}",
      "engine" : "${aws_rds_cluster.this.engine}",
      "host" : "${aws_rds_cluster.this.endpoint}",
      "port" : "${aws_rds_cluster.this.port}",
      "dbClusterIdentifier" : "${aws_rds_cluster.this.cluster_identifier}"
    }
  EOF
}
