**Task 3 – GCP Environment Setup Using VM**

Objective:

Set up a GCP-based VM to host a dummy ML API, ensuring restricted access only from AWS or VPN.

**Step 1: Log in to GCP Console**
Open https://console.cloud.google.com

.
Select the project where the VM will be created.
Ensure you have Compute Engine API enabled.


**Step 2: Create a GCP VM Instance**
Navigate to Compute Engine → VM Instances → Create Instance.
Configure the instance:
Name: ml-vm
Region/Zone: e.g., us-central1-a
Machine type: e2-micro (sufficient for dummy API)
Boot disk: Ubuntu 22.04 LTS
Firewall: Tick Allow HTTP traffic and Allow HTTPS traffic
Click Create.


**Step 3: SSH Into the VM**
From GCP Console, click SSH button on your VM.
Or use local terminal:
gcloud compute ssh ml-vm --zone=us-central1-a
Update the VM packages:
sudo apt update && sudo apt upgrade -y



**Step 4: Install Python & Flask**
Install Python and pip:
sudo apt install python3-pip python3-venv -y
Install Flask:
pip3 install flask



**Step 5: Set Up the Dummy ML API**
Create a project folder:
```bash
mkdir ~/ml-api && cd ~/ml-api
```
Create app.py:
```bash
from flask import Flask, jsonify, request

app = Flask(**name**)

@app.route('/predict', methods=['POST'])
def predict():
data = request.json
return jsonify({"input": data, "prediction": "dummy_result"})

if name == 'main':
app.run(host='0.0.0.0', port=8080)
Optional: Create requirements.txt:
flask
Install requirements:
pip3 install -r requirements.txt
```


**Step 6: Run the API**
Start the Flask API:
python3 app.py
Verify the API is running:
```bash
curl -X POST http://<VM_EXTERNAL_IP>:8080/predict -H "Content-Type: application/json" -d '{"feature1":10}'
```
**Expected output:**
{
"input": {"feature1":10},
"prediction": "dummy_result"
}


**Step 7: Restrict Access to AWS/VPN**
Identify AWS public IPs or VPN subnet. Example:
```bash
AWS subnet: 3.88.181.15/32
VPN subnet: 10.8.0.0/24
Create GCP Firewall Rule:
gcloud compute firewall-rules create allow-aws-vpn \
 --direction=INGRESS \
 --priority=1000 \
 --network=default \
 --action=ALLOW \
 --rules=tcp:8080 \
 --source-ranges=3.88.181.15/32,10.8.0.0/24
Remove default HTTP access to prevent public access:
gcloud compute firewall-rules delete default-allow-http
```



**Step 8: Verify Secure Access**
From an AWS EC2 instance or VPN client, test API:
```bash
curl -X POST http://<VM_EXTERNAL_IP>:8080/predict -H "Content-Type: application/json" -d '{"feature1":10}'
```
From a non-allowed IP, access should fail.


**Step 9: Optional – Run Flask API as a Service**

```bash
Install systemd service for automatic start:
sudo nano /etc/systemd/system/ml-api.service
Add:
[Unit]
Description=ML API Service
After=network.target

[Service]
User=<YOUR_VM_USERNAME>
WorkingDirectory=/home/<YOUR_VM_USERNAME>/ml-api
ExecStart=/usr/bin/python3 /home/<YOUR_VM_USERNAME>/ml-api/app.py
Restart=always

[Install]
WantedBy=multi-user.target
Enable and start service:
sudo systemctl enable ml-api
sudo systemctl start ml-api
sudo systemctl status ml-api
```

**Expected Outcome**
Functional ML API on GCP VM
Access restricted to only AWS IPs or VPN
Multi-cloud understanding demonstrated
