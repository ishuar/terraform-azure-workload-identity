locals {
  tags = {
    managed_by  = "terraform"
    github_repo = "ishuar/terraform-azure-workload-identity"
  }

  ## Workload Identities
  external-dns = [
    {
      service_account_name = "${var.prefix}-sa-external-dns"
      namespace            = "${var.prefix}-external-dns"
      role_assignments = [
        {
          role_definition_name = "DNS Zone Contributor"
          scope                = data.azurerm_dns_zone.example.id
        },
      ]
    },
  ]
  ## This example will also create a new namespace and service account kubernetes resources for cert-manager.
  cert-manager = [
    {
      service_account_name        = "${var.prefix}-sa-cert-manager"
      namespace                   = "${var.prefix}-cert-manager"
      create_kubernetes_namespace = true
      create_service_account      = true
      role_assignments = [
        {
          role_definition_name = "DNS Zone Contributor"
          scope                = data.azurerm_dns_zone.example.id
        },
      ]
    },
  ]

  ## Example to create custom role for velero
  velero = [
    {
      service_account_name = "${var.prefix}-sa-velero"
      namespace            = "${var.prefix}-velero"
      role_assignments = [
        {
          role_definition_name    = "velero"
          create_custom_role      = true
          scope                   = data.azurerm_subscription.current.id
          custom_role_description = "Role Required for velero to manage snapshots, backups and restores."
          custom_role_actions = [
            "Microsoft.Compute/disks/read",
            "Microsoft.Compute/disks/write",
            "Microsoft.Compute/disks/endGetAccess/action",
            "Microsoft.Compute/disks/beginGetAccess/action",
            "Microsoft.Compute/snapshots/read",
            "Microsoft.Compute/snapshots/write",
            "Microsoft.Compute/snapshots/delete",
            "Microsoft.Storage/storageAccounts/listkeys/action",
            "Microsoft.Storage/storageAccounts/regeneratekey/action",
            "Microsoft.Storage/storageAccounts/blobServices/containers/delete",
            "Microsoft.Storage/storageAccounts/blobServices/containers/read",
            "Microsoft.Storage/storageAccounts/blobServices/containers/write",
            "Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action"
          ]
          custom_role_data_actions = [
            "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete",
            "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read",
            "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write",
            "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action",
            "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action"
          ]
        }
      ]
    }
  ]

  identities = concat(
    local.external-dns,
    local.cert-manager,
    local.velero
  )
}
