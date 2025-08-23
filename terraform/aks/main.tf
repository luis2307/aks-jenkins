resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version # opcional (si null, usa default de la región)

  # Habilita RBAC/AAD
  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    # managed                 = true
    azure_rbac_enabled     = true
    admin_group_object_ids = var.aad_admin_group_object_ids
  }

  # OIDC + Workload Identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # Seguridad de cuenta local
  local_account_disabled = true

  # Networking (Azure CNI + NP)
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    outbound_type     = "loadBalancer"
    load_balancer_sku = "standard"
    dns_service_ip    = "10.2.0.10"
    service_cidr      = "10.2.0.0/24"
    # docker_bridge_cidr  = "172.17.0.1/16"
  }

  # Default system node pool
  default_node_pool {
    name            = "system"
    vm_size         = "Standard_D4s_v5"
    os_disk_type    = "Managed"
    os_disk_size_gb = 128
    type            = "VirtualMachineScaleSets"

    # >>> AQUÍ EL CAMBIO: enable_auto_scaling (no auto_scaling_enabled)
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3

    # labels/taints
    node_labels = {
      nodepool = "system"
    }
    # node_taints = ["CriticalAddonsOnly=true:NoSchedule"]


    upgrade_settings {
      max_surge = "33%"
    }
  }

  # Add-ons observabilidad
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }
  microsoft_defender { log_analytics_workspace_id = var.log_analytics_workspace_id }
  azure_policy_enabled = true

  identity { type = "SystemAssigned" }

  tags = var.tags
}
