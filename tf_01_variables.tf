#==================================================================
# aurora-psql - variables.tf
#==================================================================

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
# Resource Nomenclature
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

variable "rn_role" {
  description = "Funcao do recurso. Limitado a 8 caracteres."
  type        = string
}


#------------------------------------------------------------------
# KMS Key
#------------------------------------------------------------------
variable "create_kms_key" {
  description = "Define se uma chave KMS deve ser criada. Criara apenas se nao for informado ARN na variavel kms_key_id."
  type        = bool
  default     = false
}


#------------------------------------------------------------------
# Security Group
#------------------------------------------------------------------
variable "security_group_ids" {
  description = "Lista de IDs de Security Groups existentes para atrelar ao banco de dados. Informe '[]' caso deseje criar um novo SG."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "security_group_ingress_cidr_blocks" {
  description = "Lista de range de IPs para permitir acesso ao novo Security Group."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "security_group_ingress_sg_ids" {
  description = "Lista de Security Group ID's para permitir acesso ao novo Security Group."
  type        = list(string)
  default     = []
  nullable    = false
}


#------------------------------------------------------------------
# Random Password
#------------------------------------------------------------------
variable "password_length" {
  description = "Quantidade de caracteres para a senha."
  type        = number
  default     = 20
}

variable "password_special_char" {
  description = "Define se utiliza ou nao caracteres especiais."
  type        = bool
  default     = true
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster - Parameter Group
#------------------------------------------------------------------
variable "family" {
  description = "Define a familia do Parameter Group. Ele especifica a versao principal do engine associado ao Parameter Group."
  type        = string
  default     = "aurora-postgresql16"
}

variable "parameter_group_default_parameters" {
  description = "Parametros default para o Parameter Group que sao diferentes do padrao fornecido pela Family."
  type = map(object({
    name         = string
    value        = string
    apply_method = string
  }))
  default = {
    "autovacuum" = {
      name         = "autovacuum"
      value        = "1"
      apply_method = "immediate"
    },
    "autovacuum_analyze_scale_factor" = {
      name         = "autovacuum_analyze_scale_factor"
      value        = "0.05"
      apply_method = "immediate"
    },
    "autovacuum_vacuum_scale_factor" = {
      name         = "autovacuum_vacuum_scale_factor"
      value        = "0.01"
      apply_method = "immediate"
    },
    "max_parallel_workers" = {
      name         = "max_parallel_workers"
      value        = "2"
      apply_method = "immediate"
    },
    "work_mem" = {
      name         = "work_mem"
      value        = "100000"
      apply_method = "immediate"
    }
  }
  nullable = false
}

variable "parameter_group_aditional_parameters" {
  description = "Parametros adicionais para o Parameter Group que sao diferentes do padrao fornecido pela Family."
  type = map(object({
    name         = string
    value        = string
    apply_method = string
  }))
  default  = {}
  nullable = false
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster
#------------------------------------------------------------------
variable "apply_immediately" {
  description = "Define se modificacoes na configuracao do cluster devem ser aplicadas imediatamente. Caso seja false, as modificacoes ocorrerao durante a janela de manutencao."
  type        = bool
  default     = false
  nullable    = false
}

variable "backtrack_window" {
  description = "Janela de backtrack (point in time recovery). O maximo sao 72 horas."
  type        = number
  default     = 0
}

variable "backup_retention_period" {
  description = "Quantidade de dias para manter backups."
  type        = string
  default     = 7
  nullable    = false
}

variable "deletion_protection" {
  description = "Define se o cluster de banco de dados tem a protecao contra exclusao habilitada."
  type        = bool
  default     = true
  nullable    = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Lista de tipos de log para exportar para CloudWatch. Os seguintes tipos de logs sao suportados: `audit`, `error`, `general`, `slowquery`."
  type        = list(string)
  default     = ["postgresql"]
  nullable    = false
}

variable "engine_mode" {
  description = "Engine Mode do banco de dados. Os valores validos sao: global (apenas para Aurora MySQL 1.21 ou anterior), multimaster, parallelquery, provisioned ou serverless."
  type        = string
  default     = "provisioned"
  nullable    = false
}

variable "engine_version" {
  description = "Versao do Engine do banco de dados."
  type        = string
  default     = "16.4"
  nullable    = false
}

variable "kms_key_id" {
  description = "O ARN da chave KMS a ser usada na criptografia. Se nao especificado, ou criara uma nova chave (caso a variavel create_kms_key seja 'true') ou utilizara a chave padrao gerenciada pela AWS."
  type        = string
  default     = ""
  nullable    = false
}

variable "master_username" {
  description = "Nome do usuario mestre do banco de dados."
  type        = string
  default     = "postgres"
  nullable    = false
}

variable "port" {
  description = "O numero da porta para conexao com o cluster."
  type        = number
  default     = "5432"
  nullable    = false
}

variable "preferred_backup_window" {
  description = "Define a janela de backup."
  type        = string
  default     = "04:00-05:00"
  nullable    = false
}

variable "preferred_maintenance_window" {
  description = "Sintaxe da janela para executar manutencoes: `ddd:hh24:mi-ddd:hh24:mi`."
  type        = string
  default     = "Sun:02:00-Sun:03:00"
  nullable    = false
}

variable "skip_final_snapshot" {
  description = "Define se um snapshot final sera criado antes da exclusao do cluster de banco de dados."
  type        = bool
  default     = true
  nullable    = false
}

variable "storage_type" {
  description = "Define o tipo do disco. Os valores validos sao: '' para standard ou 'aurora-iopt1'."
  type        = string
  default     = ""
  nullable    = false
}


#------------------------------------------------------------------
# RDS Aurora PostgreSQL Cluster - Instance
#------------------------------------------------------------------
variable "instance_count" {
  description = "Quantidade de instancias para o banco."
  type        = number
}

variable "auto_minor_version_upgrade" {
  description = "Define se as atualizacoes menores automaticas devem ser aplicadas na instancia."
  type        = bool
  default     = true
  nullable    = false
}

variable "ca_cert_identifier" {
  description = "Define o certificado CA da instancia de banco de dados. O CA rds-ca-rsa2048-g1 permanece valido por mais tempo que a CA rds-ca-2019."
  type        = string
  default     = "rds-ca-rsa2048-g1"
  nullable    = false
}

variable "instance_class" {
  description = "Define o tamanho (classe) da instancia."
  type        = string
}

variable "monitoring_interval" {
  description = "O intervalo, em segundos, entre os pontos em que as metricas do Enhanced Monitoring sao coletadas para a instancia de banco de dados."
  type        = number
  default     = 60
}

variable "performance_insights_enabled" {
  description = "Define se o Performance Insight deve ser ativado para a instancia."
  type        = bool
  default     = true
  nullable    = false
}

variable "performance_insights_retention_period" {
  description = "Quantidade de tempo em dias para reter dados do Performance Insights. Os valores validos sao de 7 (free-tier) a 731 dias (2 anos)."
  type        = number
  default     = 7
}

variable "code_guru_tag_name" {
  description = "Nome da TAG que habilita o CodeGuru para o cluster. Se vazio, o CodeGuru estara desabilitado."
  type        = string
  default     = ""
  nullable    = false
}

variable "code_guru_tag_value" {
  description = "Valor para a TAG do CodeGuru."
  type        = string
  default     = ""
  nullable    = false
}
