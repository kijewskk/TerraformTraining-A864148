variable "my_das" {
  description = "My DAS ID."
  type        = string
  default     = "A864148"
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_B2ms"
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine."
  type        = string
  sensitive   = true
}

variable "disk_size_gb_os" {
  description = "The size of OS disk."
  type        = number
}

variable "disk_size_gb_d" {
  description = "The size of D drive."
  type        = number
}

variable "vm_count" {
  description = "Number of virtual machines to create"
  type        = number
}