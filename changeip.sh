# Stop Services
systemctl stop kubelet docker

# Backup Kubernetes and kubelet
mv -f /etc/kubernetes /etc/kubernetes-backup
mv -f /var/lib/kubelet /var/lib/kubelet-backup

# Keep the certs we need
mkdir -p /etc/kubernetes
cp -r /etc/kubernetes-backup/pki /etc/kubernetes
rm -rf /etc/kubernetes/pki/{apiserver.*,etcd/peer.*}

# Start docker
systemctl start docker

# Get current public ip address
IP=$(curl -s ifconfig.me)

# Init cluster with new ip address
kubeadm init --control-plane-endpoint $IP \
--ignore-preflight-errors=DirAvailable--var-lib-etcd

# Verify resutl
kubectl cluster-info
