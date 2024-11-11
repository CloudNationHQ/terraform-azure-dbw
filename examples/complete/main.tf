module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "cloudnationhq/vnet/azure"
  version = "~> 4.0"

  naming = local.naming

  vnet = {
    name           = module.naming.virtual_network.name
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name
    cidr           = ["10.0.0.0/16"]

    subnets = {
      public = {
        cidr = ["10.0.1.0/24"]
        nsg  = {}
        delegations = {
          databricks = {
            name = "Microsoft.Databricks/workspaces"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action",
              "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
              "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
            ]
          }
        }
      }
      private = {
        cidr = ["10.0.2.0/24"]
        nsg  = {}
        delegations = {
          databricks = {
            name = "Microsoft.Databricks/workspaces"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action",
              "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
              "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
            ]
          }
        }
      }
    }
  }
}

module "db_workspace" {
  source  = "cloudnationhq/dbw/azure"
  version = "~> 1.0"

  workspace = {
    name                        = module.naming.databricks_workspace.name_unique
    location                    = module.rg.groups.demo.location
    resource_group              = module.rg.groups.demo.name
    sku                         = "premium"
    managed_resource_group_name = "${module.naming.databricks_workspace.name_unique}-managed"

    public_network_access_enabled         = false
    network_security_group_rules_required = "NoAzureDatabricksRules"
    default_storage_firewall_enabled      = true
    infrastructure_encryption_enabled     = true

    custom_parameters = {
      public_ip_name = "nat-gw-public-ip"
      no_public_ip   = true

      virtual_network_id                                   = module.network.vnet.id
      public_subnet_name                                   = module.network.subnets.public.name
      public_subnet_network_security_group_association_id  = module.network.subnets.public.id
      private_subnet_name                                  = module.network.subnets.private.name
      private_subnet_network_security_group_association_id = module.network.subnets.private.id
      vnet_address_prefix                                  = "10.24"

      storage_account_name     = "${module.naming.storage_account.name_unique}dbfs"
      storage_account_sku_name = "Standard_RAGRS"
    }

    tags = {
      environment = "dev"
    }
  }

  access_connector = {
    name           = "dbw-ac"
    resource_group = module.rg.groups.demo.name
    location       = module.rg.groups.demo.location
    identity = {
      type = "UserAssigned"
    }
  }

  depends_on = [module.network]
}
