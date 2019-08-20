#!/bin/sh

# Masuk menjadi sudo
sudo -i

# Buat konfigurasi network baru
cat > /etc/sysconfig/network-scripts/ifcfg-enp0s8 <<EOT
DEVICE=enp0s8
ONBOOT=yes
BOOTPROTO=static
BROADCAST=192.168.10.255
IPADDR=192.168.10.2
NETMASK=255.255.255.0
NETWORK=192.168.10.0
TYPE=Ethernet
EOT

# Restart network
/etc/init.d/network restart

echo "============================================"
echo "========= INSTALLING MASTER SERVER ========="
echo "============================================"
echo ". . . ."
echo " . . . ."
echo "#1 Install DHCP Server"
yum install -y wget dnsmasq
wget http://192.168.10.1/centos/dnsmasq.conf -O /etc/dnsmasq.conf

echo "#2 Install Syslinux PXE Bootloader"
yum install -y syslinux

echo "#3 Install TFTP Server"
yum install -y tftp-server
cp -r /usr/share/syslinux/* /var/lib/tftpboot

echo "#4 Configuring PXE Server"
mkdir /var/lib/tftpboot/pxelinux.cfg
wget http://192.168.10.1/centos/default_pxe_config -O /var/lib/tftpboot/pxelinux.cfg/default

echo "#5 Add CentOS 7 Boot Image to PXE Server"
# Download CentOS 7 Image
wget http://192.168.10.1/centos/centos.iso -O /tmp/centos.iso
mount -o loop /tmp/centos.iso /mnt
ls /mnt
mkdir /var/lib/tftpboot/centos7
cp /mnt/images/pxeboot/vmlinuz  /var/lib/tftpboot/centos7
cp /mnt/images/pxeboot/initrd.img  /var/lib/tftpboot/centos7

echo "#6 Create CentOS 7 Local Mirror Instalation"
yum install -y vsftpd
cp -r /mnt/*  /var/ftp/pub/
chmod -R 755 /var/ftp/pub

echo "#7 Starting & Enabling All Services"
systemctl start dnsmasq
systemctl status dnsmasq
systemctl start vsftpd
systemctl status vsftpd
systemctl enable dnsmasq
systemctl enable vsftpd

echo "#8 Configure Firewall Permission"
firewall-cmd --permanent --add-service=ftp
firewall-cmd --permanent --add-service=dns
firewall-cmd --permanent --add-service=dhcp
firewall-cmd --permanent --add-port=69/udp
firewall-cmd --permanent --add-port=4011/udp
firewall-cmd --reload

umount /mnt

echo "============================================"
echo "======== MASTER SERVER IS INSTALLED ========"
echo "============================================"
