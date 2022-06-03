terraform {
  required_version = ">= 0.14.0"
  required_providers {
    ibm = {
      source  = "ibm-cloud/ibm"
      version = ">= 1.27.0"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
}

provider "null" {
}

data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

resource "ibm_resource_instance" "cos_instance" {
  name              = "cos-compliance-instance-${formatdate("YYYYMMDDhhmm", timestamp())}"
  resource_group_id = data.ibm_resource_group.resource_group.id
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
}

resource "ibm_cos_bucket" "cos_bucket" {
  bucket_name          = "cos-compliance-bucket-${formatdate("YYYYMMDDhhmm", timestamp())}"
  resource_instance_id = ibm_resource_instance.cos_instance.id
  region_location      = var.region
  storage_class        = "standard"
}

resource "ibm_iam_service_id" "cos_serviceID" {
  name = "cos_service_id"
}

resource "ibm_iam_service_api_key" "cos_service_api_key" {
  name           = "cos_service_api_key"
  iam_service_id = ibm_iam_service_id.cos_serviceID.iam_id
}

resource "ibm_iam_service_policy" "cos_policy" {
  iam_service_id = ibm_iam_service_id.cos_serviceID.id
  roles          = ["Reader", "Writer"]
  resources {
    service              = "cloud-object-storage"
  }
}

resource "ibm_container_cluster" "cluster" {
  name              = "compliance-cluster-${formatdate("YYYYMMDDhhmm", timestamp())}"
  datacenter        = var.datacenter
  default_pool_size = var.default_pool_size
  machine_type      = var.machine_type
  hardware          = var.hardware
  kube_version      = var.kube_version
  public_vlan_id    = var.public_vlan_num
  private_vlan_id   = var.private_vlan_num
  resource_group_id = data.ibm_resource_group.resource_group.id
  wait_till         = "OneWorkerNodeReady"
}

resource "null_resource" "create_kubernetes_toolchain" {
  depends_on = [ibm_container_cluster.cluster]
  provisioner "local-exec" {
    command = "${path.cwd}/scripts/create-toolchain.sh"
    environment = {
      REGION                  = var.region
      TOOLCHAIN_TEMPLATE_REPO = "https://${var.region}.git.cloud.ibm.com/open-toolchain/compliance-ci-toolchain"
      APPLICATION_REPO        = "https://${var.region}.git.cloud.ibm.com/open-toolchain/hello-compliance-app"
      RESOURCE_GROUP          = var.resource_group
      API_KEY                 = nonsensitive(var.ibmcloud_api_key)
      CLUSTER_NAME            = ibm_container_cluster.cluster.name
      CLUSTER_NAMESPACE       = "default"
      REGISTRY_NAMESPACE      = var.registry_namespace
      TOOLCHAIN_NAME          = "compliance-ci-toolchain-${formatdate("YYYYMMDDhhmm", timestamp())}"
      PIPELINE_TYPE           = "tekton"
      BRANCH                  = "master"
      APP_NAME                = "compliance-app-${formatdate("YYYYMMDDhhmm", timestamp())}"
      COS_BUCKET_NAME         = ibm_cos_bucket.cos_bucket.bucket_name
      COS_URL                 = "s3.${var.region}.cloud-object-storage.appdomain.cloud"
      COS_API_KEY             = nonsensitive(ibm_iam_service_api_key.cos_service_api_key.apikey)
      SM_NAME                 = var.sm_name
      SM_SERVICE_NAME         = var.sm_service_name
      GITLAB_TOKEN            = nonsensitive(var.gitlab_token)
    }
  }
}
