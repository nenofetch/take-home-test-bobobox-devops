provider "oci" {
  # Read region and optional OCI CLI config path/profile from variables.
  # Authentication will use the OCI CLI config file + profile by default.
  region              = var.region
  config_file_profile = var.config_file_profile
  
}
