# 🚀 Quick Start Guide

Get up and running in 10 minutes!

## Prerequisites Check

Run these commands to verify installations:

```bash
docker --version
kubectl version --client
minikube version
node --version
git --version
```

If any are missing, refer to the main README.md for installation links.

## 5-Step Quick Start

### 1️⃣ Setup Project (2 minutes)

```bash
# Extract and enter project
cd cicd-k8s-project

# Install dependencies
npm install

# Test locally
npm start
```

Visit: http://localhost:3000

### 2️⃣ Docker Build (2 minutes)

```bash
# Build image
docker build -t cicd-demo:local .
docker build -t cicd-demo:latest .

# Run container
docker run -d -p 3000:3000 --name cicd-demo cicd-demo:local

# Test
curl http://localhost:3000

# Stop
docker stop cicd-demo && docker rm cicd-demo
```

### 3️⃣ Kubernetes Local Deployment (3 minutes)

```bash
# Start Minikube
minikube start
or 
minikube start --driver=docker


# Update k8s/deployment.yaml
# OR use local image:
# In k8s/deployment.yaml, change image to: cicd-demo:local
# And add: imagePullPolicy: Never

# Load local image into Minikube (if not using Docker Hub)
minikube image load cicd-demo:local

# Deploy
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Check status
kubectl get pods
kubectl get svc

# Access application
minikube service cicd-demo-service --url
```

### 4️⃣ Docker Hub Setup (2 minutes)

```bash
# Login to Docker Hub
docker login

# Tag image
docker tag cicd-demo:local YOUR_USERNAME/cicd-demo:latest

# Push
docker push YOUR_USERNAME/cicd-demo:latest
```

### 5️⃣ GitHub Actions Setup (1 minute)

```bash
# Initialize git
git init
git add .
git commit -m "Initial commit"

# Create repo on GitHub, then:
git remote add origin YOUR_REPO_URL
git push -u origin main

# Add these secrets in GitHub Settings → Secrets:
# - DOCKER_USERNAME
# - DOCKER_PASSWORD
# - KUBE_CONFIG (run: cat ~/.kube/config | base64 | tr -d '\n')
```

## 🧪 Quick Tests

```bash
# Test app
curl http://localhost:3000
curl http://localhost:3000/health

# Check K8s
kubectl get all
kubectl logs -l app=cicd-demo

# Scale up
kubectl scale deployment/cicd-demo-deployment --replicas=5
kubectl get pods

# Scale down
kubectl scale deployment/cicd-demo-deployment --replicas=2
```

## 🛑 Cleanup

```bash
# Stop Kubernetes
kubectl delete -f k8s/deployment.yaml
kubectl delete -f k8s/service.yaml
minikube stop

# Remove Docker images
docker rmi cicd-demo:local
docker rmi YOUR_USERNAME/cicd-demo:latest
```

## 🎓 What You've Learned

✅ Containerized a Node.js application with Docker
✅ Deployed to Kubernetes with scaling and health checks
✅ Setup automated CI/CD pipeline with GitHub Actions
✅ Pushed images to Docker Hub registry
✅ Managed deployments with kubectl

## 📖 Next Steps

- Read the full README.md for detailed explanations
- Explore advanced Kubernetes features (ingress, ConfigMaps, Secrets)
- Add a database to your deployment
- Implement monitoring with Prometheus
- Try deploying to cloud providers (AWS EKS, GKE, AKS)

Happy deploying! 🎉
