# Databricks workspace

This terraform module simplifies the process of creating and managing a databricks workspace on azure with customizable options and features, offering a flexible and powerful solution for managing azure databricks workspace through code.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Non-Goals

These modules are not intended to be complete, ready-to-use solutions; they are designed as components for creating your own patterns.

They are not tailored for a single use case but are meant to be versatile and applicable to a range of scenarios.

Security standardization is applied at the pattern level, while the modules include default values based on best practices but do not enforce specific security standards.

End-to-end testing is not conducted on these modules, as they are individual components and do not undergo the extensive testing reserved for complete patterns or solutions.

## Features

- offers support for private and public databricks workspace
- utilization of terratest for robust validation.
- supports optional custom parameters for vnet injection (bring your own VNET).
- supports optional custom parameters for dbfs storage account name and sku.
- integrates with access connector and user-assigned identity in case default storage firewall is set to enabled

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.6)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_databricks_access_connector.dbac](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector) (resource)
- [azurerm_databricks_workspace.dbw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) (resource)
- [azurerm_user_assigned_identity.uami](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_workspace"></a> [workspace](#input\_workspace)

Description: databricks workspace configuration

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_access_connector"></a> [access\_connector](#input\_access\_connector)

Description: databricks access connector configuration

Type: `any`

Default: `{}`

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_access_connector"></a> [access\_connector](#output\_access\_connector)

Description: n/a

### <a name="output_identity"></a> [identity](#output\_identity)

Description: n/a

### <a name="output_workspace"></a> [workspace](#output\_workspace)

Description: n/a
<!-- END_TF_DOCS -->

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-dbw/graphs/contributors).

## Contributing

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-dbw/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/databricks)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/databricks)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/1f449b5a17448f05ce1cd914f8ed75a0b568d130/specification/databricks)
