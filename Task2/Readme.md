Task 2: Deploy Scalable Node.js Backend on AWS with ALB & Auto Scaling
Objective

Deploy a highly available and scalable Node.js backend API on AWS using VPC, private/public subnets, ALB, Launch Template, and Auto Scaling Group (ASG). Ensure the app runs automatically on instance launch.

Prerequisites
AWS account with EC2, VPC, ALB, IAM permissions
Key pair .pem for SSH access
Basic knowledge of Ubuntu, Node.js, and networking
Step 1: Create VPC
Go to VPC → Create VPC
Configure:
Name: task2-vpc
IPv4 CIDR: 10.0.0.0/16
Tenancy: Default
Click Create
Step 2: Create Subnets
Public Subnets (for ALB)
Subnet 1: 10.0.1.0/24 → AZ us-east-1a → Name: public-subnet-1
Subnet 2: 10.0.2.0/24 → AZ us-east-1b → Name: public-subnet-2
Private Subnets (for EC2 instances)
Subnet 3: 10.0.3.0/24 → AZ us-east-1a → Name: private-subnet-1
Subnet 4: 10.0.4.0/24 → AZ us-east-1b → Name: private-subnet-2
Step 3: Create Internet Gateway
Go to VPC → Internet Gateways → Create Internet Gateway
Name: task2-igw
Attach to VPC: task2-vpc
Step 4: Configure Route Tables
Public Route Table
Create route table: task2-public-rt
Associate with public subnets
Add route: 0.0.0.0/0 → Internet Gateway: task2-igw
Private Route Table
Create route table: task2-private-rt
Associate with private subnets
No internet route (instances accessed via Bastion or ALB)
Step 5: Create Security Groups
ALB Security Group sg-alb
Allow inbound HTTP 80 from anywhere (0.0.0.0/0)
EC2 Security Group sg-ec2
Allow inbound HTTP 3000 from sg-alb
Allow inbound SSH 22 from your IP
Step 6: Create Launch Template
Go to EC2 → Launch Templates → Create Launch Template
Configure:
Name: task2-template
AMI: Ubuntu 22.04 LTS
Instance Type: t2.micro
Key Pair: select your key
Network: VPC task2-vpc
Security Group: sg-ec2
User Data (paste your script below):
#!/bin/bash
sleep 30
apt update -y
apt install -y nodejs npm

cat <<EOF > /home/ubuntu/app.js
const http = require('http');
const os = require('os');

const server = http.createServer((req, res) => {
res.end("Hello from " + os.hostname());
});

server.listen(3000);
EOF

cd /home/ubuntu
node app.js &
Click Create Launch Template

Note: sleep 30 ensures the instance finishes booting before running the script.

Step 7: Create Target Group
Go to EC2 → Target Groups → Create Target Group
Configure:
Name: task2-tg
Target Type: Instances
Protocol: HTTP
Port: 3000
VPC: task2-vpc
Health Check:
Protocol: HTTP
Path: /
Port: 3000
Success codes: 200
Interval: 30 sec
Unhealthy threshold: 2
Healthy threshold: 2
Click Create
Step 8: Create Application Load Balancer (ALB)
Go to EC2 → Load Balancers → Create Load Balancer → Application Load Balancer
Configure:
Name: task2-alb
Scheme: Internet-facing
IP Type: IPv4
Listeners: HTTP 80
Availability Zones: Select public subnets
Security Group: sg-alb
Forward listener to Target Group: task2-tg
Click Create
Step 9: Create Auto Scaling Group (ASG)
Go to EC2 → Auto Scaling Groups → Create Auto Scaling Group
Configure:
Name: task2-asg
Launch Template: task2-template
Network: VPC task2-vpc
Subnets: Private subnets (private-subnet-1, private-subnet-2)
Attach to ALB Target Group: task2-tg
Desired Capacity: 2
Min: 2, Max: 4
Auto Scaling Policy:
Type: Target Tracking
Metric: CPU Utilization
Target: 60%
Step 10: Test Setup
Get ALB DNS from EC2 → Load Balancers
Test in browser or via curl:
curl http://<ALB-DNS>/
Expected response (round-robin across instances):
Hello from ip-10-0-3-6
Hello from ip-10-0-4-14
Step 11: Optional Load Testing
ab -n 1000 -c 100 http://<ALB-DNS>/
Check Auto Scaling: new instances should launch automatically if CPU > 60%
Ensure all target instances show healthy in Target Group
