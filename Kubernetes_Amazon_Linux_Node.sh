# Update system
sudo yum update -y
# Disable swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
# Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
# Install Container Runtime
sudo dnf install -y containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
#Install Kubernetes Packages
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
# Install CNI (Network Plugin)
# Install Calico:
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/calico.yaml
kubectl get nodes
# Stop kubelet FIRST
sudo systemctl stop kubelet
# Stop container runtime
sudo systemctl stop containerd
# Unmount stuck volumes
sudo umount -lf /var/lib/kubelet/pods/*/volumes/*/* 2>/dev/null
# Stop kubelet
sudo systemctl stop kubelet
# Reset kubeadm
sudo kubeadm reset -f
# Remove old Kubernetes files
sudo rm -rf /etc/kubernetes/
sudo rm -rf /var/lib/kubelet/
sudo rm -rf /var/lib/etcd
sudo rm -rf /etc/cni/net.d
sudo lsof -i :10250
sudo systemctl daemon-reexec
# Restart container runtime
sudo systemctl restart containerd
sudo systemctl enable containerd
# Start kubelet again
sudo systemctl start kubelet
