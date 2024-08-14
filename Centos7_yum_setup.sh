#!/bin/bash

# 设置yum源
mkdir -p /media/cdrom
mount /dev/sr0 /media/cdrom
echo "/dev/sr0                        /media/cdrom              iso9660  defaults        0 0"  >> /etc/fstab
# 有/etc/yum.repos.d/CentOS-Media.repo 文件，无需再写repo文件

rpm -ivh /media/cdrom/Packages/wget-1.14-18.el7_6.1.x86_64.rpm
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo  https://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache
#yum -y update
