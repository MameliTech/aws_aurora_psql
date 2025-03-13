# AWS RDS Aurora PostgreSQL Cluster

![Provedor](https://img.shields.io/badge/provider-AWS-orange) ![Engine](https://img.shields.io/badge/engine-AuroraPostgreSQL-blueviolet) ![Versão](https://img.shields.io/badge/version-v.1.0.0-success) ![Coordenação](https://img.shields.io/badge/coord.-Mameli_Tech-informational)<br>

Módulo desenvolvido para o provisionamento de **AWS RDS Aurora PostgreSQL Cluster**.

Este módulo tem como objetivo criar um RDS Aurora PostgreSQL Cluster seguindo os padrões da Mameli Tech.

Serão criados os seguintes recursos:
1. **RDS Aurora PostgreSQL Cluster** com o nome no padrão <span style="font-size: 12px;">`NomeDaEquipe-NomeDaAplicação-Ambiente-FunçãoDoRecurso-aurpsql`</span>
2. **RDS Aurora PostgreSQL Cluster DB Instances** com o nome no padrão <span style="font-size: 12px;">`NomeDaEquipe-NomeDaAplicação-Ambiente-FunçãoDoRecurso-aurpsql-instNúmero`</span>
3. **KMS Key** com o nome no padrão <span style="font-size: 12px;">`NomeDaEquipe-NomeDaAplicação-Ambiente-FunçãoDoRecurso-aurpsql-kms`</span>
4. **Secret** com o nome no padrão <span style="font-size: 12px;">`NomeDaEquipe-NomeDaAplicação-Ambiente-FunçãoDoRecurso-aurpsql-sm`</span>
5. **Security Group** com o nome no padrão <span style="font-size: 12px;">`NomeDaEquipe-NomeDaAplicação-Ambiente-FunçãoDoRecurso-aurpsql-sg`</span>
6. **IAM Policy** com permissão ***Read-Only*** ao RDS Aurora PostgreSQL Cluster com o nome no padrão <span style="font-size: 12px;">`NomeDaAplicação-Ambiente-FunçãoDoRecurso-AccessToDB_aurpsql_ro`</span>
7. **IAM Policy** com permissão ***Operator*** ao RDS Aurora PostgreSQL Cluster com o nome no padrão <span style="font-size: 12px;">`NomeDaAplicação-Ambiente-FunçãoDoRecurso-AccessToDB_aurpsql_op`</span>
8. **IAM Policy** com permissão ***Power User*** ao RDS Aurora PostgreSQL Cluster com o nome no padrão <span style="font-size: 12px;">`NomeDaAplicação-Ambiente-FunçãoDoRecurso-AccessToDB_aurpsql_pu`</span>
9. **IAM Policy** com permissão ***Read-Only*** ao Secret com o nome no padrão <span style="font-size: 12px;">`NomeDaAplicação-Ambiente-FunçãoDoRecurso-AccessToSM_aurpsql_ro`</span>
10. **IAM Policy** com permissão ***Read-Write*** ao CloudWatch com o nome no padrão <span style="font-size: 12px;">`NomeDaAplicação-Ambiente-FunçãoDoRecurso-AccessToCW_aurpsql_rw`</span>
<br>

## Como utilizar?

### Passo 1

Precisamos configurar o Terraform para armazenar o estado dos recursos criados.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_01_backend.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# backend.tf - Script de definicao do Backend
#==================================================================

terraform {
  backend "s3" {
    encrypt = true
  }
}
```

### Passo 2

Precisamos armazenar as definições de variáveis que serão utilizadas pelo Terraform.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_02_variables.tf` com o conteúdo a seguir.<br>
Caso exista, adicione o conteúdo abaixo no arquivo:

```hcl
#==================================================================
# variables.tf - Script de definicao de Variaveis
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
variable "account_region" {
  description = "Regiao onde os recursos serao alocados."
  type        = string
}


#------------------------------------------------------------------
# Data Source
#------------------------------------------------------------------
variable "foundation_squad" {
  description = "Nome da squad definida na VPC que sera utilizada."
  type        = string
}

variable "foundation_application" {
  description = "Nome da aplicacao definida na VPC que sera utilizada."
  type        = string
}

variable "foundation_environment" {
  description = "Acronimo do ambiente definido na VPC que sera utilizada."
  type        = string
}

variable "foundation_role" {
  description = "Nome da funcao definida na VPC que sera utilizada."
  type        = string
}


#------------------------------------------------------------------
# Resource Nomenclature & Tags
#------------------------------------------------------------------
variable "rn_squad" {
  description = "Nome da squad. Limitado a 8 caracteres."
  type        = string
}

variable "rn_application" {
  description = "Nome da aplicacao. Limitado a 8 caracteres."
  type        = string
}

variable "rn_environment" {
  description = "Acronimo do ambiente (dev/hml/prd/devops). Limitado a 6 caracteres."
  type        = string
}

variable "default_tags" {
  description = "TAGs padrao que serao adicionadas a todos os recursos."
  type        = map(string)
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster
#------------------------------------------------------------------
variable "aurora-psql" {
  type = map(object({
    rn_role                            = string
    create_kms_key                     = bool
    security_group_ids                 = optional(list(string))
    security_group_ingress_cidr_blocks = optional(list(string))
    security_group_ingress_sg_ids      = optional(list(string))
    family                             = optional(string)
    parameter_group_aditional_parameters = optional(map(object({
      name         = string
      value        = string
      apply_method = string
    })))
    backup_retention_period      = optional(number)
    deletion_protection          = bool
    kms_key_id                   = string
    storage_type                 = optional(string)
    instance_count               = number
    instance_class               = string
    performance_insights_enabled = bool
    code_guru_tag_name           = optional(string)
    code_guru_tag_value          = optional(string)
  }))
}
```

### Passo 3

Precisamos configurar informar o Terraform em qual região os recursos serão implementados.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_03_provider.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# provider.tf - Script de definicao do Provider
#==================================================================

provider "aws" {
  region = var.account_region

  default_tags {
    tags = var.default_tags
  }
}
```

### Passo 4

O script abaixo será responsável por criar o RDS Aurora PostgreSQL Cluster.<br>
Crie um arquivo no padrão `tf_NN_aurora-psql.tf` e adicione:

```hcl
#========================================================================
# aurora-psql - Script de chamada do modulo RDS Aurora PostgreSQL Cluster
#========================================================================

module "aurora-psql" {
  source   = "git@github.com:MameliTech/aws_aurora_psql.git"
  for_each = var.aurora-psql

  foundation_squad                     = var.foundation_squad
  foundation_application               = var.foundation_application
  foundation_environment               = var.foundation_environment
  foundation_role                      = var.foundation_role
  rn_squad                             = var.rn_squad
  rn_application                       = var.rn_application
  rn_environment                       = var.rn_environment
  rn_role                              = each.value.rn_role
  create_kms_key                       = each.value.create_kms_key
  security_group_ids                   = each.value.security_group_ids
  security_group_ingress_cidr_blocks   = each.value.security_group_ingress_cidr_blocks
  security_group_ingress_sg_ids        = each.value.security_group_ingress_sg_ids
  family                               = each.value.family
  parameter_group_aditional_parameters = each.value.parameter_group_aditional_parameters
  backup_retention_period              = each.value.backup_retention_period
  deletion_protection                  = each.value.deletion_protection
  kms_key_id                           = each.value.kms_key_id
  instance_count                       = each.value.instance_count
  instance_class                       = each.value.instance_class
  performance_insights_enabled         = each.value.performance_insights_enabled
  code_guru_tag_name                   = each.value.code_guru_tag_name
  code_guru_tag_value                  = each.value.code_guru_tag_value
}
```

### Passo 5

O script abaixo será responsável por gerar os Outputs dos recursos criados.<br>
Crie um arquivo no padrão `tf_99_outputs.tf` e adicione:

```hcl
#==================================================================
# outputs.tf - Script para geracao de Outputs
#==================================================================

output "all_outputs" {
  description = "All outputs"
  value       = module.aurora-psql
}
```

### Passo 6

Adicione uma pasta env com os arquivos `dev.tfvars`, `hml.tfvars` e `prd.tfvars`. Em cada um destes arquivos você irá informar os valores das variáveis que o módulo utiliza.

Segue um exemplo do conteúdo de um arquivo `tfvars`:

```hcl
#==================================================================
# <dev/hml/prd>.tfvars - Arquivo de definicao de Valores de Variaveis
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
account_region = "us-east-1"


#------------------------------------------------------------------
# Data Source
#------------------------------------------------------------------
foundation_squad       = "devops"
foundation_application = "sap"
foundation_environment = "dev"
foundation_role        = "sample"


#------------------------------------------------------------------
# Resource Nomenclature & Tags
#------------------------------------------------------------------
rn_squad       = "devops"
rn_application = "sapfi"
rn_environment = "dev"

default_tags = {
  "N_projeto" : "DevOps Lab"                                                            # Nome do projeto
  "N_ccusto_ti" : "Mameli-TI-2025"                                                      # Centro de Custo TI
  "N_ccusto_neg" : "Mameli-Business-2025"                                               # Centro de Custo Negocio
  "N_info" : "Para maiores informacoes procure a Mameli Tech - consultor@mameli.com.br" # Informacoes adicionais
  "T_funcao" : "Aurora PostgreSQL Cluster"                                              # Funcao do recurso
  "T_versao" : "1.0"                                                                    # Versao de provisionamento do ambiente
  "T_backup" : "nao"                                                                    # Descritivo se sera realizado backup automaticamente dos recursos provisionados
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster
#------------------------------------------------------------------
aurora-psql = {

  # Exemplo que cria cluster, KMS Key e SG
  # create_kms_key (true) & kms_key_id ("")
  # vpc_security_group_id (null) & security_group_cidr_blocks (com lista de IPs para novo SG)
  dbcluster1 = {
    rn_role                       = "dbsapfi"
    create_kms_key                = true
    security_group_ids            = []
    security_group_cidr_blocks    = ["10.1.0.0/16"]
    security_group_ingress_sg_ids = []
    parameter_group_aditional_parameters = {
      "autovacuum_vacuum_scale_factor" = {
        name         = "autovacuum_vacuum_scale_factor"
        value        = "0.01"
        apply_method = "immediate"
      },
      "maintenance_work_mem" = {
        name         = "maintenance_work_mem"
        value        = "4194304"
        apply_method = "immediate"
      }
    }
    deletion_protection          = false
    kms_key_id                   = ""
    storage_type                 = "aurora-iopt1"
    instance_count               = 2
    instance_class               = "db.t3.medium"
    performance_insights_enabled = true
    code_guru_tag_name           = "devops-guru-prd-pacs"
    code_guru_tag_value          = "yes"
  },

  # Exemplo que cria cluster e usa KMS Key e SG existentes no ambiente
  # create_kms_key (true ou false) & kms_key_id (com ARN do KMS Key existente)
  # vpc_security_group_id (com ID do SG existente) & security_group_cidr_blocks (null)
  dbcluster2 = {
    rn_role                      = "dbsapco"
    create_kms_key               = false
    security_group_ids           = ["sg-0b607d3a4c3da8f3d"]
    security_group_cidr_blocks   = []
    kms_key_id                   = ""
    storage_type                 = "aurora-iopt1"
    instance_count               = 1
    instance_class               = "db.t3.medium"
    performance_insights_enabled = false
  }
}
```

<br>

## Requisitos

| Nome | Versão |
|------|---------|
| [Terraform]() | >= 1.10.5 |
| [AWS]() | ~> 5.84.0 |

<br>

## Recursos

| Nome | Tipo |
|------|------|
| [aws_db_subnet_group]() | resource |
| [aws_iam_policy]() | resource |
| [aws_iam_role]() | resource |
| [aws_iam_role_policy_attachment]() | resource |
| [aws_kms_alias]() | resource |
| [aws_kms_key]() | resource |
| [aws_rds_cluster]() | resource |
| [aws_rds_cluster_instance]() | resource |
| [aws_rds_cluster_parameter_group]() | resource |
| [aws_secretsmanager_secret]() | resource |
| [aws_secretsmanager_secret_version]() | resource |
| [aws_security_group]() | resource |

<br>

## Entradas do módulo

 A tabela a seguir segue a ordem presente no código.

| Nome | Descrição | Tipo | Default | Obrigatório |
|------|-----------|------|---------|:-----------:|
| [foundation_squad]() | Nome da squad definada na VPC que será utilizada. | `string` | `null` | sim |
| [foundation_application]() | Nome da aplicação definada na VPC que será utilizada. | `string` | `null` | sim |
| [foundation_environment]() | Acrônimo do ambiente definido na VPC que será utilizada. | `string` | `null` | sim |
| [foundation_role]() | Função definada na VPC que será utilizada. | `string` | `null` | sim |
| [rn_squad]() | Nome da squad. Limitado a 8 caracteres. | `string` | `null` | sim |
| [rn_application]() | Nome da aplicação. Limitado a 8 caracteres. | `string` | `null` | sim |
| [rn_environment]() | Acrônimo do ambiente (dev/hml/prd/devops). Limitado a 6 caracteres. | `string` | `null` | sim |
| [rn_role]() | Função do recurso. Limitado a 8 caracteres. | `string` | `null` | sim |
| [default_tags]() | TAGs padrão que serão adicionadas em todos os recursos. | `map(string)` | `null` | sim |
| [create_kms_key]() | Define se uma chave KMS deve ser criada. Criará apenas se não for informado ARN na variável kms_key_id. | `bool` | `false` | sim |
| [security_group_ids]() | Lista de IDs de Security Groups existentes para atrelar ao banco de dados. Informe null caso deseje criar um novo SG. | `list(string)` | `null` | sim |
| [security_group_cidr_blocks]() | Define a range de IPs para o novo Security Group. | `list(string)` | `null` | sim |
| [password_length]() | Quantidade de caracteres para a senha. | `number` | `16` | não |
| [password_special_char]() | Define se utiliza ou não caracteres especiais. | `bool` | `true` | não |
| [family]() | Define a família do Parameter Group. Ele especifica a versão principal do engine associado ao Parameter Group. | `string` | `aurora-postgresql16` | não |
| [apply_immediately]() | Define se modificações na configuração do cluster devem ser aplicadas imediatamente. Caso seja false, as modificações ocorrerão durante a janela de manutenção. | `bool` | `false` | não |
| [backtrack_window]() | Janela de backtrack (point in time recovery). O máximo são 72 horas. | `number` | `0` | não |
| [backup_retention_period]() | Quantidade de dias para manter backups. | `number` | `35` | não |
| [deletion_protection]() | Define se o cluster de banco de dados tem a proteção contra exclusão habilitada. | `bool` | `true` | não |
| [enabled_cloudwatch_logs_exports]() | Lista de tipos de log para exportar para CloudWatch. Os seguintes tipos de logs são suportados: `audit`, `error`, `general`, `slowquery`. | `list(string)` | `["audit", "error", "slowquery"]` | não |
| [engine_mode]() | Engine Mode do banco de dados. Os valores válidos são: global (apenas para Aurora MySQL 1.21 ou anterior), multimaster, parallelquery, provisioned ou serverless. | `string` | `provisioned` | não |
| [engine_version]() | Versão do Engine do banco de dados. | `string` | `16.4` | não |
| [kms_key_id]() | O ARN da chave KMS a ser usada na criptografia. Se não especificado, ou criará uma nova chave (caso a variável create_kms_key_id seja 'true') ou utilizará a chave padrão gerenciada pela AWS. | `string` | `""` | sim |
| [master_username]() | Nome do usuário mestre do banco de dados. | `string` | `admin` | não |
| [port]() | O número da porta para conexão com o cluster. | `number` | `5432` | não |
| [preferred_backup_window]() | Define a janela de backup. | `string` | `06:10-07:10` | não |
| [preferred_maintenance_window]() | Sintaxe da janela para executar manutenções: `ddd:hh24:mi-ddd:hh24:mi`. | `string` | `Sun:03:00-Sun:06:00` | não |
| [skip_final_snapshot]() | Define se um snapshot final será criado antes da exclusão do cluster de banco de dados. | `bool` | `true` | não |
| [instance_count]() | Quantidade de instâncias para o banco. | `number` | `null` | sim |
| [auto_minor_version_upgrade]() | Define se as atualizações menores automaticas devem ser aplicadas na instância. | `bool` | `true` | não |
| [ca_cert_identifier]() | Define o certificado CA da instância de banco de dados. O CA rds-ca-rsa2048-g1 permanece valido por mais tempo que a CA rds-ca-2019. | `string` | `rds-ca-rsa2048-g1` | não |
| [instance_class]() | Define o tamanho (classe) da instância. | `string` | `null` | sim |
| [monitoring_interval]() | O intervalo, em segundos, entre os pontos em que as métricas do Enhanced Monitoring são coletadas para a instância de banco de dados. | `number` | `30` | não |
| [performance_insights_enabled]() | Define se o Performance Insight deve ser ativado para a instância. | `bool` | `true` | não |
| [performance_insights_retention_period]() | Quantidade de tempo em dias para reter dados do Performance Insights. Os valores válidos são de 7 (free-tier) a 731 dias (2 anos). | `number` | `7` | não |

<br><br><hr>

<div align="right">

<strong> Data da última versão: &emsp; 12/03/2025 </strong>

</div>
