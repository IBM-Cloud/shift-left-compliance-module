variable "region" {
  type        = string
  description = "IBM Cloud region where your application will be deployed (to view your current targeted region `ibmcloud cr region`)"
  default     = "us-south"
}

variable "registry_namespace" {
  type        = string
  description = "Container registry namespace to save images (`ibmcloud cr namespaces`). NOTE: The namespace must already exist, or be a unique value."
}

variable "resource_group" {
  type        = string
  description = "Resource group where the resources will be created (`ibmcloud resource groups`)"
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
  description = "Version of Kubernetes to apply to the new Kubernetes cluster (Run: `ibmcloud ks versions` to see available versions)"
}

variable "private_vlan_num" {
  type        = string
  description = "Number for private VLAN from `ibmcloud ks vlans --zone <ZONE>`"
  default     = "1891999"
}

variable "public_vlan_num" {
  type        = string
  description = "Number for public VLAN from `ibmcloud ks vlans --zone <ZONE>`"
  default     = "1911479"
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The IAM API Key for IBM Cloud access (https://cloud.ibm.com/iam/apikeys)"
  sensitive   = true
}

variable "gitlab_token" {
  type        = string
  description = "A GitLab Personal Access Token (https://us-south.git.cloud.ibm.com/-/profile/personal_access_tokens NOTE: Make sure to create your token in the same region as your toolchain, or 'region' variable.)"
  sensitive   = true
}

variable "sm_name" {
  description = "Name of the Secrets Manager tool integration (Ex. my-secrets-manager)"
  default     = "sm-compliance-secrets"
}

variable "sm_service_name" {
  description = "Name of the Secrets Manager service. NOTE: If you already have a Secrets Manager service provisioned, please override this value to its name."
  default     = "compliance-ci-secrets-manager"
}
