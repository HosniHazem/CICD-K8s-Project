# CI/CD with Docker and Kubernetes Demo Project

A complete example demonstrating CI/CD pipeline implementation using Docker, Kubernetes, and GitHub Actions.

## 📋 Project Overview

This project includes:
- Simple Node.js Express application
- Docker containerization
- Kubernetes deployment manifests
- GitHub Actions CI/CD pipeline
- Automated testing and deployment

## 🏗️ Architecture

```
Application → Docker Image → Docker Registry → Kubernetes Cluster
     ↓             ↓                ↓                  ↓
   Tests    Build & Push      GitHub Actions    Auto Deploy
```

## 📁 Project Structure

```
cicd-k8s-project/
├── app.js                      # Main application
├── app.test.js                 # Unit tests
├── package.json                # Dependencies
├── Dockerfile                  # Docker configuration
├── .dockerignore              # Docker ignore patterns
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # CI/CD pipeline
└── k8s/
    ├── deployment.yaml        # K8s deployment
    └── service.yaml           # K8s service
```

## 🚀 Implementation Steps

### Step 1: Prerequisites

Install the following tools:

1. **Docker Desktop** - [Download](https://www.docker.com/products/docker-desktop)
2. **kubectl** - [Install Guide](https://kubernetes.io/docs/tasks/tools/)
3. **Minikube** (for local K8s) - [Install Guide](https://minikube.sigs.k8s.io/docs/start/)
4. **Node.js 18+** - [Download](https://nodejs.org/)
5. **Git** - [Download](https://git-scm.com/)

### Step 2: Clone and Setup Project

```bash
# Extract the ZIP file and navigate to the project
cd cicd-k8s-project

# Install dependencies
npm install
```

### Step 3: Test Locally

```bash
# Run the application
npm start

# In another terminal, test the API
curl http://localhost:3000
curl http://localhost:3000/health

# Run tests
npm test
```

### Step 4: Build and Test Docker Image

```bash
# Build the Docker image
docker build -t cicd-demo:local .

# Run the container
docker run -p 3000:3000 cicd-demo:local

# Test the containerized app
curl http://localhost:3000

# Stop the container
docker ps  # Find container ID
docker stop <container-id>
```

### Step 5: Setup Docker Hub

1. Create account at [Docker Hub](https://hub.docker.com/)
2. Create a repository named `cicd-demo`
3. Login to Docker:

```bash
docker login
```

4. Tag and push your image:

```bash
# Replace 'haz3m' with your actual username
docker tag cicd-demo:local haz3m/cicd-demo:latest
docker push haz3m/cicd-demo:latest
```

### Step 6: Setup Local Kubernetes Cluster

```bash
# Start Minikube
minikube start

# Verify cluster is running
kubectl cluster-info
kubectl get nodes

# Enable ingress (optional)
minikube addons enable ingress
```

### Step 7: Update Kubernetes Manifests

Edit `k8s/deployment.yaml` and replace:
```yaml
image: haz3m/cicd-demo:latest
```
with your actual Docker Hub username.

### Step 8: Deploy to Kubernetes

```bash
# Apply the deployment
kubectl apply -f k8s/deployment.yaml

# Apply the service
kubectl apply -f k8s/service.yaml

# Check deployment status
kubectl get deployments
kubectl get pods
kubectl get services

# Wait for pods to be ready
kubectl wait --for=condition=ready pod -l app=cicd-demo --timeout=120s
```

### Step 9: Access the Application

```bash
# Get the service URL (Minikube)
minikube service cicd-demo-service --url

# Or use port forwarding
kubectl port-forward service/cicd-demo-service 8080:80

# Test the application
curl http://localhost:8080
```

### Step 10: Setup GitHub Actions CI/CD

1. Create a new repository on GitHub
2. Push your code:

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/your-username/cicd-k8s-demo.git
git push -u origin main
```

3. Add GitHub Secrets (Settings → Secrets and variables → Actions):
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub password or access token
   - `KUBE_CONFIG`: Your Kubernetes config (base64 encoded)

To get base64 encoded kubeconfig:
```bash
cat ~/.kube/config | base64 | tr -d '\n'
```

4. Update `.github/workflows/ci-cd.yml`:
   - Replace `haz3m` with your Docker Hub username

### Step 11: Trigger CI/CD Pipeline

```bash
# Make a change to the application
echo "// Updated" >> app.js

# Commit and push
git add .
git commit -m "Update application"
git push origin main
```

The pipeline will automatically:
1. Run tests
2. Build Docker image
3. Push to Docker Hub
4. Deploy to Kubernetes

### Step 12: Monitor Deployment

```bash
# Watch deployment progress
kubectl rollout status deployment/cicd-demo-deployment

# Check pods
kubectl get pods -w

# View logs
kubectl logs -l app=cicd-demo --tail=50 -f

# Describe deployment
kubectl describe deployment cicd-demo-deployment
```

## 🔧 Useful Commands

### Docker Commands

```bash
# List images
docker images

# List containers
docker ps -a

# Remove image
docker rmi <image-id>

# View logs
docker logs <container-id>

# Execute command in container
docker exec -it <container-id> sh
```

### Kubernetes Commands

```bash
# Get all resources
kubectl get all

# Delete deployment
kubectl delete -f k8s/deployment.yaml

# Delete service
kubectl delete -f k8s/service.yaml

# Scale deployment
kubectl scale deployment/cicd-demo-deployment --replicas=5

# Get pod logs
kubectl logs <pod-name>

# Execute command in pod
kubectl exec -it <pod-name> -- sh

# Describe resource
kubectl describe pod <pod-name>
```

### Debugging Commands

```bash
# Check events
kubectl get events --sort-by='.lastTimestamp'

# Check pod status
kubectl get pods -o wide

# Check service endpoints
kubectl get endpoints

# Port forward for debugging
kubectl port-forward <pod-name> 3000:3000
```

## 🧪 Testing the Pipeline

### Test Scenarios

1. **Feature Development**:
```bash
git checkout -b feature/new-endpoint
# Make changes
git commit -am "Add new endpoint"
git push origin feature/new-endpoint
# Create PR - pipeline runs tests
```

2. **Production Deployment**:
```bash
git checkout main
git merge feature/new-endpoint
git push origin main
# Pipeline deploys to K8s
```

3. **Rollback**:
```bash
kubectl rollout undo deployment/cicd-demo-deployment
kubectl rollout status deployment/cicd-demo-deployment
```

## 📊 Monitoring

### Check Application Health

```bash
# Get service URL
kubectl get service cicd-demo-service

# Test health endpoint
curl http://<service-url>/health

# Check metrics
kubectl top pods
kubectl top nodes
```

## 🛠️ Troubleshooting

### Common Issues

1. **ImagePullBackOff**:
   - Check Docker Hub username in deployment.yaml
   - Verify image exists: `docker pull haz3m/cicd-demo:latest`

2. **CrashLoopBackOff**:
   - Check logs: `kubectl logs <pod-name>`
   - Verify health check endpoints

3. **Service Not Accessible**:
   - Check service: `kubectl describe service cicd-demo-service`
   - Verify pods are running: `kubectl get pods`

4. **GitHub Actions Failing**:
   - Check secrets are configured correctly
   - Verify workflow syntax
   - Check Actions logs in GitHub

## 🎯 Next Steps

1. **Add Database**: Include PostgreSQL/MongoDB deployment
2. **Implement Ingress**: Setup ingress controller for routing
3. **Add Monitoring**: Integrate Prometheus and Grafana
4. **Setup Helm**: Convert to Helm charts
5. **Multi-environment**: Add staging/production environments
6. **Add Secrets Management**: Use Kubernetes Secrets or external vault
7. **Implement Blue-Green Deployment**: Zero-downtime deployments

## 📚 Resources

- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)

## 📝 License

MIT License - feel free to use this project for learning and development.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!
