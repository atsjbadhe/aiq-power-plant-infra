
---

# aiq-power-plant-infra

Infrastructure as Code (IaC) for deploying AIQ Power Plant infrastructure on Azure using Terraform.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Terraform Variables](#terraform-variables)
- [Outputs](#outputs)
- [Notes](#notes)

## Overview

This repository contains Terraform scripts to provision and configure the necessary Azure infrastructure for the AIQ Power Plant project. It automates resource creation, security configuration, and deployment workflows.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.x+
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) or set environment variables for authentication
- Valid Azure subscription
- SSL certificate in `.pfx` format

## Usage

1. **Clone the repository**
   ```sh
   git clone https://github.com/atsjbadhe/aiq-power-plant-infra.git
   cd aiq-power-plant-infra
   ```

2. **Authenticate with Azure**
   ```sh
   az login
   ```

3. **Set SSL certificate environment variables**
   ```sh
   export TF_VAR_ssl_cert_path="/path/to/your/certificate.pfx"
   export TF_VAR_ssl_cert_password="your-certificate-password"
   ```

4. **Initialize Terraform**
   ```sh
   terraform init
   ```

5. **Review the plan**
   ```sh
   terraform plan
   ```

6. **Apply the configuration**
   ```sh
   terraform apply
   ```

## Terraform Variables

List of main variables used (see `variables.tf` for the complete list):

| Variable                  | Description                    | Type   | Default           |
|---------------------------|--------------------------------|--------|-------------------|
| `ssl_cert_path`           | Path to SSL certificate (.pfx) | string | n/a (required)    |
| `ssl_cert_password`       | Password for the certificate   | string | n/a (required)    |
| _other variables here..._ |                                |        |                   |

## Outputs

After deployment, Terraform will output important resource information (see `outputs.tf` for details), such as:

- Resource group name
- Public IP addresses
- Application endpoints

## Notes

- Ensure your SSL certificate is valid and the path/password are correct.
- Review and customize variables as needed in `terraform.tfvars` or via environment variables.
- For troubleshooting, use `terraform destroy` to clean up resources.

---

If you provide your actual Terraform files, I can generate a README.md that documents all variables and outputs with their real descriptions. Let me know if you want to proceed with more detail!
