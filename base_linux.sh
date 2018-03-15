#1 instal jdk , add tomcat user
sh init_jdk.sh

useradd tomcat
mkdir -p /usr/local/app/
chown -R tomcat.tomcat /usr/local/app

#2 # vim /etc/sudoers
echo "tomcat  ALL=(ALL)       ALL" >> /etc/sudoers

#3 set limits.conf
echo "*	soft nofile 65536" >>  /etc/security/limits.conf
echo "*	hard nofile 65536" >> /etc/security/limits.conf
ulimit -a



#4 kernel optimization
grep "net.ipv4.tcp_keepalive_time = 30" /etc/sysctl.conf
if [ $? != 0 ]
  then
cat > /etc/sysctl.conf<<EOF
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 1
net.core.somaxconn = 262144
net.core.netdev_max_backlog = 262144
net.ipv4.tcp_max_orphans = 262144
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 30
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.tcp_keepalive_intvl = 5
net.ipv4.tcp_timestamps = 0
EOF


sed -i 's/net.bridge.bridge-nf-call-ip6tables = 0/#net.bridge.bridge-nf-call-ip6tables = 0/g' /etc/sysctl.conf
sed -i 's/net.bridge.bridge-nf-call-iptables = 0/#net.bridge.bridge-nf-call-iptables = 0/g' /etc/sysctl.conf
sed -i 's/net.bridge.bridge-nf-call-arptables = 0/#net.bridge.bridge-nf-call-arptables = 0/g' /etc/sysctl.conf
fi

sysctl -p



#5 selinux disabled
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/id:5:initdefault:/id:3:initdefault:/g' /etc/inittab


#6 stop some services 
service iptables stop
sh stopservice.sh

#7 see the version
#less /etc/issue

#8 set 90-nproc
sed -i 's/*          soft    nproc     1024/#*          soft    nproc     1024/g'   /etc/security/limits.d/90-nproc.conf
sed -i 's/root       soft    nproc     unlimited/*       soft    nproc     unlimited/g'   /etc/security/limits.d/90-nproc.conf




#9 system basic lib package install
yum install gcc gcc-c++ ncurses-devel.x86_64 cmake.x86_64 libaio.x86_64 bison.x86_64 gcc-c++.x86_64 bind-utils wget curl curl-devel perl openssh-clients setuptool sysstat -y
yum search rz -y
yum install -y lrzsz.x86_64

#10 set shanghai time
cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock

#11 restart the linux server 
shutdown -r now



