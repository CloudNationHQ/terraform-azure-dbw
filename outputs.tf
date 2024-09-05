output "workspace" {
  value = azurerm_databricks_workspace.dbw
}

output "access_connector" {
  value = azurerm_databricks_access_connector.dbac
}

output "identity" {
  value = azurerm_user_assigned_identity.uami
}
