# Complete

This example highlights the complete usage.

## Types

```hcl
workspace = object({
  name                = string
  location            = string
  resource_group_name = string
  sku                 = string

  managed_resource_group_name           = optional(string)
  network_security_group_rules_required = optional(string)
  load_balancer_backend_address_pool_id = optional(string)
  public_network_access_enabled         = optional(bool)
  default_storage_firewall_enabled      = optional(bool)
  infrastructure_encryption_enabled     = optional(bool)
  customer_managed_key_enabled          = optional(bool)
  managed_disk_cmk_key_vault_id         = optional(string)
  managed_disk_cmk_key_vault_key_id     = optional(string)
  managed_services_cmk_key_vault_id     = optional(string)
  managed_services_cmk_key_vault_key_id = optional(string)

  managed_disk_cmk_rotation_to_latest_version_enabled = optional(bool)

  custom_parameters = optional(object({
    no_public_ip                  = optional(bool)
    nat_gateway_name              = optional(string)
    public_ip_name                = optional(string)
    storage_account_name          = optional(string)
    storage_account_sku_name      = optional(string)
    public_subnet_name            = optional(string)
    private_subnet_name           = optional(string)
    vnet_address_prefix           = optional(string)
    virtual_network_id            = optional(string)
    machine_learning_workspace_id = optional(string)

    public_subnet_network_security_group_association_id  = optional(string)
    private_subnet_network_security_group_association_id = optional(string)
  }))

  tags = optional(object())
})

access_connector = optional(object({
  name                = string
  location            = string
  resource_group_name = string

  identity = optional(object({
    type         = string
    identity_ids = optional(list(string))
  }))
}))

virtual_network_peerings = optional(map(object({
  name                          = optional(string)
  resource_group_name           = optional(string)
  remote_address_space_prefixes = list(string)
  remote_virtual_network_id     = string
  allow_virtual_network_access  = optional(bool, true)
  allow_forwarded_traffic       = optional(bool, false)
  allow_gateway_transit         = optional(bool, false)
  use_remote_gateways           = optional(bool, false)
})))

workspace_root_dbfs_customer_managed_key = optional(object({
  key_vault_key_id = string
  key_vault_id     = optional(string)
}))
```

## Notes

This example follows the common WAM pattern: create the user-assigned identity with `cloudnationhq/uai/azure` and pass its ID to `access_connector.identity.identity_ids`.

For `identity.type = "UserAssigned"` or `identity.type = "SystemAssigned, UserAssigned"`, provide exactly one value in `identity_ids`.

For `identity.type = "SystemAssigned"`, omit `identity_ids`.
