# availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# pick Oracle Linux 9 ARM image in tenancy
data "oci_core_images" "o19_arm" {
  compartment_id            = var.tenancy_ocid
  operating_system          = "Oracle Linux"
  operating_system_version  = var.os_version
  sort_by                   = "TIMECREATED"
  sort_order                = "DESC"
  shape = var.instance_shape
}

# VCN
resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr
  display_name   = "${var.instance_name}-vcn"
  # dns_label = "${var.instance_name}vcn"
}

# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.instance_name}-igw"
}

# Route table: send 0.0.0.0/0 to IGW
resource "oci_core_route_table" "rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.instance_name}-rt"
  route_rules {
      destination = "0.0.0.0/0"
      network_entity_id = oci_core_internet_gateway.igw.id
}

}

# Security list: allow inbound 22 (SSH), 80 (HTTP), and 9100 (Node Exporter), allow all egress
resource "oci_core_security_list" "web" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.instance_name}-sec"


  # SSH Rules
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
    description = "Allow SSH"
  }

  # HTTP Rules
  ingress_security_rules{
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
    description = "Allow HTTP"
  }

  # Node Exporter Rules
  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    tcp_options {
      min = 9100
      max = 9100
    }
    description = "Allow Node Exporter"
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# Public Subnet
resource "oci_core_subnet" "public" {
  compartment_id              = var.compartment_ocid
  vcn_id                      = oci_core_vcn.vcn.id
  cidr_block                  = var.subnet_cidr
  availability_domain         = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name                = "${var.instance_name}-subnet"
  route_table_id              = oci_core_route_table.rt.id
  security_list_ids           = [oci_core_security_list.web.id]
  prohibit_public_ip_on_vnic  = false
}

# Compute instance
resource "oci_core_instance" "web" {
  compartment_id     = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name       = var.instance_name
  shape              = var.instance_shape
  shape_config {
    ocpus = 1
    memory_in_gbs = 6
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.o19_arm.images[0].id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public.id
    assign_public_ip = true
    display_name     = "${var.instance_name}-vnic"
  }

  metadata = {
    # inject public SSH key into the default user's authorized_keys
    ssh_authorized_keys = file(var.ssh_public_key_path)
    # cloud-init script to run on first boot
    user_data = base64encode(file("cloud-init.sh"))
  }

  
}
