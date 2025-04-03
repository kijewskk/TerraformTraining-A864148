variable "frontend_rules" {
  type = map(object({
    inbound = list(object({
      name        = string
      source      = string
      port        = string
      priority    = number
      destination = string
    }))
  }))
}

#Bastion
variable "BastionRuleName" {
  type    = string
  default = ""
}

variable "BastionPriority" {
  type    = string
  default = ""
}

variable "BastionPort" {
  type    = string
  default = ""
}

variable "BastionIP" {
  type    = string
  default = ""
}

#Database
variable "DatabaseRuleName" {
  type    = string
  default = ""
}

variable "DatabasePriority" {
  type    = string
  default = ""
}

variable "DatabasePort" {
  type    = string
  default = ""
}

variable "DatabaseIP" {
  type    = string
  default = ""
}

variable "bastion_nic_name" {
  description = "Baction NIC name"
  type        = string
  default     = "A864148BSTNIC01"
}

variable "front_nic_name1" {
  description = "Front NIC name 1"
  type        = string
  default     = "A864148FNDNIC1"
}

variable "front_nic_name2" {
  description = "Front NIC name 2"
  type        = string
  default     = "A864148FNDNIC2"
}

variable "dba_nic_name" {
  description = "DBA NIC name"
  type        = string
  default     = "A864148DBANIC1"
}

variable "my_das" {
  description = "My DAS ID."
  type        = string
  default     = "A864148"
}