# nginx

installHome=$( pwd )

echo -e "\n\n\n\n\n"
echo -e "update yum..."
yum update -y
echo -e "\n\n\n\n\n"
echo -e "install git..."
yum install git -y
echo -e "\n\n\n\n\n"
echo -e "install wget..."
yum install wget -y
echo -e "\n\n\n\n\n"
echo -e "install nginx..."
yum -y install epel-release
yum install nginx -y

# php7.x
echo -e "\n\n\n\n\n"
echo -e "install php7.x..."
cd /home/centos
wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
rpm -ivh ./remi-release-7.rpm
yum install --enablerepo=remi,remi-php70 php-fpm php-devel php-mbstring php-pdo php-gd php-xml php-curl php-mysqlnd php-pdo_mysql php-mysqli php-json php-soap php-zip php-sockets php-session php-mcrypt php-date php-openssl php-yaml -y

# 將 nginx.conf 更新 php
echo -e "\n\n\n\n\n"
echo -e "update nginx.conf..."
cd env-install
cp -f $installHome/default_nginx.conf /etc/nginx/nginx.conf

# 建立 index.php
echo -e "\n\n\n\n\n"
echo -e "create index.php..."
echo "<?php phpinfo()?>" > /usr/share/nginx/html/index.php

# 取得 ini 的 dir
additional_ini=$( php --ini | grep additional | awk '{print $7}' )

# phalcon
echo -e "\n\n\n\n\n"
echo -e "Phalcon..."
cd /home/centos
yum install php-devel pcre-devel gcc make re2c -y
git clone https://github.com/phalcon/zephir
cd zephir/; ./install-nosudo ; cd bin/; zephir=$( pwd )/zephir
cd ..
git clone git://github.com/phalcon/cphalcon.git
cd cphalcon
git checkout 3.1.x
$zephir build
echo "extension=phalcon.so" > $additional_ini/30-phalcon.ini

# libmemcached
echo -e "\n\n\n\n\n"
echo -e "libmemcached..."
cd /home/centos
wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
tar xvf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18
yum groupinstall "Development Tools" -y
yum install zlib-static -y
./configure
make && make install

# memcached.so
echo -e "\n\n\n\n\n"
echo -e "memcached.so..."
cd /home/centos
git clone https://github.com/php-memcached-dev/php-memcached.git
cd php-memcached
git checkout php7
phpize
./configure --disable-memcached-sasl
make && make install
echo "extension=memcached.so" > $additional_ini/30-memcached.ini

# libmosquitto
echo -e "\n\n\n\n\n"
echo -e "libmosquitto..."
cd /home/centos
cp $installHome/mosquitto.repo /etc/yum.repos.d/
yum install libmosquitto-devel -y

# mosquitto.so
cd /home/centos
echo -e "\n\n\n\n\n"
echo -e "mosquitto.so..."
git clone https://github.com/mgdm/Mosquitto-PHP
cd Mosquitto-PHP
phpize
./configure --with-mosquitto=/usr/lib64/libmosquitto.so
make && make install
echo "extension=mosquitto.so" > $additional_ini/30-mosquitto.ini

#end
echo -e "\n\n\n\n\n\n\n"
/bin/systemctl restart nginx
/bin/systemctl restart php-fpm
echo "Finish...."
echo "install extension below : "
php -m | grep -e phalcon -e memcached -e mosquitto



