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
}

variable "cluster_name" {
  type        = string
  description = "Name of Kubernetes Cluster to deploy into"
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
