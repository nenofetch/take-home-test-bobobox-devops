# Implementation

## 1) The single-VM on OCI using OpenTofu

### Goal

Simple, cheap, fast: one VM that serves a static site. Easy to manage and great for demos or small projects.

### What I provisioned

- VCN with public subnet
- Internet Gateway + route table (0.0.0.0/0 -> IGW)
- Security List allowing 22, 80, 9100
- Instance with `assign_public_ip = true`
- `cloud-init.sh` installs nginx + node_exporter and opens firewall

### How-to notes

1. Keep OCI credentials out of repo. Use GitHub Secrets or OCI Vault.
2. In `challenge3` folder use `tofu init`, `tofu plan`, `tofu apply`.
3. After apply, `tofu output public_ip` and visit `http://<public_ip>`.
4. SSH username depends on image: `opc` for Oracle Linux, `ubuntu` for Ubuntu.(<[References](https://docs.oracle.com/en-us/iaas/Content/Compute/tutorials/first-linux-instance/overview.htm)>)

## 2) CI/CD (how I wired it)

- **challenge3**: OpenTofu plan on PRs, apply on main (see `.github/workflows/opentofu.yml`).
- Store OCI config in `secrets.OCI_CONFIG`, and per-variable secrets (tenancy, compartment) if you prefer TF_VAR style.

Why this CI choice?

- Plan on PR reduces chance of accidental infra changes.
- Apply only on main avoids surprises.
- Separate app & infra pipelines reduces risk.

## 3) Network

- For VM: use an simple network such as OCI Virtual Cloud Network, Route Table, IGW, and the public ip was protected and it not directly into VM, so in the behind it accessing through OCI IGW > Route table > VCN > Public Subnet > Instance.

## 4) Observability

- Node_Exporter Prometheus: for metric collection such as cpu/memory usage, on this machine it was installed Prometheus Node_Exporter as on the cloud-init.sh file, and for the port is using 9100

## 5)
