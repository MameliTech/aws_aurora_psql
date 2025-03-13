#==================================================================
# aurora-psql - iam.tf
#==================================================================

#------------------------------------------------------------------
# IAM Policy - RDS Aurora PostgreSQL Cluster - Read-Only
#------------------------------------------------------------------
resource "aws_iam_policy" "aurora-psql_ro" {
  name = local.iam_db_ro

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ReadOnly",
        "Effect" : "Allow",
        "Action" : [
          "rds:DescribeDBClusterAutomatedBackups",
          "rds:DescribeDBClusterBacktracks",
          "rds:DescribeDBClusterEndpoints",
          "rds:DescribeDBClusterParameterGroups",
          "rds:DescribeDBClusterParameters",
          "rds:DescribeDBClusters",
          "rds:DescribeDBClusterSnapshotAttributes",
          "rds:DescribeDBClusterSnapshots",
          "rds:DescribeDBEngineVersions",
          "rds:DescribeDBInstanceAutomatedBackups",
          "rds:DescribeDBInstances",
          "rds:DescribeDBLogFiles",
          "rds:DescribeDBParameterGroups",
          "rds:DescribeDBParameters",
          "rds:DescribeDBSecurityGroups",
          "rds:DescribeDBSnapshotAttributes",
          "rds:DescribeDBSnapshots",
          "rds:DescribeDBSubnetGroups",
          "rds:DownloadCompleteDBLogFile",
          "rds:DownloadDBLogFilePortion",
          "rds:ListTagsForResource"
        ],
        "Resource" : [
          join(",", [for sg_id in aws_rds_cluster.this.vpc_security_group_ids : format("arn:aws:ec2:${local.account_region}:${local.account_id}:security-group/${sg_id}")]),
          aws_db_subnet_group.this.arn,
          aws_rds_cluster_parameter_group.this.arn,
          aws_rds_cluster.this.arn,
          join(",", [for instance_arn in aws_rds_cluster_instance.this[*].arn : format("${instance_arn}")]),
          "arn:aws:rds:${local.account_region}:${local.account_id}:cluster-snapshot:${local.cluster_identifier}-*-*",
          "arn:aws:rds:${local.account_region}:${local.account_id}:snapshot:${local.cluster_identifier}-inst*-*-*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_db_ro }
}


#------------------------------------------------------------------
# IAM Policy - RDS Aurora PostgreSQL Cluster - Operator
#------------------------------------------------------------------
resource "aws_iam_policy" "aurora-psql_op" {
  name = local.iam_db_op

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Operator",
        "Effect" : "Allow",
        "Action" : [
          "rds:DescribeDBClusterAutomatedBackups",
          "rds:DescribeDBClusterBacktracks",
          "rds:DescribeDBClusterEndpoints",
          "rds:DescribeDBClusterParameterGroups",
          "rds:DescribeDBClusterParameters",
          "rds:DescribeDBClusters",
          "rds:DescribeDBClusterSnapshotAttributes",
          "rds:DescribeDBClusterSnapshots",
          "rds:DescribeDBEngineVersions",
          "rds:DescribeDBInstanceAutomatedBackups",
          "rds:DescribeDBInstances",
          "rds:DescribeDBLogFiles",
          "rds:DescribeDBParameterGroups",
          "rds:DescribeDBParameters",
          "rds:DescribeDBSecurityGroups",
          "rds:DescribeDBSnapshotAttributes",
          "rds:DescribeDBSnapshots",
          "rds:DescribeDBSubnetGroups",
          "rds:DownloadCompleteDBLogFile",
          "rds:DownloadDBLogFilePortion",
          "rds:ListTagsForResource",
          "rds:CopyDBClusterSnapshot",
          "rds:CopyDBSnapshot",
          "rds:CreateDBClusterSnapshot",
          "rds:CreateDBSnapshot",
          "rds:RebootDBCluster",
          "rds:RebootDBInstance",
          "rds:StartDBCluster",
          "rds:StartDBInstance",
          "rds:StopDBCluster",
          "rds:StopDBInstance"
        ],
        "Resource" : [
          join(",", [for sg_id in aws_rds_cluster.this.vpc_security_group_ids : format("arn:aws:ec2:${local.account_region}:${local.account_id}:security-group/${sg_id}")]),
          aws_db_subnet_group.this.arn,
          aws_rds_cluster_parameter_group.this.arn,
          aws_rds_cluster.this.arn,
          join(",", [for instance_arn in aws_rds_cluster_instance.this[*].arn : format("${instance_arn}")]),
          "arn:aws:rds:${local.account_region}:${local.account_id}:cluster-snapshot:${local.cluster_identifier}-*-*",
          "arn:aws:rds:${local.account_region}:${local.account_id}:snapshot:${local.cluster_identifier}-inst*-*-*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_db_op }
}


#------------------------------------------------------------------
# IAM Policy - RDS Aurora PostgreSQL Cluster - Power User
#------------------------------------------------------------------
resource "aws_iam_policy" "aurora-psql_pu" {
  name = local.iam_db_pu

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PowerUser",
        "Effect" : "Allow",
        "Action" : [
          "rds:DescribeDBClusterAutomatedBackups",
          "rds:DescribeDBClusterBacktracks",
          "rds:DescribeDBClusterEndpoints",
          "rds:DescribeDBClusterParameterGroups",
          "rds:DescribeDBClusterParameters",
          "rds:DescribeDBClusters",
          "rds:DescribeDBClusterSnapshotAttributes",
          "rds:DescribeDBClusterSnapshots",
          "rds:DescribeDBEngineVersions",
          "rds:DescribeDBInstanceAutomatedBackups",
          "rds:DescribeDBInstances",
          "rds:DescribeDBLogFiles",
          "rds:DescribeDBParameterGroups",
          "rds:DescribeDBParameters",
          "rds:DescribeDBSecurityGroups",
          "rds:DescribeDBSnapshotAttributes",
          "rds:DescribeDBSnapshots",
          "rds:DescribeDBSubnetGroups",
          "rds:DownloadCompleteDBLogFile",
          "rds:DownloadDBLogFilePortion",
          "rds:ListTagsForResource",
          "rds:CopyDBClusterSnapshot",
          "rds:CopyDBSnapshot",
          "rds:CreateDBClusterSnapshot",
          "rds:CreateDBSnapshot",
          "rds:RebootDBCluster",
          "rds:RebootDBInstance",
          "rds:StartDBCluster",
          "rds:StartDBInstance",
          "rds:StopDBCluster",
          "rds:StopDBInstance",
          "rds:BacktrackDBCluster",
          "rds:DeleteDBClusterSnapshot",
          "rds:DeleteDBSnapshot",
          "rds:RestoreDBClusterFromSnapshot",
          "rds:RestoreDBClusterToPointInTime",
          "rds:RestoreDBInstanceFromDBSnapshot",
          "rds:RestoreDBInstanceToPointInTime"
        ],
        "Resource" : [
          join(",", [for sg_id in aws_rds_cluster.this.vpc_security_group_ids : format("arn:aws:ec2:${local.account_region}:${local.account_id}:security-group/${sg_id}")]),
          aws_db_subnet_group.this.arn,
          aws_rds_cluster_parameter_group.this.arn,
          aws_rds_cluster.this.arn,
          join(",", [for instance_arn in aws_rds_cluster_instance.this[*].arn : format("${instance_arn}")]),
          "arn:aws:rds:${local.account_region}:${local.account_id}:cluster-snapshot:${local.cluster_identifier}-*-*",
          "arn:aws:rds:${local.account_region}:${local.account_id}:snapshot:${local.cluster_identifier}-inst*-*-*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_db_pu }
}


#------------------------------------------------------------------
# IAM Policy - Secret - Read-Only
#------------------------------------------------------------------
resource "aws_iam_policy" "secret_ro" {
  name = local.iam_secret_ro

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ReadOnly",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : aws_secretsmanager_secret.this.arn,
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_secret_ro }
}


#------------------------------------------------------------------
# IAM Policy - CloudWatch - Read-Write
#------------------------------------------------------------------
resource "aws_iam_role" "cloudwatch_rw" {
  name = local.iam_cw_rw

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ReadWrite",
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = { "Name" : local.iam_cw_rw }
}


resource "aws_iam_policy" "cloudwatch_rw" {
  name = local.iam_cw_rw

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "EnableCreationAndManagementOfRDSCloudWatchLogGroups",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:PutRetentionPolicy",
          "logs:DeleteLogGroup"
        ],
        "Resource" : "arn:aws:logs:${local.account_region}:${local.account_id}:log-group:RDS*",
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      },
      {
        "Sid" : "EnableCreationAndManagementOfRDSCloudwatchLogStreams",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:DeleteLogStream"
        ],
        "Resource" : "arn:aws:logs:${local.account_region}:${local.account_id}:log-group:RDS*:log-stream:*",
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_cw_rw }
}


resource "aws_iam_role_policy_attachment" "cloudwatch_rw" {
  policy_arn = aws_iam_policy.cloudwatch_rw.arn
  role       = aws_iam_role.cloudwatch_rw.name
}
