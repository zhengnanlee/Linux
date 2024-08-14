#!/bin/bash
NFS_Server_IP=10.10.10.5
share_dirs="/home/nishome   /NFS/SGE   /NFS/Data  /NFS/Software"

# 1.1安装软件
yum install -y nfs-utils rpcbind
# 1.2开机启动rpc服务
systemctl enable rpcbind.service
systemctl start rpcbind.service
# 1.3开启nfs服务
systemctl enable nfs
systemctl start nfs

# 2.关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service
sed -i 's/SELINUX=enforcing/SELINUX=disable/g' /etc/selinux/config

# 3.Client 端自动挂载-->autofs 自动挂载
# 3.1
yum -y install autofs
# 3.2
echo -e "/home\t/etc/auto.nishome" >>/etc/auto.master		# nishome
echo -e "nishome\t\t-fstype=nfs\t\t$NFS_Server_IP:/home/nishome">>/etc/auto.nishome
# 3.3 
mkdir /NFS
echo "/NFS	/etc/auto.nfs" >>/etc/auto.master
if [ -f /etc/auto.nfs ]
then
	rm /etc/auto.nfs
fi
for dir in  `echo $share_dirs |sed 's#/home/nishome ##g'`
do
	base_dir=`echo $dir |sed s#/NFS/##g`
	echo -e "$base_dir\t\t-fstype=nfs\t\t$NFS_Server_IP:$dir" >> /etc/auto.nfs
done

# 3.4启动autofs服务
systemctl start autofs
systemctl enable autofs

# 3.5  修改自动卸载时间
sed -i 's/#OPTIONS=""/OPTIONS="--timeout=43200"/g' /etc/sysconfig/autofs
systemctl restart autofs
