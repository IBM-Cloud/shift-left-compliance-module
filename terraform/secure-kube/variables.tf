variable "region" {
  type        = string
  description = "IBM Cloud Region"
  default     = "us-south"
}

variable "toolchain_template_repo" {
  type        = string
  description = "Compliance CI toolchain template repo"
  default     = "https://github.ibm.com/open-toolchain/compliance-ci-toolchain"
}

variable "application_repo" {
  type        = string
  description = "Hello compliance app repo"
  default     = "https://github.ibm.com/open-toolchain/hello-compliance-app"
}

variable "resource_group" {
  type        = string
  description = "Resource group name where the toolchain should be created"
  default     = "default"
}

variable "cluster_name" {
  type        = string
  description = "Name of Kubernetes Cluster to deploy into"
  default     = "compliance-cluster"
}

variable "datacenter" {
  type        = string
  description = "Zone from `ibmcloud ks zones --provider classic`"
  default     = "dal12"
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
  default     = "1.20.7"
  description = "Version of Kubernetes to apply to the new Kubernetes cluster"
}

variable "public_vlan_num" {
  type        = string
  description = "Number for public VLAN from `ibmcloud ks vlans --zone <ZONE>`"
  default     = "1911479"
}

variable "private_vlan_num" {
  type        = string
  description = "Number for private VLAN from `ibmcloud ks vlans --zone <ZONE>`"
  default     = "1891999"
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
  description = "Name of the COS bucket"
  default     = "cos-bucket"
}

variable "regional_loc" {
  description = "Region where the COS bucket will exist"
  default     = "us-south"
}

variable "storage" {
  description = "Storage class for the COS bucket"
  default     = "standard"
}

variable "app_name" {
  type        = string
  description = "Name of the Compliance CI application. NOTE: The <timestamp> will be in the format YYYYMMDDhhmm."
  default     = "compliance-app-<timestamp>"
}

variable "toolchain_name" {
  type        = string
  description = "Name of the Compliance CI toolchain. NOTE: The <timestamp> will be in the format YYYYMMDDhhmm."
  default     = "compliance-ci-toolchain-<timestamp>"
}

variable "registry_namespace" {
  type        = string
  description = "Container registry namespace to save images"
}

variable "artifactory_user_id" {
  type        = string
  description = "User ID for Artifactory access"
}

variable "artifactory_token" {
  type        = string
  description = "Token for Artifactory access (base64 encoded)"
}

variable "issues_repo" {
  type        = string
  description = "Repo where compliance issues will be stored. If no override is provided, then the default repo will be cloned."
  default     = "https://github.ibm.com/one-pipeline/compliance-incident-issues"
}

variable "inventory_repo" {
  type        = string
  description = "Repo where compliance inventory will be stored. If no override is provided, then the default repo will be cloned."
  default     = "https://github.ibm.com/one-pipeline/compliance-inventory"
}

variable "evidence_repo" {
  type        = string
  description = "Repo where compliance evidence will be stored. If no override is provided, then the default repo will be cloned."
  default     = "https://github.ibm.com/one-pipeline/compliance-evidence-locker"
}

variable "pipeline_repo" {
  type        = string
  description = "Repo where Tekton resources are defined"
  default     = "https://github.ibm.com/one-pipeline/compliance-pipelines"
}
