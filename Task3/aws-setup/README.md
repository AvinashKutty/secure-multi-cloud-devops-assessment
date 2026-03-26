**AWS-Based AI/ML Environment Setup:**

**Objective**

To deploy a simple AI/ML API and restrict access using network-level security, simulating a secure multi-cloud architecture.

**Architecture Overview**

```bash
AWS EC2 used as compute instance
Node.js used to host dummy ML API
OpenVPN used to simulate secure client access
AWS Security Group used to restrict traffic
```

**Implementation Steps**

**Step 1: EC2 Instance Setup**
Launched Ubuntu EC2 instance (t2.micro)
Configured key pair for SSH access
Assigned public IP: 98.93.252.6


**Step 2: Install Dependencies**
sudo apt update -y
sudo apt install -y nodejs npm


**Step 3: Deploy ML API**

Created app.js:

```bash
const http = require('http');

const server = http.createServer((req, res) => {
res.writeHead(200, {'Content-Type': 'application/json'});
res.end(JSON.stringify({prediction: "dummy-value"}));
});

server.listen(5000, '0.0.0.0', () => {
console.log("ML API running on port 5000");
});

Run the server:

nohup node app.js &
```

**Step 4: Configure Security Group**
Allowed:
SSH (Port 22) → My IP
Custom TCP (Port 5000) → 13.219.240.63 (OpenVPN IP)
Blocked:
All other public access


**Step 5: VPN Integration**
Connected using OpenVPN
Verified public IP:
curl ifconfig.me
Output: 13.219.240.63


**Step 6: Testing**
Inside EC2:
curl http://localhost:5000
From VPN Client:
curl http://98.93.252.6:5000

Response:

```bash

{"prediction":"dummy-value"}
Security Implementation
Restricted API access using Security Group
Only VPN IP allowed (13.219.240.63)
Prevented public exposure (0.0.0.0/0 not used)
Simulates enterprise-level secure architecture
```


**Expected Outcome Achieved**
Requirement Status
ML API Deployment 
Functional Service 
Restricted Access 
Multi-cloud understanding 
Network-level security 
.
