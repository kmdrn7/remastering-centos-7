echo "============================================"
echo "========= INSTALLING MASTER SERVER ========="
echo "============================================"
echo ". . . ."
echo " . . . ."
echo "#1 Install DHCP Server"
yum install -y dnsmasq
cat <<EOT > /tmp/dnsmasq.conf
    # Interface
    interface=enp0s3,lo
    # Domain Name
    domain=master-server.lokal
    # DHCP range-leases
    dhcp-range=enp0s3,192.168.56.3,192.168.56.254,255.255.255.0,1h
    # PXE
    dhcp-boot=pxelinux.0,pxeserver,192.168.56.101
    # Gateway
    dhcp-option=3,192.168.56.1
    # DNS
    dhcp-option=6,192.168.56.1, 8.8.8.8
    # DNS Forwarder
    server=8.8.4.4
    # Broadcast Address
    dhcp-option=28,192.168.56.255
    # NTP Server
    dhcp-option=42,0.0.0.0
    
    pxe-prompt="Press F8 for menu.", 10
    pxe-service=x86PC, "Install CentOS 7 From Network", pxelinux
    enable-tftp
EOT
mv /tmp/dnsmasq.conf /etc/dnsmasq.conf

echo "#2 Install Syslinux PXE Bootloader"
yum install -y syslinux

echo "#3 Install TFTP Server"
yum install -y tftp-server
cp -r /usr/share/syslinux/* /var/lib/tftpboot

echo "#4 Configuring PXE Server"
mkdir /var/lib/tftpboot/pxelinux.cfg
cat <<EOT > /var/lib/tftpboot/pxelinux.cfg/default
    default menu.c32
    prompt 0
    timeout 300
    ONTIMEOUT local
    
    menu title ########## Kaeluster Boot Menu ##########
    
    label 1
    menu label ^1) Install CentOS 7 x64 [ Auto Install ]
    kernel centos7/vmlinuz
    append initrd=centos7/initrd.img method=ftp://192.168.1.20/pub devfs=nomount
EOT
touch /var/lib/tftpboot/pxelinux.cfg/default

echo "#5 Add CentOS 7 Boot Image to PXE Server"
mount -o loop /dev/cdrom /mnt
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
firewall --enable --ftp
firewall --enable --dns
firewall --enable --dhcp
firewall --enable --port=69:udp
firewall --enable --port=4011:udp

umount /mnt
