#!/bin/sh

# Masuk menjadi sudo
sudo -i

echo "============================================"
echo "========= INSTALLING MASTER SERVER ========="
echo "============================================"
echo ". . . ."
echo " . . . ."
echo "#1 Installing Python3"
yum -y install yum-utils
yum -y groupinstall development
yum -y install https://centos7.iuscommunity.org/ius-release.rpm
yum -y install python36u python36u-pip python36u-devel

echo "#2 Creating Python3 Virtual Environtment"
python3.6 -m venv ENV

echo "============================================"
echo "======== MASTER SERVER IS INSTALLED ========"
echo "============================================"
