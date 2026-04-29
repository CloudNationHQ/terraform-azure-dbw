variable "workspace" {
  description = "databricks workspace configuration"
  type = object({
    name                        = string
    resource_group_name         = optional(string)
    location                    = optional(string)
    managed_resource_group_name = optional(string)
    sku                         = string

    load_balancer_backend_address_pool_id = optional(string)
    public_network_access_enabled         = optional(bool, true)
    network_security_group_rules_required = optional(string)
    default_storage_firewall_enabled      = optional(bool, false)

    customer_managed_key_enabled                        = optional(bool, false)
    infrastructure_encryption_enabled                   = optional(bool, false)
    managed_services_cmk_key_vault_id                   = optional(string)
    managed_services_cmk_key_vault_key_id               = optional(string)
    managed_disk_cmk_key_vault_id                       = optional(string)
    managed_disk_cmk_key_vault_key_id                   = optional(string)
    managed_disk_cmk_rotation_to_latest_version_enabled = optional(bool)

    custom_parameters = optional(object({
      machine_learning_workspace_id = optional(string)
      nat_gateway_name              = optional(string, "nat-gateway")
      public_ip_name                = optional(string, "nat-gw-public-ip")
      no_public_ip                  = optional(bool, true)

      virtual_network_id                                   = optional(string)
      public_subnet_name                                   = optional(string)
      public_subnet_network_security_group_association_id  = optional(string)
      private_subnet_name                                  = optional(string)
      private_subnet_network_security_group_association_id = optional(string)
      vnet_address_prefix                                  = optional(string, "10.139")

      storage_account_name     = optional(string)
      storage_account_sku_name = optional(string, "Standard_GRS")
    }))

    enhanced_security_compliance = optional(object({
      automatic_cluster_update_enabled      = optional(bool, false)
      compliance_security_profile_enabled   = optional(bool, false)
      compliance_security_profile_standards = optional(list(string), [])
      enhanced_security_monitoring_enabled  = optional(bool, false)
    }))

    tags = optional(map(string))
  })

  validation {
    condition     = var.workspace.location != null || var.location != null
    error_message = "location must be provided either in the workspace object or as a separate variable."
  }

  validation {
    condition     = var.workspace.resource_group_name != null || var.resource_group_name != null
    error_message = "resource_group_name must be provided either in the workspace object or as a separate variable."
  }

  validation {
    condition = var.workspace.public_network_access_enabled == false ? (
      var.workspace.network_security_group_rules_required != null
    ) : true
    error_message = "workspace.network_security_group_rules_required must be provided when public_network_access_enabled is false."
  }

  validation {
    condition = var.workspace.default_storage_firewall_enabled == true ? (
      var.access_connector != null
    ) : true
    error_message = "access_connector must be provided when workspace.default_storage_firewall_enabled is true."
  }

}

variable "access_connector" {
  description = "databricks access connector configuration"
  type = object({
    name                = string
    resource_group_name = optional(string)
    location            = optional(string)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    tags = optional(map(string))
  })
  default = null

  validation {
    condition = var.access_connector == null ? true : (
      var.access_connector.resource_group_name != null || var.resource_group_name != null
    )
    error_message = "resource_group_name must be provided either in the access_connector object or as a separate variable."
  }

  validation {
    condition = var.access_connector == null ? true : (
      var.access_connector.location != null || var.location != null
    )
    error_message = "location must be provided either in the access_connector object or as a separate variable."
  }

  validation {
    condition = var.access_connector == null || var.access_connector.identity == null ? true : (
      contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.access_connector.identity.type)
    )
    error_message = "access_connector.identity.type must be one of: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  }

  validation {
    condition = var.access_connector == null || var.access_connector.identity == null ? true : (
      contains(["UserAssigned", "SystemAssigned, UserAssigned"], var.access_connector.identity.type) ?
      length(coalesce(var.access_connector.identity.identity_ids, [])) == 1 :
      length(coalesce(var.access_connector.identity.identity_ids, [])) == 0
    )
    error_message = "access_connector.identity.identity_ids must contain exactly one ID when identity.type includes UserAssigned, and must be omitted otherwise."
  }
}

variable "virtual_network_peerings" {
  description = "databricks virtual network peering configuration"
  type = map(object({
    name                          = optional(string)
    resource_group_name           = optional(string)
    remote_address_space_prefixes = list(string)
    remote_virtual_network_id     = string
    allow_virtual_network_access  = optional(bool, true)
    allow_forwarded_traffic       = optional(bool, false)
    allow_gateway_transit         = optional(bool, false)
    use_remote_gateways           = optional(bool, false)
  }))
  default = {}
}

variable "workspace_root_dbfs_customer_managed_key" {
  description = "root dbfs customer managed key configuration"
  type = object({
    key_vault_key_id = string
    key_vault_id     = optional(string)
  })
  default = null

  validation {
    condition = var.workspace_root_dbfs_customer_managed_key == null ? true : (
      var.workspace.customer_managed_key_enabled
    )
    error_message = "workspace.customer_managed_key_enabled must be true when workspace_root_dbfs_customer_managed_key is provided."
  }
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group name to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
