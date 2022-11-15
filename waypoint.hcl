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
        service_port = 3000
        assign_public_ip = false

        subnets = var.subnets_dev
        cluster = var.ecs_cluster_dev
        log_group = var.log_group_dev
        execution_role_name = var.execution_role_name_dev
        task_role_name = var.task_role_name_dev
        region = var.region
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
variable "subnets_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    output       = "ecs_task_subnets"
  })
  type        = list(string)
  sensitive   = false
  description = "name of the ecs task role in dev"
}

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


### Prod
