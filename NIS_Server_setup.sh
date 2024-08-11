#!/bin/bash
nisdomain='lizhengnan'
ip='10.10.10.0'

# 安装软件
yum -y install ypserv ypbind yp-tools
# 设定 NIS 的域名和固定端口
echo -e "NISDOMAIN=$nisdomain\nYPSERV_ARGS="-p 1011"" >> /etc/sysconfig/network
nisdomainname lizhengnani		# 临时生效命令
# 设置 yppasswdd 启动在固定的端口
sed -i 's/YPPASSWDD_ARGS=/YPPASSWDD_ARGS="--port  1012"/g' /etc/sysconfig/yppasswdd

# 开机自动加入NIS域
echo "/bin/nisdomainname $nisdomain" >> /etc/rc.d/rc.local

# 修改主要配置文件 /etc/ypserv.conf
echo "127.0.0.1/255.0.0.0        : *       : *                : none" >>/etc/ypserv.conf
echo "$ip/255.255.255.0   : *       : *                : none" >> /etc/ypserv.conf
echo "*                          : *       : *                : deny" >>/etc/ypserv.conf

# 设定主机名与 IP 的对应 (/etc/hosts, Server端和Client端都需修改,改进：登录局域网下所有主机，执行命令将IP和主机名输入到共享文件中，此处直接cp或cat 进/etc/hosts)
echo -e "10.10.10.5\tCentos7-Server" >> /etc/hosts
echo -e "10.10.10.6\tCentos7-Client1" >> /etc/hosts
echo -e "10.10.10.7\tCentos7-Client2" >> /etc/hosts

# 处理账号并建立数据库
groupadd -g 500 SGE
useradd -u 500  -g 500 -d /home/nishome/sgeadmin -s /bin/bash -c "SGE Admin" sgeadmin
echo lzn122614+ | passwd --stdin sgeadmin
useradd -u 1001 -m -d /home/nishome/lizhengnan lizhengnan 
echo lzn122614+ | passwd --stdin lizhengnan

# 建立数据库
/usr/lib64/yp/ypinit -m		# control+D,y

# 启动服务并设置开机启动
systemctl enable ypserv.service
systemctl enable yppasswdd.service
systemctl start ypserv.service
systemctl start yppasswdd.service