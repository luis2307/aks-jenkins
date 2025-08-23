# Despliegue de Jenkins en AKS usando Terraform

Este repositorio contiene la infraestructura como código para desplegar un clúster de Azure Kubernetes Service (AKS) y un Azure Container Registry (ACR) en Azure, con el objetivo de levantar Jenkins en el clúster de AKS.

## Estructura del Proyecto

```
.
├── main/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars   # Archivo de variables personalizado
└── readme.md
```

## Prerrequisitos

- [Azure CLI](https://docs.microsoft.com/es-es/cli/azure/install-azure-cli)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- Una suscripción activa de Azure

## Variables de configuración

Crea un archivo `terraform.tfvars` dentro de la carpeta `main` con el siguiente contenido:

```hcl
location    = "East US 2"
project     = "jenkins"
environment = "dev"
```

Puedes modificar estos valores según tus necesidades.

## Pasos para el despliegue

1. **Clona el repositorio y navega a la carpeta principal:**

    ```bash
    git clone <URL_DEL_REPOSITORIO>
    cd aks-jenkings/main
    ```

2. **Inicia sesión en Azure:**

    ```bash
    az login
    ```

3. **Inicializa Terraform:**

    ```bash
    terraform init
    ```

4. **Revisa el plan de ejecución:**

    ```bash
    terraform plan
    ```

5. **Aplica la infraestructura:**

    ```bash
    terraform apply
    ```

6. **Obtén las credenciales del clúster AKS:**

    ```bash
    az aks get-credentials --resource-group <nombre-del-resource-group> --name <nombre-del-aks>
    ```

7. **Despliega Jenkins en el clúster AKS:**

    Puedes usar Helm para instalar Jenkins:

    ```bash
    helm repo add jenkins https://charts.jenkins.io
    helm repo update
    helm install jenkins jenkins/jenkins
    ```

## Recursos creados

- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)

## Limpieza

Para eliminar la infraestructura creada:

```bash
terraform destroy
```

---

**Nota:** Asegúrate de tener configurados los archivos `main.tf`, `variables.tf` y `outputs.tf` correctamente para el despliegue de AKS y ACR.
