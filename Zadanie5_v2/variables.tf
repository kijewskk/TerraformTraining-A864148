variable "my_das" {
  description = "My DAS ID."
  type        = string
  default     = "A864148"
}

variable "frontend_port" {
  description = "Frontend port for LB."
  type        = number
  default     = 443
}

variable "backend_port" {
  description = "Backend port for LB."
  type        = number
  default     = 80
}

variable "lb_probe_port" {
  description = "Port for LB probe."
  type        = number
  default     = 443
}