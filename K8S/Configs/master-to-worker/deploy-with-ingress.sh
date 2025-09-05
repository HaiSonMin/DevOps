#!/bin/bash

echo "=== Deploying BoDevOps Application with Helm-based Ingress ==="

# 1. Install Helm (if not already installed)
echo "Step 1: Checking/Installing Helm..."
if ! command -v helm &> /dev/null; then
    echo "Installing Helm..."
    bash install-helm.sh
else
    echo "Helm is already installed: $(helm version --short)"
fi

# 2. Install NGINX Ingress Controller with Helm
echo "Step 2: Installing NGINX Ingress Controller with Helm..."
bash install-nginx-ingress-helm.sh

# 3. Create namespace
echo "Step 3: Creating namespace..."
kubectl create namespace bodevops --dry-run=client -o yaml | kubectl apply -f -

# 4. Deploy application
echo "Step 4: Deploying application..."
kubectl apply -f deployment.yaml
kubectl apply -f service-clusterip.yaml

# 5. Deploy ingress
echo "Step 5: Deploying ingress..."
kubectl apply -f ingress.yaml

# 6. Check status
echo "Step 6: Checking deployment status..."
kubectl get pods -n bodevops
kubectl get svc -n bodevops
kubectl get ingress -n bodevops

# 7. Get ingress IP
echo "Step 7: Getting Ingress IP..."
kubectl get svc -n ingress-nginx

echo ""
echo "=== Deployment Complete with Helm! ==="
echo ""
echo "Helm releases:"
helm list -A
echo ""
echo "To access your application:"
echo "1. Get External IP: kubectl get svc -n ingress-nginx"
echo "2. Add to hosts file: <EXTERNAL-IP> bodevops.local"
echo "3. Access via: http://bodevops.local"
echo ""
echo "Useful Helm commands:"
echo "- helm list -A                    # List all releases"
echo "- helm status ingress-nginx -n ingress-nginx  # Check ingress status"
echo "- helm uninstall ingress-nginx -n ingress-nginx  # Uninstall ingress"