#!/bin/bash
set -x

TERRAFORM_VERSION="0.8.4"
PACKER_VERSION="0.10.2"
GO_VERSION="1.8"
VAULT_VERSION="0.6.5"
HELM_VERSION="2.2.0"

# create new ssh key
[[ ! -f /home/ubuntu/.ssh/mykey ]] \
&& mkdir -p /home/ubuntu/.ssh \
&& ssh-keygen -f /home/ubuntu/.ssh/mykey -N '' \
&& chown -R ubuntu:ubuntu /home/ubuntu/.ssh

apt-get upgrade

# install packages
apt-get update
apt-get upgrade
apt-get -y install docker.io ansible unzip vim git zip bzip2 fontconfig curl language-pack-en
# add docker privileges
usermod -G docker ubuntu

export LANGUAGE='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
locale-gen en_US.UTF-8
dpkg-reconfigure locales



# install pip
pip install -U pip && pip3 install -U pip
if [[ $? == 127 ]]; then
    wget -q https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    python3 get-pip.py
fi
# install awscli and ebcli
pip install -U awscli
pip install -U awsebcli

#terraform
T_VERSION=$(terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
T_RETVAL=${PIPESTATUS[0]}

[[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
&& wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# packer
P_VERSION=$(packer -v)
P_RETVAL=$?

[[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip


# vault
V_VERSION=$(vault -v)
V_RETVAL=$?

[[ $V_VERSION != $VAULT_VERSION ]] || [[ $V_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
&& unzip -o vault_${VAULT_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm vault_${VAULT_VERSION}_linux_amd64.zip

apt-get install jq

#kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#helm
[[ $H_VERSION != $HELM_VERSION ]] || [[ $H_RETVAL != 1 ]] \
&& wget -q https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
&& sudo tar -xvzf  helm-v${HELM_VERSION}-linux-amd64.tar.gz --directory /tmp \
&& sudo mv /tmp/linux-amd64/helm /usr/local/bin/ \
&& rm helm-v${HELM_VERSION}-linux-amd64.tar.gz

# go
echo "install Go"
echo "Downloading Go"
curl --silent https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz > /tmp/go.tar.gz
echo "Extracting Go"
sudo tar -xvzf /tmp/go.tar.gz --directory /usr/local >/dev/null 2>&1

export PATH=$PATH:/usr/local/go/bin
export GOPATH=/home/ubuntu/gopath
export GOROOT=/usr/local/go
echo 'export GOPATH="/home/ubuntu/gopath"' >> /home/ubuntu/.bashrc
echo 'export GOROOT=/usr/local/go' >> /home/ubuntu/.bashrc
echo 'export PATH="$PATH:$GOROOT/bin:$GOPATH/bin:/home/ubuntu/"' >> /home/ubuntu/.bashrc

#  install XFCE4
# sudo apt-get install -y xfce4 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
# sudo apt-get install gnome-icon-theme-full tango-icon-theme
# sudo echo “allowed_users=anybody” > /etc/X11/Xwrapper.config

# ensure encoding
#sudo echo “LANG=en_US.UTF-8” >> /etc/environment
#sudo echo “LANGUAGE=en_US.UTF-8” >> /etc/environment
#sudo echo “LC_ALL=en_US.UTF-8” >> /etc/environment
#sudo echo “LC_CTYPE=en_US.UTF-8” >> /etc/environment


# install Java 8
#echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list
#echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list
#apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886

#apt-get update

#echo oracle-java-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
#apt-get install -y --force-yes oracle-java8-installer
#update-java-alternatives -s java-8-oracle

# install node.js
#curl -sL https://deb.nodesource.com/setup_6.x | bash -
#apt-get install -y nodejs unzip python g++ build-essential

# update npm
#npm install -g npm

# install yarn
#npm install -g yarn

# install yeoman grunt bower gulp
#yarn global add yo bower gulp

# install JHipster
#yarn global add generator-jhipster@4.0.6

# install JHipster UML
#yarn global add jhipster-uml@2.0.3

#maven
#sudo apt-get install maven


apt-get -y autoclean
apt-get -y clean
apt-get -y autoremove
