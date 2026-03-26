**Folder Structure**

```bash
ci-cd-demo/
│
├── app.py # Python app (or index.js for Node.js)
├── requirements.txt # Python dependencies (or package.json for Node.js)
├── Dockerfile # Docker configuration
├── tests/ # Folder for automated tests
│ └── test_app.py # Sample test file
└── .github/
└── workflows/
└── ci-cd.yml # GitHub Actions workflow file
```
**Prerequisites**
EC2 Instance (Ubuntu recommended)
Security group allows port 5000 (or your app port)

Install Docker:

```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
Install AWS CLI (optional if you plan to integrate AWS later)
Docker Hub account
GitHub repository
GitHub Secrets:
DOCKER_USERNAME → Docker Hub username
DOCKER_PASSWORD → Docker Hub password
EC2_HOST → Public IP of EC2
EC2_USER → EC2 username (usually ubuntu)
EC2_KEY → Base64-encoded private key (PEM) for SSH

```

**Application + Docker Setup**
```bash
Python App (app.py):
from flask import Flask
app = Flask(**name**)

@app.route("/")
def home():
return "Hello, CI/CD World!"

if **name** == "**main**":
app.run(host="0.0.0.0", port=5000)
requirements.txt:
Flask==2.3.2
pytest==7.4.0
Dockerfile:
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
Tests (tests/test_app.py):
def test_example():
assert 2 + 2 == 4

```

**GitHub Actions Workflow**

Create .github/workflows/ci-cd.yml:

name: CI/CD Pipeline to EC2
```bash
on:
push:
branches: - main

env:
IMAGE_NAME: your-dockerhub-username/ci-cd-demo
IMAGE_TAG: ${{ github.sha }}

jobs:
build-test:
runs-on: ubuntu-latest
steps: - name: Checkout Code
uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Build Docker Image
        run: docker build -t $IMAGE_NAME:$IMAGE_TAG .

      - name: Run Tests
        run: |
          pip install pytest
          pytest tests/

push-deploy:
needs: build-test
runs-on: ubuntu-latest
steps: - name: Checkout Code
uses: actions/checkout@v3

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Push Docker Image to Docker Hub
        run: docker push $IMAGE_NAME:$IMAGE_TAG

      - name: Deploy to EC2
        uses: appleboy/ssh-action@v0.1.6
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ${{ secrets.EC2_USER }}
          key: ${{ secrets.EC2_KEY }}
          script: |
            docker pull $IMAGE_NAME:$IMAGE_TAG
            docker stop ci-cd-demo || true
            docker rm ci-cd-demo || true
            docker run -d --name ci-cd-demo -p 5000:5000 $IMAGE_NAME:$IMAGE_TAG
```

**Steps to Encode EC2 Key for GitHub Secrets**
Encode PEM file in base64:
base64 -w0 mykey.pem
Copy the output and paste into GitHub Secrets as EC2_KEY.
Trigger Pipeline
Push code to main branch:
```bash
git add .
git commit -m "Add CI/CD pipeline"
git push
```

GitHub Actions will automatically:

```bash
Build → Test → Dockerize → Push Docker Hub → Deploy on EC2
```

**Verify Deployment**
Go to EC2 instance:
```bash
docker ps
Check if container is running.
Open browser → http://<EC2_PUBLIC_IP>:5000
You should see: Hello, CI/CD World!
```

**Outcome**

Every push automatically builds, tests, pushes Docker image to Docker Hub, and deploys it to EC2.
Fully automated CI/CD pipeline with zero manual intervention.
