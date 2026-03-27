**_TASK 1 – VPN SETUP (FINAL SOP DOCUMENT)_**

---

**Objective**

To implement a secure VPN-based access system in AWS where internal resources are not publicly accessible and can only be accessed via a VPN tunnel.

---

**Architecture Overview**
```bash
User Laptop
↓ (VPN Tunnel)
OpenVPN Server (EC2 - Public Subnet)
↓
Private EC2 (Private Subnet - No Public IP)
```

**PHASE 1: VPC & NETWORK SETUP**

---

Step 1: Create VPC
• Navigate: AWS Console → VPC → Create VPC
• Name: vpn-vpc
• CIDR: 10.0.0.0/16

---

**Step 2: Create Subnets**
Public Subnet:
• Name: public-subnet
• CIDR: 10.0.1.0/24
Private Subnet:
• Name: private-subnet
• CIDR: 10.0.2.0/24

---

**Step 3: Internet Gateway**
• Create IGW → Attach to vpn-vpc

---

**Step 4: Route Tables**
Public Route Table:
• Route:
0.0.0.0/0 → Internet Gateway
• Associate: public-subnet
Private Route Table:
• Only:
10.0.0.0/16 → local
• Associate: private-subnet

---

**PHASE 2: VPN SERVER SETUP**

---

**Step 5: Launch EC2 (VPN Server)**
• Name: vpn-server
• AMI: Ubuntu 22.04
• Subnet: Public Subnet
• Public IP: Enabled

---

**Step 6: Security Group (vpn-sg)**
Inbound Rules:
Type Port Source
SSH 22 My IP
UDP 1194 0.0.0.0/0

---

**Step 7: Install OpenVPN**

```bash
sudo apt update -y
sudo apt install curl -y
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
sudo ./openvpn-install.sh install
```

---

**Step 8: Create VPN Client**

```bash
sudo ./openvpn-install.sh client avinash
```

File generated:
/home/ubuntu/client.ovpn

---

**PHASE 3: VPN CLIENT CONNECTION**

---

**Step 9: Download Config**
Using WinSCP / SCP:
client.ovpn → local machine

---

**Step 10: Connect VPN**
• Install OpenVPN GUI
• Import client.ovpn
• Connect

---

**Step 11: Verify VPN**
curl ifconfig.me/ip
Output: EC2 Public IP
VPN working

---

**PHASE 4: PRIVATE EC2 SETUP**

---

**Step 12: Launch Private EC2**
• Name: internal-app
• Subnet: Private Subnet
• Public IP: Disabled

---

**Step 13: Security Group (private-sg)**
Type Port Source
SSH 22 10.8.0.0/24
Only VPN users allowed

---

**PHASE 5: ROUTING CONFIGURATION**

---

**Step 14: Enable IP Forwarding (VPN Server)**
sudo nano /etc/sysctl.conf
Uncomment:
net.ipv4.ip_forward=1
Apply:
sudo sysctl -p

---

**Step 15: Configure NAT**

```bash
sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
Save:
sudo apt install iptables-persistent -y
sudo netfilter-persistent save
```

---

**PHASE 6: VALIDATION**

---

**Step 16: Connect VPN**

---

**Step 17: SSH Private EC2**
ssh ubuntu@10.0.2.X
✔ SUCCESS via VPN

---

**Step 18: Test Without VPN**
• Disconnect VPN
• Try SSH
❌ FAIL (Expected)

---

FINAL RESULT
✔ VPN connection established
✔ Private EC2 has NO public access
✔ Access restricted via VPN CIDR (10.8.0.0/24)
✔ Secure routing enabled

---

.
