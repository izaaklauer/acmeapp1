project = "acmeapp1"

app "acmeapp1" {
  labels = {
    "owner" = "izaak",
    "corp" = "acmecorp"
  }

  build {
    use "pack" {}

    registry {
      use "aws-ecr" {
        region     = "us-east-1"
        repository = var.ecr_registry
        tag        = gitrefpretty()
      }
    }
  }

  deploy {
    workspace "dev" {
      use "aws-ecs" {
        count = 1
        memory = "512"
        cpu = 1024
        service_port = 3000
        assign_public_ip = false

        cluster = var.ecs_cluster_dev
        log_group = var.log_group_dev
        execution_role_name = var.execution_role_name_dev
        task_role_name = var.task_role_name_dev
        security_group_ids = [
          var.app_security_group_id_dev,
          internal_security_group_id_dev,
        ]
        region = var.region
        subnets = [
          var.subnets_dev_1,
          var.subnets_dev_2,
          var.subnets_dev_3,
          var.subnets_dev_4,
          var.subnets_dev_5,
        ]
        logging {
          create_group = false
          region       = var.region
        }
        alb {
          listener_arn = var.alb_listener_arn_dev
        }
      }
    }
  }

  workspace "prod" {
    use "aws-ecs" {
      count = 1
      memory = "512"
      cpu = 1024
      service_port = 3000
      assign_public_ip = false

      cluster = var.ecs_cluster_prod
      log_group = var.log_group_prod
      execution_role_name = var.execution_role_name_prod
      task_role_name = var.task_role_name_prod
      security_group_ids = [
        var.app_security_group_id_prod,
        internal_security_group_id_prod,
      ]
      region = var.region
      subnets = [
        var.subnets_prod_1,
        var.subnets_prod_2,
        var.subnets_prod_3,
        var.subnets_prod_4,
        var.subnets_prod_5,
      ]
      logging {
        create_group = false
        region       = var.region
      }
      alb {
        listener_arn = var.alb_listener_arn_prod
      }
    }
  }
}

}

### All environments

variable "ecr_registry" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-all-us-east-1"
    output       = "ecr_repository_name"
  })
  type    = string
  sensitive   = false
  description = "name of the ecs cluster to deploy into"
}

### Dev
variable "ecs_cluster_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "ecs_cluster_name"
  })
  type        = string
  sensitive   = false
  description = "name of the ecs cluster to deploy into in dev"
}

variable "log_group_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "microservice-infra-dev-us-east-1"
    output       = "log_group_name"
  })
  type        = string
  sensitive   = false
  description = "name of the log group in dev"
}

variable "execution_role_name_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "execution_role_name"
  })
  type        = string
  sensitive   = false
  description = "name of the ecs execution role in dev"
}

variable "task_role_name_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "task_role_name"
  })
  type        = string
  sensitive   = false
  description = "name of the ecs task role in dev"
}

variable "region_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "region"
  })
  type        = string
  sensitive   = false
  description = "aws region for dev"
}

variable "alb_listener_arn_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "alb_listener_arn"
  })
  type        = string
  sensitive   = false
  description = "arn of the aws alb in dev"
}

variable "app_security_group_id_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "app_security_group_id"
  })
  type        = string
  sensitive   = false
  description = "security group for this app in particular in dev"
}

variable "internal_security_group_id_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "internal_security_group_id"
  })
  type        = string
  sensitive   = false
  description = "security group for all internal services in dev"
}

# Waypoint is unable to consume list type dynamic defaults

variable "subnet_1_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "ecs_task_subnet_1"
  })
  type        = string
  sensitive   = false
  description = "name of first ecs task role in dev"
}

variable "subnet_2_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "ecs_task_subnet_2"
  })
  type        = string
  sensitive   = false
  description = "name of second ecs task role in dev"
}

variable "subnet_3_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "ecs_task_subnet_3"
  })
  type        = string
  sensitive   = false
  description = "name of third ecs task role in dev"
}

variable "subnet_4_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "ecs_task_subnet_4"
  })
  type        = string
  sensitive   = false
  description = "name of fourth ecs task role in dev"
}

variable "subnet_5_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "ecs_task_subnet_5"
  })
  type        = string
  sensitive   = false
  description = "name of fifth ecs task role in dev"
}

### Prod
variable "ecs_cluster_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "ecs_cluster_name"
  })
  type        = string
  sensitive   = false
  description = "name of the ecs cluster to deploy into in prod"
}

variable "log_group_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "microservice-infra-prod-us-east-1"
    output       = "log_group_name"
  })
  type        = string
  sensitive   = false
  description = "name of the log group in prod"
}

variable "execution_role_name_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "execution_role_name"
  })
  type        = string
  sensitive   = false
  description = "name of the ecs execution role in prod"
}

variable "task_role_name_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "task_role_name"
  })
  type        = string
  sensitive   = false
  description = "name of the ecs task role in prod"
}

variable "region_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "region"
  })
  type        = string
  sensitive   = false
  description = "aws region for prod"
}

variable "alb_listener_arn_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "alb_listener_arn"
  })
  type        = string
  sensitive   = false
  description = "arn of the aws alb in prod"
}

variable "app_security_group_id_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "app_security_group_id"
  })
  type        = string
  sensitive   = false
  description = "security group for this app in particular in prod"
}

variable "internal_security_group_id_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "internal_security_group_id"
  })
  type        = string
  sensitive   = false
  description = "security group for all internal services in prod"
}

# Waypoint is unable to consume list type dynamic defaults

variable "subnet_1_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "ecs_task_subnet_1"
  })
  type        = string
  sensitive   = false
  description = "name of first ecs task role in prod"
}

variable "subnet_2_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "ecs_task_subnet_2"
  })
  type        = string
  sensitive   = false
  description = "name of second ecs task role in prod"
}

variable "subnet_3_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "ecs_task_subnet_3"
  })
  type        = string
  sensitive   = false
  description = "name of third ecs task role in prod"
}

variable "subnet_4_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "ecs_task_subnet_4"
  })
  type        = string
  sensitive   = false
  description = "name of fourth ecs task role in prod"
}

variable "subnet_5_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-prod-us-east-1"
    output       = "ecs_task_subnet_5"
  })
  type        = string
  sensitive   = false
  description = "name of fifth ecs task role in prod"
}