#!/bin/sh

# Masuk menjadi sudo
echo "#0 Preparing Environtment for Installing Wordpress ====="
sudo -i
yum -y install unzip
cd /tmp/config
unzip conf.zip
rm conf.zip

echo "========================================================="
echo "========= INSTALLING WORDPRESS ON MASTER SERVER ========="
echo "========================================================="
echo ". . . ."
echo " . . . ."
echo "#1 Installing NGINX Web Server =========================="
sleep 2s
yum -y install epel-release
yum -y install nginx

echo "#2 Enabling NGINX Web Server ============================"
sleep 2s
systemctl start nginx
systemctl enable nginx
systemctl status nginx

firewall-cmd --permanent --add-service=http
firewall-cmd --reload
setenforce 0

echo "#3 Installing MariaDB ==================================="
sleep 2s

cat <<EOT >> /etc/yum.repos.d/mariadb.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/rhel7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOT

yum -y install mariadb-server mariadb
systemctl start mariadb
systemctl enable mariadb
mysqladmin -u root password 'root'

echo "#4 Installing PHP 7 ====================================="
sleep 2s
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum -y install yum-utils
yum-config-manager --enable remi-php73
yum -y install php php-mysql php-fpm php-gd php-xml php-mbstring php-opcache php-devel php-pear php-bcmath

echo "#5 Enabling PHP 7 ======================================="
sleep 2s
mv /tmp/config/www.conf /etc/php-fpm.d/www.conf
systemctl start php-fpm
systemctl enable php-fpm

echo "#6 Setup Directory For Wordpress Instalation ============"
cp /tmp/config/wp.conf /etc/nginx/conf.d/
mkdir /usr/share/nginx/wp
mkdir /usr/share/nginx/wp/logs
setenforce 0
systemctl restart nginx
systemctl restart php-fpm

echo "#7 Setup MySQL Database for Wordpress ============"
mysql -u root -proot < /tmp/config/setup.sql

echo "#8 Downloading Latest Wordpress Instalation ============"
cd /tmp
tar -zxvf wp.tar.gz
mv wordpress/* /usr/share/nginx/wp
cp /tmp/config/wp-config.php /usr/share/nginx/wp/wp-config.php
chown -R nginx:nginx /usr/share/nginx/wp/

echo "============================================"
echo "======== MASTER SERVER IS INSTALLED ========"
echo "============================================"
