terraform {
  required_version = ">= 0.12"
}

resource "random_string" "random" {
  length = 4
  min_lower = 4
}

data "ibm_resource_group" "group" {
  name = var.resource_group
}

provider "ibm" {
  ibmcloud_api_key   = var.ibmcloud_api_key
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

data "ibm_resource_group" "cos_group" {
  name = var.resource_group
}

resource "ibm_resource_instance" "cos_instance" {
  name              = "cos-instance"
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

resource "null_resource" "create_kubernetes_toolchain" {
  provisioner "local-exec" {
    command = "${path.cwd}/scripts/create-toolchain.sh"

    environment={
      REGION            =  var.region
      TOOLCHAIN_TEMPLATE_REPO = var.toolchain_template_repo
      APPLICATION_REPO  = var.application_repo
      PIPELINE_REPO     = var.pipeline_repo
      RESOURCE_GROUP    = var.resource_group
      API_KEY           = var.ibmcloud_api_key
      CLUSTER_NAME      = var.cluster_name
      CLUSTER_NAMESPACE = var.cluster_namespace
      REGISTRY_NAMESPACE  = var.registry_namespace
      TOOLCHAIN_NAME    = var.toolchain_name
      PIPELINE_TYPE     = var.pipeline_type
      BRANCH            = var.branch
      APP_NAME          = var.app_name
      ART_USER_ID       = var.artifactory_user_id
      ART_TOKEN         = var.artifactory_token
      EVIDENCE_REPO     = var.evidence_repo
      ISSUES_REPO       = var.issues_repo
      INVENTORY_REPO    = var.inventory_repo
      VAULT_SECRET      = var.vault_secret
      COS_BUCKET_NAME   = var.cos_bucket_name
      COS_URL           = var.cos_url
    }
  } 
}
