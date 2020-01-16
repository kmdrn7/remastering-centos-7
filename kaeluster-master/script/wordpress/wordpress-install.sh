#!/bin/sh
echo "========================================================="
echo "========= INSTALLING WORDPRESS ON MASTER SERVER ========="
echo "========================================================="
echo ". . . ."
echo " . . . ."

echo "========================================================="
echo "#0 Preparing Environtment for Installing Wordpress ======"
echo "========================================================="
sleep 2s
echo "- installing unzip, yum-utils"
yum -y install unzip yum-utils
echo "- unzipping file configuration"
cd /tmp/config
unzip config.zip
echo "- removing old configutation zip file"
rm config.zip

echo "========================================================="
echo "#1 Installing HTTPD Web Server =========================="
echo "========================================================="
sleep 2s
echo "- adding public repository"
yum -y install epel-release
echo "- installing httpd"
yum -y install httpd

echo "========================================================="
echo "#2 Enabling HTTPD Web Server ============================"
echo "========================================================="
sleep 2s
systemctl start httpd
systemctl enable httpd
systemctl status httpd
echo "- add firewall rule for HTTP"
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

echo "========================================================="
echo "#3 Installing MariaDB ==================================="
echo "========================================================="
sleep 2s
cat <<EOT >> /etc/yum.repos.d/mariadb.repo
[mariadb]
name=MariaDB
baseurl=http://yum.mariadb.org/10.3/rhel7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOT
yum -y install mariadb-server mariadb
systemctl start mariadb
systemctl enable mariadb
echo "- change default mysql password to root"
mysqladmin -u root password 'root'
echo "- secure mariadb instalation"
mysql -u root -proot -e "delete from mysql.user where user=''"; # remove anonymous users
mysql -u root -proot -e "delete from mysql.user where user='root' and host not in ('localhost', '127.0.0.1', '::1')"; # remove all users except root
mysql -u root -proot -e "drop database if exists test"; # remove test database
mysql -u root -proot -e "delete from mysql.db WHERE db='test' or db='test\\_%'"; # remove all databases contains test_blablabla
mysql -u root -proot -e "flush privileges";

echo "========================================================="
echo "#4 Installing PHP 7 ====================================="
echo "========================================================="
sleep 2s
echo "- add php7 repository"
rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72
echo "- installing php plugin for wordpress"
yum -y install php php-mysql php-gd php-xml php-mbstring php-opcache php-devel php-pear php-bcmath

echo "========================================================="
echo "#5 Setup MySQL Database for Wordpress ==================="
echo "========================================================="
echo "- create user and database for wordpress"
mysql -u root -proot < /tmp/config/setup.sql

echo "========================================================="
echo "#6 Installing Latest Wordpress Instalation =============="
echo "========================================================="
cd /tmp/config
echo "- extracting wordpress instalation files"
tar -zxvf wp.tar.gz
echo "- copying wordpress to nginx public folder"
mv wordpress/* /var/www/html
echo "- configuring wordpress"
mv /tmp/config/wp-config.php /var/www/html/wp-config.php
mv /tmp/config/httpd.conf /etc/httpd/conf/httpd.conf
systemctl stop httpd
systemctl start httpd
cat <<EOL >> /var/www/html/.htaccess
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
EOL
echo "- change wordpress folder owner to httpd apache"
chown -R apache:apache /var/www/html
chcon -t httpd_sys_content_t -R /var/www/html
chcon -t httpd_sys_rw_content_t -R /var/www/html/wp-content

echo "========================================================="
echo "#7 Remove all unnecessary files ========================="
echo "========================================================="
yum -y remove unzip
rm -rf /tmp/config

echo "========================================================="
echo "=============== MASTER SERVER IS INSTALLED =============="
echo "========================================================="
echo ". . . ."
echo ". . "
echo "."
