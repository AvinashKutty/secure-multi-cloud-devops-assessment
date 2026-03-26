HOW TO RUN
Step 1: Initialize
terraform init
Step 2: Apply
terraform apply

Enter:

key_name = your-key
my_ip = your-ip/32
Step 3: Output

You’ll get:

vpn_public_ip = X.X.X.X
private_ec2_ip = 10.0.2.X
IMPORTANT (MANUAL STEP STILL REQUIRED)

After Terraform:

SSH into VPN server:

ssh ubuntu@<vpn_public_ip>

Then create client:

sudo ./openvpn-install.sh client avinash
