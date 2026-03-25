TASK 1 – VPN SETUP (FINAL SOP DOCUMENT)
________________________________________
**Objective**

To implement a secure VPN-based access system in AWS where internal resources are not publicly accessible and can only be accessed via a VPN tunnel.
________________________________________
**Architecture Overview**
User Laptop
    ↓ (VPN Tunnel)
OpenVPN Server (EC2 - Public Subnet)
    ↓
Private EC2 (Private Subnet - No Public IP)
________________________________________
PHASE 1: VPC & NETWORK SETUP
________________________________________
Step 1: Create VPC
•	Navigate: AWS Console → VPC → Create VPC 
•	Name: vpn-vpc 
•	CIDR: 10.0.0.0/16 
________________________________________
Step 2: Create Subnets
Public Subnet:
•	Name: public-subnet 
•	CIDR: 10.0.1.0/24 
Private Subnet:
•	Name: private-subnet 
•	CIDR: 10.0.2.0/24 
________________________________________
Step 3: Internet Gateway
•	Create IGW → Attach to vpn-vpc 
________________________________________
Step 4: Route Tables
Public Route Table:
•	Route: 
0.0.0.0/0 → Internet Gateway
•	Associate: public-subnet 
Private Route Table:
•	Only: 
10.0.0.0/16 → local
•	Associate: private-subnet 
________________________________________
PHASE 2: VPN SERVER SETUP
________________________________________
Step 5: Launch EC2 (VPN Server)
•	Name: vpn-server 
•	AMI: Ubuntu 22.04 
•	Subnet: Public Subnet 
•	Public IP: Enabled 
________________________________________
Step 6: Security Group (vpn-sg)
Inbound Rules:
Type	Port	Source
SSH	22	My IP
UDP	1194	0.0.0.0/0
________________________________________
Step 7: Install OpenVPN
sudo apt update -y
sudo apt install curl -y
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
sudo ./openvpn-install.sh install
________________________________________
Step 8: Create VPN Client
sudo ./openvpn-install.sh client avinash
File generated:
/home/ubuntu/client.ovpn
________________________________________
 PHASE 3: VPN CLIENT CONNECTION
________________________________________
Step 9: Download Config
Using WinSCP / SCP:
client.ovpn → local machine
________________________________________
Step 10: Connect VPN
•	Install OpenVPN GUI 
•	Import client.ovpn 
•	Connect 
________________________________________
Step 11: Verify VPN
curl ifconfig.me/ip
 Output: EC2 Public IP
 VPN working
________________________________________
 PHASE 4: PRIVATE EC2 SETUP
________________________________________
Step 12: Launch Private EC2
•	Name: internal-app 
•	Subnet: Private Subnet 
•	Public IP: Disabled 
________________________________________
Step 13: Security Group (private-sg)
Type	Port	Source
SSH	22	10.8.0.0/24
 Only VPN users allowed
________________________________________
 PHASE 5: ROUTING CONFIGURATION
________________________________________
Step 14: Enable IP Forwarding (VPN Server)
sudo nano /etc/sysctl.conf
Uncomment:
net.ipv4.ip_forward=1
Apply:
sudo sysctl -p
________________________________________
Step 15: Configure NAT
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
Save:
sudo apt install iptables-persistent -y
sudo netfilter-persistent save
________________________________________
 PHASE 6: VALIDATION
________________________________________
Step 16: Connect VPN
________________________________________
Step 17: SSH Private EC2
ssh ubuntu@10.0.2.X
✔ SUCCESS via VPN
________________________________________
Step 18: Test Without VPN
•	Disconnect VPN 
•	Try SSH 
❌ FAIL (Expected)
________________________________________
  FINAL RESULT
✔ VPN connection established
✔ Private EC2 has NO public access
✔ Access restricted via VPN CIDR (10.8.0.0/24)
✔ Secure routing enabled
________________________________________
 SECURITY IMPLEMENTATION
•	Private subnet isolation 
•	No public IP for internal resources 
•	Security group restriction 
•	VPN-based authentication 
•	NAT + IP forwarding 


