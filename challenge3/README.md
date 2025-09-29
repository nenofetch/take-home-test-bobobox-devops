# OpenTofu + Oracle Cloud (OCI) — Simple Web Server

## Quick start (fast, easy deployment)

1. Install OpenTofu (tofu) and OCI CLI + configure an OCI profile (or set environment variables).

   - OpenTofu docs: `tofu init`, `tofu apply`.
   - OCI Free Tier / CLI setup: https://www.oracle.com/cloud/free and OCI docs.

2. Generate an SSH key if you don't have one using command below:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
```

3. Copy your tenancy & compartment OCIDs into a `terraform.tfvars` file, make sure this file is not add into git (add to the .gitignore file for safety):

```hcl
tenancy_ocid = "ocid1.tenancy.oc1..aaaa..."
compartment_ocid = "ocid1.compartment.oc1..aaaa..."
# Optional
region = "ap-batam-1"
```

4. Initialize & apply:

```bash
# Initialize OpenTofu directory and provider plugins
tofu init

# Review planned changes
tofu plan

# Apply (create resources)
tofu apply
```

When complete, you'll see the `public_ip` output. (OpenTofu uses the same workflow as Terraform — `init`, `plan`, `apply`.)

5. SSH / Browse

```bash
ssh -i ~/.ssh/id_rsa opc@<PUBLIC_IP>
# or open http://<PUBLIC_IP> in your browser to see "Hello, OpenTofu!"
```

6. Destroy when done:

```bash
tofu destroy
```

---

## Files in this repo

- `versions.tf` — provider + required versions
- `provider.tf` — provider configuration (reads OCI CLI config/profile)
- `variables.tf` — reusable variables (region, shapes, OCIDs, SSH key path)
- `main.tf` — VCN, subnet, IGW, route table, security list, instance with cloud-init
- `outputs.tf` — prints the VM public IP and other useful info
- `cloud-init.sh` — startup script: installs nginx + small nginx tuning, optional node_exporter for observability

---

## Security / credentials (store securely)

- **Do not** hardcode OCIDs, private keys, or secrets in the repo.
- Use OCI CLI config file (`~/.oci/config`) with profiles or environment variables.
- For CI/CD, put sensitive values (OCI API keys, private keys, TF*VAR*\*) into GitHub Secrets / GitLab CI variables / Vault.
- I recommend using OCI's IAM + API keys for automation and keep keys in a secrets manager (HashiCorp Vault, GitHub Secrets, or OCI Vault).

---

## Observability & Backup (quick notes)

- The cloud-init installs `node_exporter` for Prometheus scraping. You can scrape metrics from the VM or use OCI Monitoring/Logging for metrics and logs.
- For backup: create boot volume backups or create a custom image of the boot volume (OCI supports boot volume backups). See the README section below for commands.

---

## Reason and implementation

- For the reason using this techstack in this case, please read on docs/reason.md
- For the implementation on the OCI with OpenTofu (IaC), please read on docs/implementation.md
