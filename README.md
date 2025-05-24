# aiq-power-plant-infra

To deploy this infrastructure, you would need to:

1. Set up your Azure credentials using Azure CLI or environment variables
2. Provide the SSL certificate and password through environment variables:
  export TF_VAR_ssl_cert_path="/path/to/your/certificate.pfx"
  export TF_VAR_ssl_cert_password="your-certificate-password"
3. Initialize and apply the Terraform configuration:
  terraform init
  terraform plan
  terraform apply
