variable "name" {
  type        = list(string)
  default     = ["dev", "prod"]
  description = "The names of the instance"
}
