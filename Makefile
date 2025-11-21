.PHONY: help install test build run docker-build docker-run k8s-deploy k8s-delete clean

# Variables
IMAGE_NAME=cicd-demo
DOCKER_USERNAME=
IMAGE_TAG=latest
DOCKER_IMAGE=$(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)

help: ## Show this help
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

install: ## Install dependencies
	npm install

test: ## Run tests
	npm test

build: install test ## Build the application
	@echo "Application built successfully"

run: ## Run application locally
	npm start

docker-build: ## Build Docker image
	docker build -t $(IMAGE_NAME):local .

docker-run: docker-build ## Run Docker container
	docker run -d -p 3000:3000 --name $(IMAGE_NAME) $(IMAGE_NAME):local

docker-stop: ## Stop Docker container
	docker stop $(IMAGE_NAME) || true
	docker rm $(IMAGE_NAME) || true

docker-push: docker-build ## Build and push to Docker Hub
	docker tag $(IMAGE_NAME):local $(DOCKER_IMAGE)
	docker push $(DOCKER_IMAGE)

docker-compose-up: ## Start with docker-compose
	docker-compose up -d

docker-compose-down: ## Stop docker-compose
	docker-compose down

minikube-start: ## Start Minikube
	minikube start

minikube-load: docker-build ## Load image into Minikube
	minikube image load $(IMAGE_NAME):local

k8s-deploy: ## Deploy to Kubernetes
	kubectl apply -f k8s/deployment.yaml
	kubectl apply -f k8s/service.yaml

k8s-status: ## Check Kubernetes status
	kubectl get all
	kubectl get pods -l app=cicd-demo

k8s-logs: ## View Kubernetes logs
	kubectl logs -l app=cicd-demo --tail=50 -f

k8s-delete: ## Delete Kubernetes resources
	kubectl delete -f k8s/deployment.yaml || true
	kubectl delete -f k8s/service.yaml || true

k8s-restart: ## Restart Kubernetes deployment
	kubectl rollout restart deployment/cicd-demo-deployment

k8s-scale: ## Scale deployment (usage: make k8s-scale REPLICAS=5)
	kubectl scale deployment/cicd-demo-deployment --replicas=$(REPLICAS)

clean: docker-stop k8s-delete ## Clean up everything
	docker rmi $(IMAGE_NAME):local || true
	rm -rf node_modules coverage

all: build docker-build k8s-deploy ## Build, dockerize, and deploy
