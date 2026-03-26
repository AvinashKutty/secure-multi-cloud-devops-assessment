Task 4: Containerization SOP (From Scratch)
Step 0: Prerequisites
Install Docker on your machine (Docker Desktop or Docker Engine).
Install AWS CLI and/or Docker Hub account for pushing images.
Have a folder ready for your project, e.g., C:\Projects\DockerTask4.
Step 1: Create Sample Applications

We will make two tiny apps:

1. AWS Service (Python)
   Create folder: aws-service
   Create file app.py inside aws-service/:
   from flask import Flask
   app = Flask(**name**)

@app.route("/")
def hello():
return "Hello from AWS Service!"

if **name** == "**main**":
app.run(host="0.0.0.0", port=5000)
Create requirements.txt in same folder:
flask==2.3.2 2. GCP Service (Node.js)
Create folder: gcp-service
Create file main.js inside gcp-service/:
const express = require('express');
const app = express();
const PORT = 8080;

app.get('/', (req, res) => {
res.send('Hello from GCP Service!');
});

app.listen(PORT, () => {
console.log(`Server running on port ${PORT}`);
});
Create package.json inside gcp-service/:
{
"name": "gcp-service",
"version": "1.0.0",
"main": "main.js",
"dependencies": {
"express": "^4.18.2"
}
}
Step 2: Create Dockerfiles

1. Dockerfile for AWS Service (Python)

# Use lightweight Python image

FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"] 2. Dockerfile for GCP Service (Node.js)
FROM node:20-alpine
WORKDIR /app
COPY package\*.json ./
RUN npm install --production
COPY . .
EXPOSE 8080
CMD ["node", "main.js"]
Step 3: Build Docker Images

Open terminal in each folder:

# AWS Service

cd aws-service
docker build -t aws-service:1.0 .

# GCP Service

cd gcp-service
docker build -t gcp-service:1.0 .
-t is the tag for image versioning.
Step 4: Test Locally

# AWS container

docker run -p 5000:5000 aws-service:1.0

# GCP container

docker run -p 8080:8080 gcp-service:1.0
Open browser:
AWS: http://localhost:5000 → Should say: Hello from AWS Service!
GCP: http://localhost:8080 → Should say: Hello from GCP Service!

✅ This ensures containers are working.

Step 5: Push Images to Registry
Option 1: Docker Hub
docker login
docker tag aws-service:1.0 yourhubusername/aws-service:1.0
docker tag gcp-service:1.0 yourhubusername/gcp-service:1.0
docker push yourhubusername/aws-service:1.0
docker push yourhubusername/gcp-service:1.0
Option 2: AWS ECR (if using AWS)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com
aws ecr create-repository --repository-name aws-service
aws ecr create-repository --repository-name gcp-service
docker tag aws-service:1.0 <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/aws-service:1.0
docker tag gcp-service:1.0 <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/gcp-service:1.0
docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/aws-service:1.0
docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/gcp-service:1.0
Step 6: Verify Images in Registry
Docker Hub: Check your repositories → images should appear.
AWS ECR: Go to AWS Console → ECR → Check your repositories → images visible.
Step 7: Optimization Tips

Use .dockerignore to skip unnecessary files:

**pycache**/
node_modules/
\*.log
.git
Use lightweight images (python:slim, node:alpine).
Pin dependency versions to avoid inconsistencies.
Use caching in Dockerfile to speed up builds.
✅ Expected Outcome
Two working Docker images:
AWS Service running on 5000
GCP Service running on 8080
Images pushed to Docker Hub or AWS ECR.
Fully reproducible builds: anyone can run them on any machine.
