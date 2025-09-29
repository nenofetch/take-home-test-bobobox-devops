output "public_ip" {
  description = "Public IP address of the instance"
  value       = oci_core_instance.web.public_ip
}

output "instance_id" {
  description = "OCID of the instance"
  value       = oci_core_instance.web.id
}

output "ssh_user_at" {
  description = "Quick SSH hint (replace <private-key-path> if needed)"
  value       = "ssh -i ${var.ssh_private_key_path} opc@${oci_core_instance.web.public_ip}"
}
