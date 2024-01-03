variable "prefix" {
  type        = string
  description = "Prefix for all resources in this example"
  default     = "wi-tf-mod"
}

variable "dns_zone_name" {
  type        = string
  description = "DNS Zone name"
  default     = "example.learndevops.in"
}
