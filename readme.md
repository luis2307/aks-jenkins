# Despliegue de Jenkins en AKS usando Terraform, Kubernetes y Helm

Este repositorio contiene la infraestructura como código para desplegar un clúster de Azure Kubernetes Service (AKS) y un Azure Container Registry (ACR) con Terraform, además de ejemplos para desplegar Jenkins:
- Manualmente con manifiestos Kubernetes (carpeta `k8s/`)
- Usando un Helm chart (carpeta `helm/`)

## Estructura del Proyecto

```
.
├── main/                # Terraform (main.tf, variables.tf, outputs.tf, terraform.tfvars)
├── k8s/                 # Manifiestos Kubernetes: jenkins-deployment.yaml, jenkins-service.yaml, jenkins-pvc.yaml, ...
├── helm/                # Helm chart o values.yaml para Jenkins
└── readme.md
```

## Prerrequisitos

- [Azure CLI](https://docs.microsoft.com/es-es/cli/azure/install-azure-cli)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- Una suscripción activa de Azure
- Opcional: acceso para subir imágenes a ACR si usas imágenes privadas

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
    terraform plan -var-file="terraform.tfvars"
    ```

5. **Aplica la infraestructura:**

    ```bash
    terraform apply -var-file="terraform.tfvars"
    ```

6. **Obtén las credenciales del clúster AKS:**

    ```bash
    az aks get-credentials --resource-group <resource-group> --name <aks-name>
    ```

## Despliegue manual con manifiestos Kubernetes (k8s/)

- Propósito: versionar y controlar manifiestos Kubernetes (Deployment, Service, PVC, Ingress, etc.)
- Archivos sugeridos en `k8s/`:
  - `jenkins-deployment.yaml`: Deployment con imagen de Jenkins. Configura `imagePullSecrets` si usas ACR privado.
  - `jenkins-service.yaml`: Service (NodePort o LoadBalancer) o Ingress.
  - `jenkins-pvc.yaml`: Persistencia (PersistentVolumeClaim).
  - `secret-acr-pullsecret.yaml`: (opcional) secret para acceder a ACR privado.

### Despliegue

```bash
kubectl apply -f k8s/
```

### Acceso

- Si usas Service type: LoadBalancer:

    ```bash
    kubectl get svc jenkins -n <ns>
    ```

- O con port-forward:

    ```bash
    kubectl port-forward svc/jenkins 8080:8080
    ```

### Notas prácticas para ACR

- Si vas a usar imágenes del ACR del mismo subscription, crea un Secret tipo docker-registry y referencia como `imagePullSecrets` en el Deployment.
- Ejemplo rápido para crear secret:

    ```bash
    az acr login --name <acrName>
    kubectl create secret docker-registry acr-pull \
      --docker-server <acrName>.azurecr.io \
      --docker-username <appId-or-servicePrincipal> \
      --docker-password '<password>' \
      --docker-email you@example.com
    ```

## Despliegue con Helm (helm/)

- Propósito: usar chart oficial de Jenkins o un chart personalizado en `helm/`.
- Ejemplo de comandos:

    ```bash
    helm repo add jenkins https://charts.jenkins.io
    helm repo update
    # Instalar con valores personalizados
    helm install jenkins jenkins/jenkins -f helm/values.yaml --namespace jenkins --create-namespace
    ```

- Valores importantes en `helm/values.yaml`:
  - `persistence.enabled`: true
  - `persistence.size`: 8Gi
  - `controller.serviceType`: LoadBalancer  # o ClusterIP si usas Ingress
  - `controller.image`: <acrName>.azurecr.io/jenkins:<tag>  # si usas ACR
  - `imagePullSecrets`: [ "acr-pull" ]  # si aplica

## Acceder a Jenkins (post-despliegue)

- Obtener IP (si LoadBalancer):

    ```bash
    kubectl get svc -n jenkins
    ```

- Obtener contraseña inicial (si instalaste chart oficial):

    ```bash
    kubectl get secret jenkins -n jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode
    ```

## Limpieza

Para eliminar la infraestructura creada:

```bash
# Helm
helm uninstall jenkins -n jenkins
kubectl delete namespace jenkins

# Manifiestos Kubernetes
kubectl delete -f k8s/

# Infraestructura
cd main
terraform destroy -var-file="terraform.tfvars"
```

---

**Nota:** Asegúrate de tener configurados los archivos `main.tf`, `variables.tf` y `outputs.tf` correctamente para el despliegue de AKS y ACR.
