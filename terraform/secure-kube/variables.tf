variable "toolchain_name" {
  type        = string
  description = "Name of the Compliance CI toolchain. NOTE: The <timestamp> will be in the format YYYYMMDDhhmm."
  default     = "compliance-ci-toolchain-<timestamp>"
}

variable "application_repo" {
  type        = string
  description = "Hello compliance app repo"
  default     = "https://us-south.git.cloud.ibm.com/open-toolchain/hello-compliance-app"
}

variable "sm_name" {
  description = "Name of the Secrets Manager tool integration (Ex. my-secrets-manager)"
  default     = "sm-compliance-secrets"
}

variable "sm_service_name" {
  description = "Name of the Secrets Manager service. NOTE: Only 1 Secrets Manager instance is allowed. If you already have a Secrets Manager service provisioned, please override this value to its name."
  default     = "compliance-ci-secrets-manager"
}

variable "cos_url" {
  type        = string
  description = "URL endpoint to Cloud Object Storage Bucket"
  default     = "s3.private.us.cloud-object-storage.appdomain.cloud"
}

variable "bucket_name" {
  description = "Name of the Cloud Object Storage bucket. NOTE: The <timestamp> will be in the format YYYYMMDDhhmm."
  default     = "cos-compliance-bucket-<timestamp>"
}

variable "app_name" {
  type        = string
  description = "Name of the Compliance CI application. NOTE: The <timestamp> will be in the format YYYYMMDDhhmm."
  default     = "compliance-app-<timestamp>"
}

variable "region" {
  type        = string
  description = "IBM Cloud Region"
  default     = "us-south"
}

variable "registry_namespace" {
  type        = string
  description = "Container registry namespace to save images"
  default     = "compliance"
}

variable "resource_group" {
  type        = string
  description = "Resource group name where the toolchain should be created"
  default     = "default"
}

variable "cluster_name" {
  type        = string
  description = "Name of new Kubernetes Cluster to deploy application into. WARNING: On first run, the plan will fail to apply if the named cluster already exists. On second run, the plan will destroy the previously created cluster and create a new one (no matter if the name changes)."
  default     = "compliance-cluster"
}

variable "cluster_namespace" {
  type        = string
  description = "Kubernetes namespace to deploy into"
  default     = "default"
}

variable "toolchain_template_repo" {
  type        = string
  description = "Compliance CI toolchain template repo"
  default     = "https://us-south.git.cloud.ibm.com/open-toolchain/compliance-ci-toolchain"
}

variable "branch" {
  type        = string
  description = "Branch for Compliance CI toolchain template repo"
  default     = "master"
}

variable "pipeline_type" {
  type        = string
  description = "Type of IBM DevOps toolchain pipeline"
  default     = "tekton"
}

variable "regional_loc" {
  description = "Region where the COS bucket will exist"
  default     = "us-south"
}

variable "storage" {
  description = "Storage class for the COS bucket"
  default     = "standard"
}

variable "gitlab_token" {
  type        = string
  description = "A GitLab Personal Access Token (https://us-south.git.cloud.ibm.com/-/profile/personal_access_tokens)"
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IAM API Key for IBM Cloud access (https://cloud.ibm.com/iam/apikeys)"
}