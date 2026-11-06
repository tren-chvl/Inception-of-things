
#!/bin/bash

set -euo pipefail

echo "=== Mise à jour des paquets ==="
sudo apt update

echo "=== Installation des outils nécessaires ==="
sudo apt install -y curl ca-certificates gnupg docker.io

echo "=== Démarrage de Docker ==="
sudo systemctl enable --now docker

echo "=== Ajout de l'utilisateur au groupe Docker ==="
sudo usermod -aG docker "${SUDO_USER:-$USER}"

echo "=== Installation de kubectl ==="
KUBECTL_VERSION="v1.35.6"

curl -fsSLo /tmp/kubectl \
    "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

curl -fsSLo /tmp/kubectl.sha256 \
    "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256"

echo "$(cat /tmp/kubectl.sha256)  /tmp/kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl

rm -f /tmp/kubectl /tmp/kubectl.sha256

echo "=== Installation de K3d ==="
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "=== Vérification des installations ==="
docker --version
kubectl version --client
k3d version

echo "=== Installation terminée ==="
echo "Reconnectez-vous à votre session pour utiliser Docker sans sudo."
