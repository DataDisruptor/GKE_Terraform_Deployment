# GCloud:
#   Authorize app (*BEFORE deployment*):    `$ gcloud auth application-default login`
#   Set working project ID:                 `$ gcloud config set project $PROJECT_ID`
#   Get credentials to GKE cluster:         `$ gcloud container clusters get-credentials $CLUSTER_NAME`

# Helm:
#   Install (WinShell):     `$ choco install kubernetes-helm`
#   Initialize              `$ helm init`
#   Get nginx repo:         `$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx`
#   Update Helm repo:       `$ helm repo update`
#   Get repo version num:   `$ helm search repo nginx`
#
#   -----------in this stage - override default nginx ingress controller in a yaml file( see "4-nginx-ingress-controller.yaml" )---------------
#
#   Deploy to K8S w/ Helm:  `$ helm install $INGRESS_CTRL_NAME ingress-nginx/ingress-nginx --namespace $NS_NAME --version $REPO_V_NUM --values $PATH_TO_YML_FILE --create-namespace
#   Delete Helm release:    `$ helm delete $RELEASE_NAME --namespace $RELEASE_NAMESPACE_NAME`
#   Purge Helm resources:   `$ helm delete $RELEASE_NAME --purge`

# Kubectl:
#   See ingress classes:    `$ kubectl get ingressclass`
#   Describe status:      `$ kubectl describe {service/pod/node} ${service/pod/node}_NAME`


# Get Cluster Credentials && Deploy service account - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

# Credentials Verification
resource "null_resource" "cluster_credentials" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.main_cluster_name}"
  }
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.general,
    google_container_node_pool.spot,
    # google_container_node_pool.auth_np
  ]
}

# Service account Deployment
resource "null_resource" "kube_service_account_deploy" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/0-deployment-gcloud-service-account.yaml"
  }

  depends_on = [
    null_resource.cluster_credentials,
  ]
}

# Frontend deployment - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

resource "null_resource" "frontend_kube_deploy" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/services/frontend"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.kube_service_account_deploy,
    null_resource.frontend_docker_push
  ]
}

resource "null_resource" "frontend_kube_ingress" {
  provisioner "local-exec" {
    command = "helm repo update && helm install frontend-ingress-class ingress-nginx/ingress-nginx --namespace frontend-ingress-namespace --version 4.6.0 --values k8s/services/ingress-controllers/ING-frontend-ingress-controller.yaml --create-namespace"
  }
  depends_on = [
    null_resource.cluster_credentials,
    null_resource.frontend_docker_push,
    null_resource.frontend_kube_deploy
  ]
}

# Auth service Deployment - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

resource "null_resource" "auth_kube_deploy" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/services/auth"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.kube_service_account_deploy,
    null_resource.auth_docker_push
  ]
}

resource "null_resource" "auth_kube_ingress" {
  provisioner "local-exec" {
    command = "helm repo update && helm install auth-ingress-class ingress-nginx/ingress-nginx --namespace auth-ingress-namespace --version 4.6.0 --values k8s/services/ingress-controllers/ING-auth-ingress-controller.yaml --create-namespace"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.auth_docker_push,
    null_resource.auth_kube_deploy
  ]
}

# Chat service Deployment - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

resource "null_resource" "chat_kube_deploy" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/services/chat"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.kube_service_account_deploy,
    null_resource.chat_docker_push
  ]
}

resource "null_resource" "chat_kube_ingress" {
  provisioner "local-exec" {
    command = "helm repo update && helm install chat-ingress-class ingress-nginx/ingress-nginx --namespace chat-ingress-namespace --version 4.6.0 --values k8s/services/ingress-controllers/ING-chat-ingress-controller.yaml --create-namespace"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.chat_docker_push,
    null_resource.chat_kube_deploy
  ]
}

# Resume service Deployment - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

resource "null_resource" "resume_kube_deploy" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/services/resume"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.kube_service_account_deploy,
    null_resource.resume_docker_push
  ]
}

resource "null_resource" "resume_kube_ingress" {
  provisioner "local-exec" {
    command = "helm repo update && helm install resume-ingress-class ingress-nginx/ingress-nginx --namespace resume-ingress-namespace --version 4.6.0 --values k8s/services/ingress-controllers/ING-resume-ingress-controller.yaml --create-namespace"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.resume_docker_push,
    null_resource.resume_kube_deploy
  ]
}

# Gateway service Deployment - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

resource "null_resource" "gateway_kube_deploy" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/services/gateway"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.kube_service_account_deploy,
    null_resource.gateway_docker_push
  ]
}

resource "null_resource" "gateway_kube_ingress" {
  provisioner "local-exec" {
    command = "helm repo update && helm install gateway-ingress-class ingress-nginx/ingress-nginx --namespace gateway-ingress-namespace --version 4.6.0 --values k8s/services/ingress-controllers/ING-gateway-ingress-controller.yaml --create-namespace"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.gateway_docker_push,
    null_resource.gateway_kube_deploy
  ]
}

# POST `$ terraform destroy`:

# Only need to delete ingressControllerClass:   `$ helm delete XYZ-ingress-class --namespace XYZ-ingress-namespace` OR 

# It is possible to delete a namespace created by Helm. First, you need to delete any resources that are associated with the namespace. 
# To do this, you can use the following command:
# `$ kubectl delete all --all -n <namespace-name>`
# This command deletes all resources in the namespace, including deployments, pods, and services.
# Once you have deleted all the resources in the namespace, you can delete the namespace itself using the following command:
# `$ kubectl delete namespace <namespace-name>`
#   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   #   
# Alternatively, you can use the Helm CLI to delete the release and the associated resources, including the namespace. You can use the following command 
# to delete a Helm release:
# `$ helm uninstall <release-name> --namespace=<namespace-name>`
# This command deletes the release and all associated resources, including the namespace.
