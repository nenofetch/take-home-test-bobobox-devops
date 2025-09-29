variable "region" {
  description = "OCI region, example: ap-batam-1"
  type        = string
  default     = "ap-batam-1"
}

variable "config_file_profile" {
  description = "OCI CLI profile name in the config file"
  type        = string
  default = "DEFAULT"
}

variable "tenancy_ocid" {
  description = "OCI tenancy OCID (required)"
  type        = string
}

variable "compartment_ocid" {
  description = "OCI compartment OCID where resources will be created (required)"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key (will be injected into instance authorized_keys)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Local path to your SSH private key (for local SSH instructions only)"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "instance_shape" {
  description = "OCI instance shape. VM.Standard.E2.1.Micro is often in Always Free tier."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "instance_name" {
  description = "Friendly name for the instance"
  type        = string
  default     = "otf-web"
}

variable "vcn_cidr" {
  description = "VCN CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "os_version" {
  description = "Select Oracle OS Version"
  type        = string
  default     = "9"
}
