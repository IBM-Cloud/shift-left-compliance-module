terraform {
  required_version = ">= 0.12"
}

provider "ibm" {
  version           = "~> 1.25"
  ibmcloud_api_key  = var.ibmcloud_api_key
}

provider "null" {
  version = "~> 3.1"
}

data "ibm_resource_group" "cos_group" {
  name = var.resource_group
}

resource "ibm_resource_instance" "cos_instance" {
  name              = "cos-instance-${formatdate("YYYYMMDDhhmm", timestamp())}"
  resource_group_id = data.ibm_resource_group.cos_group.id
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
}

resource "ibm_cos_bucket" "cos_bucket" {
  bucket_name           = var.bucket_name == "cos-compliance-bucket-<timestamp>" ? "cos-compliance-bucket-${formatdate("YYYYMMDDhhmm", timestamp())}" : var.bucket_name
  resource_instance_id  = ibm_resource_instance.cos_instance.id
  region_location       = var.regional_loc
  storage_class         = var.storage
}

resource "ibm_iam_service_id" "service_id" {
  name = "service_id"
}

resource "ibm_iam_service_api_key" "service_api_key" {
  name = "service_api_key"
  iam_service_id = ibm_iam_service_id.service_id.iam_id
}

data "ibm_iam_api_key" "service_api_key" {
    apikey_id = ibm_iam_service_api_key.service_api_key.id
}

resource "ibm_iam_service_policy" "cos_policy" {
  iam_service_id = ibm_iam_service_id.service_id.id
  roles          = ["Reader", "Writer"]

  resources {
    service = "cloud-object-storage"
    resource_instance_id  = ibm_resource_instance.cos_instance.id
  }
}

data "ibm_resource_group" "group" {
  name = var.resource_group
}

resource "null_resource" "create_kubernetes_toolchain" {
  provisioner "local-exec" {
    command = "${path.cwd}/scripts/create-toolchain.sh"

    environment={
      REGION            =  var.region
      TOOLCHAIN_TEMPLATE_REPO = "https://${var.region}.git.cloud.ibm.com/open-toolchain/compliance-ci-toolchain"
      APPLICATION_REPO  = "https://${var.region}.git.cloud.ibm.com/open-toolchain/hello-compliance-app"
      RESOURCE_GROUP    = var.resource_group
      API_KEY           = var.ibmcloud_api_key
      CLUSTER_NAME      = "compliance-cluster"
      CLUSTER_NAMESPACE = "default"
      REGISTRY_NAMESPACE  = var.registry_namespace
      TOOLCHAIN_NAME    = var.toolchain_name == "compliance-ci-toolchain-<timestamp>" ? "compliance-ci-toolchain-${formatdate("YYYYMMDDhhmm", timestamp())}" : var.toolchain_name
      PIPELINE_TYPE     = "tekton"
      BRANCH            = var.branch
      APP_NAME          = var.app_name == "compliance-app-<timestamp>" ? "compliance-app-${formatdate("YYYYMMDDhhmm", timestamp())}" : var.app_name
      COS_BUCKET_NAME   = "${element(split(":", ibm_cos_bucket.cos_bucket.crn),9)}"
      COS_URL           = var.cos_url
      SERVICE_API_KEY   = data.ibm_iam_api_key.service_api_key.apikey
      SM_NAME           = var.sm_name
      SM_SERVICE_NAME   = var.sm_service_name == "compliance-ci-secrets-manager" ? "compliance-ci-secrets-manager" : var.sm_service_name
      GITLAB_TOKEN      = var.gitlab_token
    }
  } 
}
