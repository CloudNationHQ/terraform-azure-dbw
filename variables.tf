variable "workspace" {
  description = "databricks workspace configuration"
  type        = any
}

variable "access_connector" {
  description = "databricks access connector configuration"
  type        = any
  default     = {}
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
