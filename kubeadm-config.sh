
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address "0.0.0.0"
 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
###### Install Calico ######
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/calico.yaml
 
kubectl taint nodes --all node-role.kubernetes.io/control-plane-