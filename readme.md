# flow

0. tar cvf env-install.tar env-install/
1. Launch AWS ECW Centos7
2. scp -i xxx.pem env-install.tar centos@xxx.xxx.xxx.xxx:/home/centos
3. sch -i xxx.pem  centos@xxx.xxx.xxx.xxx
4. tar xvf env-install.tar
5. cd env-install/
6. sh env.sh

# install

1. nginx
2. php 7.0.15
3. phalcon.so
4. memcached.so
5. mosquitto.so


# check
1. php -m | grep -e phalcon -e memcached -e mosquitto
2. go to browser and open the web-site with the ec2 ip