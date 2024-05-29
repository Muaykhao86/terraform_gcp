variable "name" {
  description = "The name of the instance"
}

variable "env_tag" {
  validation {
    condition = can(regex("dev|test|prod", var.env_tag))
    error_message = "ERROR: Environment must be dev, test or prod."
  }
}