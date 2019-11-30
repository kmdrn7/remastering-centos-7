#!/bin/sh
sudo -i
echo "========================================================="
echo "========= INSTALLING WORDPRESS ON MASTER SERVER ========="
echo "========================================================="
echo ". . . ."
echo " . . . ."

echo "========================================================="
echo "#0 Preparing Environtment for Installing Wordpress ======"
echo "========================================================="
cd /tmp/config
echo "- installing unzip, yum-utils, vim"
yum -y install unzip yum-utils vim
echo "- unzipping file configuration"
unzip config.zip
echo "- disabling SELinux"
mv SELinux /etc/selinux/config
echo "- removing old configutation zip file"
rm config.zip

echo "========================================================="
echo "#1 Installing NGINX Web Server =========================="
echo "========================================================="
sleep 2s
echo "- adding public repository"
yum -y install epel-release
echo "- installing nginx"
yum -y install httpd

echo "========================================================="
echo "#2 Enabling NGINX Web Server ============================"
echo "========================================================="
sleep 2s
systemctl start httpd
systemctl enable httpd
systemctl status httpd
echo "- add firewall rule for HTTP"
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
setenforce 0

echo "========================================================="
echo "#3 Installing MariaDB ==================================="
echo "========================================================="
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
echo "- change default mysql password to root"
mysqladmin -u root password 'root'

echo "========================================================="
echo "#4 Installing PHP 7 ====================================="
echo "========================================================="
sleep 2s
echo "- add php7 repository"
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72
echo "- installing php plugin for wordpress"
yum -y install php php-mysql php-gd php-xml php-mbstring php-opcache php-devel php-pear php-bcmath

echo "========================================================="
echo "#7 Setup MySQL Database for Wordpress ==================="
echo "========================================================="
echo "- create user and database for wordpress"
mysql -u root -proot < /tmp/config/setup.sql

echo "========================================================="
echo "#8 Downloading Latest Wordpress Instalation ============="
echo "========================================================="
cd /tmp/config
echo "- extracting wordpress instalation files"
tar -zxvf wp.tar.gz
echo "- copying wordpress to nginx public folder"
mv wordpress/* /var/www/html
echo "- configuring wordpress"
mv /tmp/config/wp-config.php /var/www/html/wp-config.php
echo "- change wordpress folder owner to nginx"
chown -R apache:apache /var/www/html

echo "========================================================="
echo "=============== MASTER SERVER IS INSTALLED =============="
echo "========================================================="
echo ". . . ."
echo ". . "
echo "."
