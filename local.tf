locals {
  uid_name = var.user_assigned_identity_name != "" ? var.user_assigned_identity_name : var.service_account_name
}
