#!/bin/bash

# 1.创建共享目录
share_dirs="/home/nishome   /NFS/SGE   /NFS/Data  /NFS/Software"
for dir in $share_dirs
do
	if [ ! -d "$dir"  ]
	then
		mkdir -p "$dir"
	fi
done

# 2.安装软件
yum install -y nfs-utils rpcbind
systemctl enable rpcbind.service
systemctl start rpcbind.service

ip="10.10.10.0"
rm /etc/exports
for dir in $share_dirs
do
	echo "$dir $ip/24(rw,no_root_squash,sync)" >>/etc/exports
done
# 开启nfs服务
systemctl enable nfs
systemctl start nfs

# 重新挂载一次
exportfs -arv
