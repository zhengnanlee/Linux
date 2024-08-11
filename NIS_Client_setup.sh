#!/bin/bash

# 安装软件
yum -y install ypbind yp-tools

# 在网络中添加NIS域
nisdomain='lizhengnan'
echo -e "NISDOMAIN=$nisdomain\nYPSERV_ARGS="-p 1011"" >> /etc/sysconfig/network
nisdomainname $nisdomain	        # 临时生效命令

# 开机自动加入NIS域
echo "/bin/nisdomainname $nisdomain" >> /etc/rc.d/rc.local

# 设定主机名与 IP 的对应
echo -e "10.10.10.5\tCentos7-Server" >> /etc/hosts
echo -e "10.10.10.6\tCentos7-Client1" >> /etc/hosts
echo -e "10.10.10.7\tCentos7-Client2" >> /etc/hosts

# 用图形界面配置NIS
authconfig-tui
