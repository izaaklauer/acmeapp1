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

        cluster = var.tfc_dev.ecs_cluster_dev
        log_group = var.tfc_dev.log_group_dev
        execution_role_name = var.tfc_dev.execution_role_name_dev
        task_role_name = var.tfc_dev.task_role_name_dev
        security_group_ids = var.tfc_dev.security_group_ids
        region = var.tfc_dev.region
        subnets = var.tfc_dev.subnets
        logging {
          create_group = false
          region       = var.tfc_dev.region
        }
        alb {
          listener_arn = var.tfc_dev.alb_listener_arn_dev
        }
      }
    }
  }

  workspace "prod" {
    use "aws-ecs" {
      count = 3
      memory = "2048"
      cpu = 4096
      service_port = 3000
      assign_public_ip = false

      cluster = var.tfc_prod.ecs_cluster_prod
      log_group = var.tfc_prod.log_group_prod
      execution_role_name = var.tfc_prod.execution_role_name_prod
      task_role_name = var.tfc_prod.task_role_name_prod
      security_group_ids = var.tfc_prod.security_group_ids
      region = var.tfc_prod.region
      subnets = var.tfc_prod.subnets
      logging {
        create_group = false
        region       = var.tfc_prod.region
      }
      alb {
        listener_arn = var.tfc_prod.alb_listener_arn_prod
      }
    }
  }
}

### All environments
variable "tfc_dev" {
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
variable "tfc_dev" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    # outputs      = ["ecs_cluster_name", "log_group_name", ...]
    all_outputs  = true
  })
  type        = map
  sensitive   = false
  description = "all outputs from this app's dev tfc workspace"
}

### Prod
variable "tfc_prod" {
  default = dynamic("terraform-cloud", {
    organization = "acmecorpinfra"
    workspace    = "acmeapp1-dev-us-east-1"
    all_outputs  = true
  })
  type        = string
  sensitive   = false
  description = "all outputs from this app's dev tfc workspace"
}