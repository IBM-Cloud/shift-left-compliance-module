variable "ibmcloud_api_key" {
  type        = string
  description = "The IAM API Key for IBM Cloud access"
}

variable "region" {
  type        = string
  description = "IBM Cloud Region"
  default     = "us-south"
}

variable "toolchain_template_repo" {
  type        = string
  description = "Compliance CI Toolchain Template URL"
  default     = "https://github.ibm.com/open-toolchain/compliance-ci-toolchain"
}

variable "toolchain_name" {
  type        = string
  description = "Name of the toolchain as it will appear on IBM Cloud"
}

variable "application_repo" {
  type        = string
  description = "Hello Compliance App URL"
  default     = "https://github.ibm.com/open-toolchain/hello-compliance-app"
}

variable "resource_group" {
  type        = string
  description = "Resource group name where the toolchain should be created"
  default     = "Defualt"
}

variable "cluster_name" {
  type        = string
  description = "Name of Kubernetes Cluster to deploy into"
}

variable "datacenter" {
  type        = string
  description = "Zone from `ibmcloud ks zones --provider classic`"
}

variable "default_pool_size" {
  default     = "1"
  description = "Number of worker nodes for the new Kubernetes cluster"
}

variable "machine_type" {
  default     = "b3c.4x16"
  description = "Name of machine type from `ibmcloud ks flavors --zone <ZONE>`"
}
variable "hardware" {
  default     = "shared"
  description = "The level of hardware isolation for your worker node. Use 'dedicated' to have available physical resources dedicated to you only, or 'shared' to allow physical resources to be shared with other IBM customers. For IBM Cloud Public accounts, the default value is shared. For IBM Cloud Dedicated accounts, dedicated is the only available option."
}

variable "kube_version" {
  default     = "1.18"
  description = "Version of Kubernetes to apply to the new Kubernetes cluster"
}

variable "public_vlan_num" {
  type        = string
  description = "Number for public VLAN from `ibmcloud ks vlans --zone <ZONE>`"
}

variable "private_vlan_num" {
  type        = string
  description = "Number for private VLAN from `ibmcloud ks vlans --zone <ZONE>`"
}

variable "cluster_namespace" {
  type        = string
  description = "Kubernetes namespace to deploy into"
}

variable "container_registry_namespace" {
  type        = string
  description = "IBM Container Registry namespace to save image into"
}

variable "pipeline_type" {
  type        = string
  description = "Type of IBM DevOps toolchain pipeline"
  default     = "tekton"
}

variable "branch" {
  type        = string
  description = "Branch for toolchain template repo"
  default     = "master"
}

variable "bucket_name" {
  default = "a-standard-bucket-at-ams-firewall"
}

variable "regional_loc" {
  default = "us-south"
}

variable "storage" {
  default = "standard"
}
