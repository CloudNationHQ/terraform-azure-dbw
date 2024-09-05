resource "azurerm_databricks_workspace" "dbw" {
  name                        = var.workspace.name
  resource_group_name         = coalesce(lookup(var.workspace, "resource_group", null), var.resource_group)
  location                    = coalesce(lookup(var.workspace, "location", null), var.location)
  managed_resource_group_name = try(var.workspace.managed_resource_group_name, null)
  sku                         = var.workspace.sku

  load_balancer_backend_address_pool_id = try(var.workspace.load_balancer_backend_address_pool_id, null)
  public_network_access_enabled         = try(var.workspace.public_network_access_enabled, true)
  network_security_group_rules_required = try(var.workspace.public_network_access_enabled, true) == false ? var.workspace.network_security_group_rules_required : null
  default_storage_firewall_enabled      = try(var.workspace.default_storage_firewall_enabled, null)
  access_connector_id                   = try(var.workspace.default_storage_firewall_enabled, false) == true ? azurerm_databricks_access_connector.dbac["default"].id : null

  customer_managed_key_enabled                        = try(var.workspace.customer_managed_key_enabled, false)
  infrastructure_encryption_enabled                   = try(var.workspace.infrastructure_encryption_enabled, false)
  managed_services_cmk_key_vault_id                   = try(var.workspace.managed_services_cmk_key_vault_id, null)
  managed_services_cmk_key_vault_key_id               = try(var.workspace.managed_services_cmk_key_vault_key_id, null)
  managed_disk_cmk_key_vault_id                       = try(var.workspace.managed_disk_cmk_key_vault_id, null)
  managed_disk_cmk_key_vault_key_id                   = try(var.workspace.managed_disk_cmk_key_vault_key_id, null)
  managed_disk_cmk_rotation_to_latest_version_enabled = try(var.workspace.managed_disk_cmk_rotation_to_latest_version_enabled, null)

  dynamic "custom_parameters" {
    for_each = try(var.workspace.custom_parameters, {}) != {} ? { "default" = var.workspace.custom_parameters } : {}
    content {
      machine_learning_workspace_id = try(custom_parameters.value.machine_learning_workspace_id, null)
      nat_gateway_name              = try(custom_parameters.value.nat_gateway_name, null)
      public_ip_name                = try(custom_parameters.value.public_ip_name, "nat-gw-public-ip")
      no_public_ip                  = try(custom_parameters.value.no_public_ip, true)

      virtual_network_id                                   = try(custom_parameters.value.virtual_network_id, null)
      public_subnet_name                                   = try(custom_parameters.value.virtual_network_id, null) != null ? custom_parameters.value.public_subnet_name : null
      public_subnet_network_security_group_association_id  = try(custom_parameters.value.virtual_network_id, null) != null ? custom_parameters.value.public_subnet_network_security_group_association_id : null
      private_subnet_name                                  = try(custom_parameters.value.virtual_network_id, null) != null ? custom_parameters.value.private_subnet_name : null
      private_subnet_network_security_group_association_id = try(custom_parameters.value.virtual_network_id, null) != null ? custom_parameters.value.private_subnet_network_security_group_association_id : null
      vnet_address_prefix                                  = try(custom_parameters.value.vnet_address_prefix, "10.139")

      storage_account_name     = try(custom_parameters.value.storage_account_name, null)
      storage_account_sku_name = try(custom_parameters.value.storage_account_sku_name, "Standard_GRS")
    }
  }

  tags = try(var.workspace.tags, var.tags, null)
}

resource "azurerm_databricks_access_connector" "dbac" {
  for_each = try(var.access_connector, {}) != {} ? { "default" = var.access_connector } : {}

  name                = var.access_connector.name
  resource_group_name = coalesce(lookup(var.access_connector, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.access_connector, "location", null), var.location)

  dynamic "identity" {
    for_each = try(var.access_connector.identity, null) != null ? { "default" = var.access_connector.identity } : {}
    content {
      type         = identity.value.type
      identity_ids = identity.value.type == "UserAssigned" ? concat(try(identity.value.identity_ids, []), try([azurerm_user_assigned_identity.uami["default"].id], [])) : null
    }
  }

  tags = try(var.access_connector.tags, var.tags, null)
}

resource "azurerm_user_assigned_identity" "uami" {
  for_each = try(var.access_connector.identity, null) != null ? try(var.access_connector.identity.type, null) == "UserAssigned" ? { "default" = var.access_connector.identity } : {} : {}

  name                = try(var.access_connector.identity.name, "uai-${var.workspace.name}")
  resource_group_name = coalesce(lookup(var.access_connector.identity, "resource_group", null), var.workspace.resource_group, var.resource_group)
  location            = coalesce(lookup(var.access_connector.identity, "location", null), var.workspace.location, var.location)

  tags = try(var.access_connector.identity.tags, var.tags, null)
}
