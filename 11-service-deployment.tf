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

resource "null_resource" "cluster_credentials" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.main_cluster_name}"
  }
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.general,
    google_container_node_pool.spot
  ]
}

resource "null_resource" "kube_deploy" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/srv"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.docker_push
  ]
}

resource "null_resource" "kube_ingress" {
  provisioner "local-exec" {
    command = "helm install my-ingress-class ingress-nginx/ingress-nginx --namespace my-ingress-namespace-name --version 4.6.0 --values k8s/ctrl/4-nginx-ingress-controller.yaml --create-namespace"
  }

  depends_on = [
    null_resource.cluster_credentials,
    null_resource.docker_push,
    null_resource.kube_deploy
  ]
}

# POST `$ terraform destroy`:

# Only need to delete ingressControllerClass:   `$ helm delete my-ingress-class --namespace my-ingress-namespace-name` OR 

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
