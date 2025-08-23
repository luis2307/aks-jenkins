resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  # --- SIN RBAC ---
  role_based_access_control_enabled = false

  # Quitar/Asegurarse de NO definir este bloque cuando no hay RBAC:
  # azure_active_directory_role_based_access_control { ... }  # <- ELIMINADO

  # OIDC/Workload Identity no hace daño si queda encendido, pero no lo usarás sin RBAC
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # queremos la cuenta local habilitada para usar kubeconfig admin
  local_account_disabled = false

  # (Opcional pero recomendado) limita quién puede hablar con el API server
  api_server_access_profile {
    authorized_ip_ranges = var.authorized_ip_ranges # p.ej ["1.2.3.4/32"]
    # enable_private_cluster = false  # si más adelante quieres private cluster, cámbialo
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    outbound_type     = "loadBalancer"
    load_balancer_sku = "standard"
    dns_service_ip    = "10.2.0.10"
    service_cidr      = "10.2.0.0/24"
  }

  default_node_pool {
    name            = "system"
    vm_size         = "Standard_D4s_v5"
    os_disk_type    = "Managed"
    os_disk_size_gb = 128
    type            = "VirtualMachineScaleSets"
    # mode                = "System"
    enable_auto_scaling = true
    min_count = 1
    max_count = 2

    node_labels = {
      nodepool = "system"
    }

    upgrade_settings {
      max_surge = "33%"
    }
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }
  microsoft_defender { log_analytics_workspace_id = var.log_analytics_workspace_id }
  azure_policy_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
