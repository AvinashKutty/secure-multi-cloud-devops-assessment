HOW TO RUN
Step 1: Initialize
```bash
terraform init
```
Step 2: Apply
```bash
terraform apply
```

Enter:

```bash
key_name = your-key
my_ip = your-ip/32
Step 3: Output
```

You’ll get:

```bash
vpn_public_ip = X.X.X.X
private_ec2_ip = 10.0.2.X
IMPORTANT (MANUAL STEP STILL REQUIRED)
```

After Terraform:

SSH into VPN server:

```bash
ssh ubuntu@<vpn_public_ip>
```

Then create client:

```bash
sudo ./openvpn-install.sh client avinash
```
