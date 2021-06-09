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
  default     = "Default"
}

variable "cluster_name" {
  type        = string
  description = "Name of Kubernetes Cluster to deploy into"
  default     = "compliance-cluster"
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
  default     = "4.6.28_openshift"
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
  default     = "default"
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
  default = "cos-bucket"
}

variable "regional_loc" {
  default = "us-south"
}

variable "storage" {
  default = "standard"
}

variable "app_name" {
  type        = string
  description = "Name of the application"
  default     = "hello-compliance-app"
}

variable "registry_namespace" {
  type        = string
  description = "Container registry namespace to save images"
}

variable "pipeline_repo" {
  type        = string
  description = "Repo where compliance pipeline configurations exists"
  default     = "https://github.ibm.com/one-pipeline/compliance-pipelines"
}

variable "artifactory_user_id" {
  type        = string
  description = "User ID for Artifactory access"
}

variable "artifactory_token" {
  type        = string
  description = "Token for Artifactory access (base64 encoded)"
}

variable "evidence_repo" {
  type        = string
  description = "Repo where compliance evidence will be stored"
  default     = "https://github.ibm.com/one-pipeline/compliance-evidence-locker"
}

variable "issues_repo" {
  type        = string
  description = "Repo where compliance issues will be stored"
  default     = "https://github.ibm.com/one-pipeline/compliance-incident-issues"
}

variable "inventory_repo" {
  type        = string
  description = "Repo where compliance inventory will be stored"
  default     = "https://github.ibm.com/one-pipeline/compliance-inventory"
}

variable "cos_bucket" {
  type        = string
  description = "Name of COS Bucket"
}

variable "cos_url" {
  type        = string
  description = "URL endpoint to COS Bucket"
}

variable "vault_secret" {
  type        = string
  description = "GPG signing key"
}