#!/bin/bash

echo "=== Installing Helm ==="

# Check if Helm is already installed
if command -v helm &> /dev/null; then
    echo "Helm is already installed: $(helm version --short)"
    exit 0
fi

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

case $OS in
    Linux*)
        echo "Installing Helm on Linux..."
        curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
        sudo apt-get install apt-transport-https --yes
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
        sudo apt-get update
        sudo apt-get install helm
        ;;
    Darwin*)
        echo "Installing Helm on macOS..."
        if command -v brew &> /dev/null; then
            brew install helm
        else
            echo "Homebrew not found. Installing via script..."
            curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
            chmod 700 get_helm.sh
            ./get_helm.sh
            rm get_helm.sh
        fi
        ;;
    MINGW*|CYGWIN*|MSYS*)
        echo "Installing Helm on Windows..."
        echo "Please install Helm manually:"
        echo "1. Download from: https://github.com/helm/helm/releases"
        echo "2. Or use Chocolatey: choco install kubernetes-helm"
        echo "3. Or use Scoop: scoop install helm"
        exit 1
        ;;
    *)
        echo "Unsupported OS: $OS"
        echo "Please install Helm manually from: https://helm.sh/docs/intro/install/"
        exit 1
        ;;
esac

# Verify installation
echo ""
echo "Helm installation completed!"
helm version

# Add common repositories
echo ""
echo "Adding common Helm repositories..."
helm repo add stable https://charts.helm.sh/stable
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo "Available repositories:"
helm repo list