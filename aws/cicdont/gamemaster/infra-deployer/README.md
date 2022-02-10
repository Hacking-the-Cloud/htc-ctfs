# infra-deployer

Prototype to use Terraform to manage deployments here at SoftHouseIO. IAM Credentials are being stored in environment variables to be used with the GitLab runners. Eventually we can use the IAM role to assume-role to the Terraform role instead of static access and secret keys (dunno, Carmen's upgrade to IMDS broke getting the IAM keys. Gotta look into that).