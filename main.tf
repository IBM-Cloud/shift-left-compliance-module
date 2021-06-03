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

resource "null_resource" "create_kubernetes_toolchain" {
  provisioner "local-exec" {
    command = "${path.cwd}/.terraform/modules/shift-left-compliance-module/scripts/create-toolchain.sh"

    environment={
      REGION            =  var.region
      TOOLCHAIN_TEMPLATE_REPO = var.toolchain_template_repo
      APPLICATION_REPO  = var.application_repo
      RESOURCE_GROUP    = var.resource_group
      API_KEY           = var.ibmcloud_api_key
      CLUSTER_NAME      = var.cluster_name
      CLUSTER_NAMESPACE = var.cluster_namespace
      CONTAINER_REGISTRY_NAMESPACE = var.container_registry_namespace
      TOOLCHAIN_NAME    = var.toolchain_name
      PIPELINE_TYPE     = var.pipeline_type
      BRANCH            = var.branch
    }
  } 
}
