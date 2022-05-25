#!/bin/bash
echo "Provisioning virtual machine..."
apt-get update
apt-get install -y git nano unzip resolvconf apt-transport-https gnupg software-properties-common curl ca-certificates zsh
apt-get update
# Installing Docker
echo "Install Docker CE"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-cache policy docker-ce
apt-get install -y docker-ce
usermod -aG docker vagrant
# insteall docker-compose
echo "Install docker-compose"
curl -L https://github.com/docker/compose/releases/download/2.4.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
# Installing gcloud
echo "Install gcloud sdk"
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
apt-get update
apt-get install -y google-cloud-sdk
gcloud version
# Installing kubectl
echo "Install kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl version
# install Helm
echo "Install Helm"
wget -O helm.tgz https://get.helm.sh/helm-v3.8.2-linux-386.tar.gz
tar -zxvf helm.tgz
mv linux-386/helm /usr/local/bin/helm
# install skaffold
echo "Install Skaffold"
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
chmod +x skaffold
mv skaffold /usr/local/bin
echo "install terraform"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update
apt-get install terraform
# install Argo CLI
echo "install argo CLI"
VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
# install Kubeseal
echo "install kubeseal"
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.17.5/kubeseal-0.17.5-linux-amd64.tar.gz -O kubeseal
install -m 755 kubeseal /usr/local/bin/kubeseal
# install K3D
echo "install K3D"
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
# install VMware Octant
echo "install VMware Octant"
wget -O octant.deb https://github.com/vmware-tanzu/octant/releases/download/v0.25.1/octant_0.25.1_Linux-64bit.deb
dpkg -i octant.deb
# configure resolv.conf file
echo "configure resolv.conf file"
systemctl enable resolvconf.service
systemctl start resolvconf.service
systemctl status resolvconf.service
echo 'nameserver 8.8.8.8' >> /etc/resolvconf/resolv.conf.d/head
echo 'nameserver 8.8.4.4' >> /etc/resolvconf/resolv.conf.d/head
resolvconf --enable-updates
resolvconf -u
# install oh my zsh
echo "install oh my zsh"
runuser -l vagrant -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
chsh -s $(which zsh) vagrant
