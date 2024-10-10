variable "subscription_id" {
  description = "My Azure subscription ID"
}

variable "location" {
  description = "The Azure region to deploy resources"
  default     = "AustraliaEast"
}

variable "admin_password" {
  description = "The password for the VM"
}