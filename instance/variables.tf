variable "project" {
  description = "The project ID to deploy resources"
  type        = string
  default     = "test-422914"
}

variable "region" {
  description = "The region to deploy resources"
  type        = string
  default     = "europe-west2"
}

variable "zone" {
  description = "The zone to deploy resources"
  type        = string
  default     = "europe-west2-a"
}

variable "cidr_ip" {
  description = "The CIDR IP range for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}