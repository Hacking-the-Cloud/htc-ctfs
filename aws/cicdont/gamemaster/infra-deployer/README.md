# infra-deployer

Prototype using Terraform to manage deployments here at SoftHouseIO. Admin IAM Credentials are being stored in environment variables in this project to be used with the GitLab runners. Eventually we can use an IAM role to assume-role to the Terraform role instead of static access and secret keys (dunno, Carmen's upgrade to IMDS broke getting the IAM keys. Gotta look into that).

The GitLab admin account is a member of this project.