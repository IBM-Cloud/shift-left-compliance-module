terraform {
  required_version = ">= 0.12"
}

provider "ibm" {
  version = "~> 1.25"
}

provider "github" {
  version = "~> 4.12"
}

provider "random" {
  version = "~> 3.1"
}

provider "null" {
  version = "~> 3.1"
}

resource "ibm_iam_api_key" "iam_api_key" {
  name        = "compliance-ci-api-key"
  description = "API key for provisioning IBM resources for the Compliance CI toolchain"
}

data "ibm_iam_api_key" "iam_api_key" {
  apikey_id     = ibm_iam_api_key.iam_api_key.apikey_id
}

resource "random_string" "random" {
  length    = 4
  min_lower = 4
}

resource "github_repository" "issues_repo" {
  count       = var.issues_repo == "https://github.ibm.com/one-pipeline/compliance-incident-issues" ? 1 : 0
  name        = "compliance-issues-${formatdate("YYYYMMDDhhmm", timestamp())}"
  description = "Repo for storing compliance issues"

  visibility  = "internal"

  template {
    owner      = "ibm"
    repository = "https://github.ibm.com/one-pipeline/compliance-incident-issues"
  }
}

resource "github_repository" "inventory_repo" {
  count       = var.inventory_repo == "https://github.ibm.com/one-pipeline/compliance-inventory" ? 1 : 0
  name        = "compliance-inventory-${formatdate("YYYYMMDDhhmm", timestamp())}"
  description = "Repo for storing compliance inventory"

  visibility  = "internal"

  template {
    owner      = "ibm"
    repository = "https://github.ibm.com/one-pipeline/compliance-inventory"
  }
}

resource "github_repository" "evidence_repo" {
  count       = var.evidence_repo == "https://github.ibm.com/one-pipeline/compliance-evidence-locker" ? 1 : 0
  name        = "compliance-evidence-${formatdate("YYYYMMDDhhmm", timestamp())}"
  description = "Repo for storing compliance evidence"

  visibility  = "internal"

  template {
    owner      = "ibm"
    repository = "https://github.ibm.com/one-pipeline/compliance-evidence-locker"
  }
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
  bucket_name           = var.bucket_name
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

resource "ibm_container_cluster" "cluster" {
  name              = var.cluster_name
  datacenter        = var.datacenter
  default_pool_size = var.default_pool_size
  machine_type      = var.machine_type
  hardware          = var.hardware
  kube_version      = var.kube_version
  public_vlan_id    = var.public_vlan_num
  private_vlan_id   = var.private_vlan_num
  resource_group_id = data.ibm_resource_group.group.id
}

resource "null_resource" "create_kubernetes_toolchain" {
  provisioner "local-exec" {
    command = "${path.cwd}/scripts/create-toolchain.sh"

    environment={
      REGION            =  var.region
      TOOLCHAIN_TEMPLATE_REPO = var.toolchain_template_repo
      APPLICATION_REPO  = var.application_repo
      PIPELINE_REPO     = var.pipeline_repo
      RESOURCE_GROUP    = var.resource_group
      API_KEY           = data.ibm_iam_api_key.iam_api_key.apikey
      CLUSTER_NAME      = var.cluster_name
      CLUSTER_NAMESPACE = var.cluster_namespace
      REGISTRY_NAMESPACE  = var.registry_namespace
      TOOLCHAIN_NAME    = var.toolchain_name == "compliance-ci-toolchain-<timestamp>" ? "compliance-ci-toolchain-${formatdate("YYYYMMDDhhmm", timestamp())}" : var.toolchain_name
      PIPELINE_TYPE     = var.pipeline_type
      BRANCH            = var.branch
      APP_NAME          = var.app_name == "compliance-app-<timestamp>" ? "compliance-app-${formatdate("YYYYMMDDhhmm", timestamp())}" : var.app_name
      ISSUES_REPO       = var.issues_repo == "https://github.ibm.com/one-pipeline/compliance-incident-issues" ? github_repository.issues_repo[0].id : var.issues_repo
      INVENTORY_REPO    = var.inventory_repo == "https://github.ibm.com/one-pipeline/compliance-inventory" ? github_repository.inventory_repo[0].id : var.inventory_repo
      EVIDENCE_REPO     = var.evidence_repo == "https://github.ibm.com/one-pipeline/compliance-evidence-locker" ? github_repository.evidence_repo[0].id : var.evidence_repo
      COS_BUCKET_NAME   = ibm_cos_bucket.cos_bucket.id
      COS_URL           = var.cos_url
      SERVICE_API_KEY   = data.ibm_iam_api_key.service_api_key.apikey
      SM_NAME           = var.sm_name
    }
  } 
}
