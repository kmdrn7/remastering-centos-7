#!/bin/sh

# Masuk menjadi sudo
sudo -i

echo "============================================"
echo "========= INSTALLING MASTER SERVER ========="
echo "============================================"
echo ". . . ."
echo " . . . ."
echo "#0 Preparing Python3 Environment ==========="
sleep 2s
yum -y install yum-utils
yum -y groupinstall development
yum -y install https://centos7.iuscommunity.org/ius-release.rpm

echo "#1 Installing Python3 ======================"
sleep 2s
yum -y install python36u python36u-pip python36u-devel
exit

echo "#2 Creating Python3 Virtual Environtment ==="
sleep 2s
cd ~/
python3.6 -m venv env
source env/bin/activate
pip install wheel
pip install flask
deactivate

echo "============================================"
echo "======== MASTER SERVER IS INSTALLED ========"
echo "============================================"
