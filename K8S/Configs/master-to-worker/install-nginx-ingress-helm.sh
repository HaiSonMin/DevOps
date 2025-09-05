#!/bin/bash

echo "=== Installing NGINX Ingress Controller with Helm ==="

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "Helm is not installed. Please run install-helm.sh first!"
    exit 1
fi

# Add ingress-nginx repository
echo "Adding ingress-nginx Helm repository..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Create namespace for ingress
echo "Creating ingress-nginx namespace..."
kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -

# Install NGINX Ingress Controller
echo "Installing NGINX Ingress Controller..."
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.replicaCount=2 \
  --set controller.nodeSelector."kubernetes\.io/os"=linux \
  --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
  --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
  --set controller.service.type=LoadBalancer \
  --set controller.service.externalTrafficPolicy=Local

# Wait for deployment
echo "Waiting for NGINX Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

# Check status
echo ""
echo "NGINX Ingress Controller status:"
helm list -n ingress-nginx
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

echo ""
echo "=== Installation Complete! ==="
echo "External IP will be available soon. Check with:"
echo "kubectl get svc -n ingress-nginx"