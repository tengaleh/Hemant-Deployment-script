# Update system
sudo yum update -y
# Disable swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
# Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter
cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system

# Install Container Runtime
sudo dnf install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Install Kubernetes Packages
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
EOF

# Install kubelet kubeadm kubectl
sudo yum install -y kubelet kubeadm kubectl
# Enable kubelet:
sudo systemctl enable --now kubelet
# Initialize Kubernetes (MASTER NODE ONLY)
sudo kubeadm init

# Configure kubectl (on Master)
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install CNI (Network Plugin)
# Install Calico:
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml
kubectl get nodes
