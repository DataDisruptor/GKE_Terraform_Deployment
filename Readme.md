# Infrastructure Configuration | TF & GKE

## Overview

This repo contains `.tf` and `.yaml` files, automating Terraform deployment to GKE.
The stack used for the deployment consists of `Docker`, `Kubernetes`, `Helm`, `Terraform` and `GCloud` - and these must be installed and authorized in your system in order to run this configuration setup, with the addition of enabling several mandatory cloud APIs (for more on installation see #Prerequisites).

Once your system is installed with all necessary components and settings, you can modify the `0-variables.tf` file to set the defaults values to match your cloud project and github repository setup.

Once all prerequisites and variables are installed and assigned default values, you will need to initialize your configuration with `$ terraform init`.
Finally, you can deploy the services to the GKE cluster using `$ terraform apply`.

## Prerequisites

- Install Docker - `docker`: https://docs.docker.com/desktop/install/windows-install/

- Install Kubernetes - `kubectl`: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/

- Install Terraform - `terraform`: https://developer.hashicorp.com/terraform/downloads

  - May also need to install the `Go` programming language prior to installing terraform

- Install Helm - `helm`:

  1. Download and install - https://helm.sh/docs/intro/install/
  2. Once installed, get the `nginx-ingress` repo : `$ helm repo add nginx-ingress https://kubernetes.github.io/ingress-nginx`
  3. Install the repo by running : `$ helm repo update`
  4. Search for the repo using `$ helm search repo nginx`, and assign it as the default value for the `helm_ingress_version` variable in the `0-variables.tf` file.

- Install Google Cloud - `gcloud`:
  1. Create new cloud project (if there isn't one already).
  2. Copy your project id to the default value of the `project_id` variable in the `0-variables.tf` file.
  3. Enable necessary cloud APIs : `Cloud Storage` | `Artifact Registry` | `Compute Engine` | `Kubernetes Engine`
     - In `Cloud Storage`, create a new bucket, give it a name - and copy it to the default value of the `bucket` attribute in the `1-provider.tf` file.
  4. Download `gcloud` cli : https://cloud.google.com/sdk/docs/install
  5. Authorize cli with project by running `$ gcloud auth application-default login` and confirming the subsequent prompt.
  6. ! May also need to install authorization plugin for GKE :
     `$ gcloud components install gke-gcloud-auth-plugin` - Read more at :
     https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke

## Deployment

Once your environment is installed with all the necessary dependencies, you will need to modify the defaults for the configuration variables, for things like the github repo url, the storage bucket name, the google cloud project ID (if you haven't done so already), and other settings such as the server machine type and location.
Finally, once all prerequisites and the project personalized settings are set up in the variables, deployment can be done in these 3 simple steps:

1. Make sure to save all files
2. Run `$ terraform init` to initialize the backend
3. Run `$ terraform apply` to allocate and create all of the cloud resources, and deploy the application. This may take a while so roll a cigarette in the meanwhile

Once deployment is completed successfully, use `kubectl get ingress` to view the external addresses of the services

When you want to remove all of the resources, run `$ terraform destroy`.
This may take a while, so you may want to roll another cigarette now, or do something else.
Lastly, here are 2 "post-destroy" things to think about:

1. Make sure to delete the folder of the cloned repo before re-deploying again, since each new deployment execution using `terraform apply` would clone the repo anew - making cloning and deployment fail because a folder of the same name already exists.
2. You may need to delete all of the `kubectl` namespaces that were created by Helm

## File Structure Overview

##### 0-variables.tf :

The variable data configuration file.
This file is divided into the various sections that consists of the configuration needed for the cloud environment setup and github repo location:

- `Containers config`
- `Github config`
- `Cloud config`
- `Deployment config`

##### 1-provider.tf :

This file is where the cloud storage Bucket name should be assigned (line 14, `bucket = "..."`).
This is where additional providers may be requested, if ever needed in the future.

##### 2-vpc.tf :

Configure the Virtual Private Cloud - or, the virtual network setup.

##### 3-subnets.tf :

Private sub-networks setup, where IP ranges and network regions are set up.

##### 4-router.tf :

Basic network router setup.

##### 5-nat.tf :

Setup the NAT router, or Network Address Translation router.
This consists of setting which ip allocation methods to use, as well as connecting the router with the VPC and Sub-network.

##### 6-firewalls.tf :

Basic firewall setup for the main virtual network.

##### 7-kubernetes.tf :

Allocate a GKE cluster on the cloud.

##### 8-node-pools.tf :

Configure 2 node pools to be used by the GKE cluster.

##### 9-service-accounts.tf :

Configure admin/project member privileges.
Currently authorized for service account project member.

##### 10-container-actions.tf :

Configuration for cloning the github repo, building and pushing the containers to cloud storage repo.

##### 11-service-deployment.tf :

Final deployment using `kubectl` for the NodePort and Ingress services, and `helm` for the Ingress controllers.

# \_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

## Current Limitations & Future Goals

- The pre-requisites section is a limitation of it's own - which should dwindle over time. The Aim is to automate everything as much as possible, thus the installation process of all the various components should be migrated to a VM and automated on the spot instance, and have github Actions +/ Gitlab respond to repository changes to allocate and prepare the right resources for re-deployment (establish a well defined CI/CD pipeline)

- `local-execution` should be replaced with proper `remote-exec` as much as possible, after accommodating for most pre-requisites as a part of the base infrastructure on the VM

- The `.yaml` configuration files are as of yet NOT flexibly set-up with variable configuration as in the `.tf` files - HIGH PRIORITY
  As of now, the domain addresses, container images names and tags - are all hard-coded!
