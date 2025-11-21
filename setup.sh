#!/bin/bash

# CI/CD Kubernetes Demo - Setup Script
# This script helps automate the initial setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "CI/CD Kubernetes Demo - Setup Script"
echo "========================================="
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "Checking prerequisites..."
echo ""

# Check Docker
if command_exists docker; then
    echo -e "${GREEN}✓${NC} Docker is installed: $(docker --version)"
else
    echo -e "${RED}✗${NC} Docker is not installed"
    echo "  Install from: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check kubectl
if command_exists kubectl; then
    echo -e "${GREEN}✓${NC} kubectl is installed: $(kubectl version --client --short 2>/dev/null || kubectl version --client)"
else
    echo -e "${YELLOW}⚠${NC} kubectl is not installed (optional for local development)"
    echo "  Install from: https://kubernetes.io/docs/tasks/tools/"
fi

# Check minikube
if command_exists minikube; then
    echo -e "${GREEN}✓${NC} Minikube is installed: $(minikube version --short)"
else
    echo -e "${YELLOW}⚠${NC} Minikube is not installed (optional for local Kubernetes)"
    echo "  Install from: https://minikube.sigs.k8s.io/docs/start/"
fi

# Check Node.js
if command_exists node; then
    echo -e "${GREEN}✓${NC} Node.js is installed: $(node --version)"
else
    echo -e "${RED}✗${NC} Node.js is not installed"
    echo "  Install from: https://nodejs.org/"
    exit 1
fi

# Check npm
if command_exists npm; then
    echo -e "${GREEN}✓${NC} npm is installed: $(npm --version)"
else
    echo -e "${RED}✗${NC} npm is not installed"
    exit 1
fi

echo ""
echo "========================================="
echo "Installing dependencies..."
echo "========================================="
echo ""

npm install

echo ""
echo -e "${GREEN}✓${NC} Dependencies installed successfully!"
echo ""

# Ask if user wants to setup Docker Hub
echo "========================================="
read -p "Do you want to configure Docker Hub settings? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter your Docker Hub username: " DOCKER_USERNAME
    
    # Update files with Docker Hub username
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/haz3m/$DOCKER_USERNAME/g" k8s/deployment.yaml
        sed -i '' "s/haz3m/$DOCKER_USERNAME/g" .github/workflows/ci-cd.yml
        sed -i '' "s/haz3m/$DOCKER_USERNAME/g" Makefile
    else
        # Linux
        sed -i "s/haz3m/$DOCKER_USERNAME/g" k8s/deployment.yaml
        sed -i "s/haz3m/$DOCKER_USERNAME/g" .github/workflows/ci-cd.yml
        sed -i "s/haz3m/$DOCKER_USERNAME/g" Makefile
    fi
    
    echo -e "${GREEN}✓${NC} Docker Hub username configured!"
fi

echo ""
echo "========================================="
echo "Setup Complete! 🎉"
echo "========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Test the application locally:"
echo "   npm start"
echo ""
echo "2. Build and test Docker image:"
echo "   docker build -t cicd-demo:local ."
echo "   docker run -p 3000:3000 cicd-demo:local"
echo ""
echo "3. Deploy to local Kubernetes:"
echo "   minikube start"
echo "   kubectl apply -f k8s/"
echo ""
echo "For detailed instructions, see:"
echo "  - README.md (comprehensive guide)"
echo "  - QUICK_START.md (fast setup)"
echo ""
echo "Or use the Makefile:"
echo "  make help"
echo ""
