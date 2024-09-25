module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "defa"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}

module "db_workspace" {
  source  = "cloudnationhq/dbw/azure"
  version = "~> 1.0"

  workspace = {
    name           = module.naming.databricks_workspace.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    sku            = "premium"
  }
}
