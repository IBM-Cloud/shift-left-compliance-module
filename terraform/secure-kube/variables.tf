variable "toolchain_name" {
  type        = string
  description = "Name of the Compliance CI toolchain. NOTE: The <timestamp> will be in the format YYYYMMDDhhmm."
  default     = "compliance-ci-toolchain-<timestamp>"
}

variable "application_repo" {
  type        = string
  description = "Your application repository. The default URL is a sample application."
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
  description = "Name of Kubernetes Cluster where application will be deployed. If the default value is not overridden, a new cluster will be provisioned."
  default     = "compliance-cluster"
}

variable "cluster_namespace" {
  type        = string
  description = "Kubernetes namespace to deploy into"
  default     = "default"
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

variable "ibmcloud_api_key" {
  type        = string
  description = "The IAM API Key for IBM Cloud access (https://cloud.ibm.com/iam/apikeys)"
}

variable "gitlab_token" {
  type        = string
  description = "A GitLab Personal Access Token (https://us-south.git.cloud.ibm.com/-/profile/personal_access_tokens)"
}