#!/bin/bash
# 
# 一键安装lvs-nat脚本，需要注意的是主机名成和ip的变化稍作修改就可以了 
HOSTNAME=`hostname`
  
Director='LVS'
VIP="192.168.1.200"
RIP1="172.16.100.10"
RIP2="172.16.100.11"
RealServer1="web1"
RealServer2="web2"
Httpd_config="/etc/httpd/conf/httpd.conf"
  
 #Director Server Install configure ipvsadm
if [ "$HOSTNAME" = "$Director" ];then
ipvsadm -C 
yum -y remove ipvsadm
yum -y install ipvsadm
/sbin/ipvsadm -A -t $VIP:80 -s rr
/sbin/ipvsadm -a -t $VIP:80 -r $RIP1 -m
/sbin/ipvsadm -a -t $VIP:80 -r $RIP2 -m
 echo 1 > /proc/sys/net/ipv4/ip_forward
 echo "========================================================" echo "Install  $Director sucess   Tel: 13826194409 Qq:1135189009" echo "========================================================" fi
  
  
  
 #RealServer Install htpd
if [ "$HOSTNAME" = "$RealServer1" ];then
yum -y remove httpd
rm -rf /var/www/html/index.html
yum -y install httpd
echo "web1 Allentuns.com" > /var/www/html/index.html
sed -i '/#ServerName www.example.com:80/a\ServerName localhost:80' $Httpd_config
service httpd start
  
 echo "========================================================" echo "Install $RealServer1 success Tel:13260071987 Qq:467754239" echo "========================================================" fi
 if [ "$HOSTNAME" = "$RealServer2" ];then
yum -y remove httpd
rm -rf /var/www/html/index.html
yum -y install httpd
echo "web2 Allentuns.com" > /var/www/html/index.html
sed -i '/#ServerName www.example.com:80/a\ServerName localhost:80' $Httpd_config
service httpd start
echo "Install $RealServer2"
  
 echo "=========================================================" echo "Install $RealServer1 success Tel:13260071987 Qq:467754239" echo "=========================================================" fi

lvs-nat-install

lvs-nat-install.sh
