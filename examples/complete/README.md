# Complete

This example highlights the complete usage.

## Types

```hcl
workspace = object({
  name           = string
  location       = string
  resource_group = string
  sku            = string

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
  name           = string
  location       = string
  resource_group = string

  identity = optional(object({
    type         = string     
    identity_ids = optional(list)
  }))
}))
```

## Notes

When setting the identity type to UserAssigned, the module will generate a user-assigned identity automatically.

You can also specify other identities under the identity_ids property, the module will concatenate the specified identities with the one generated if type is set to UserAssigned. 