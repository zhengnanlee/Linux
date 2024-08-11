#!/bin/bash

#设置yum源
mkdir -p /media/cdrom
mount /dev/sr0 /media/cdrom
echo "/dev/sr0                        /media/cdrom              iso9660  defaults        0 0"  >> /etc/fstab
#有/etc/yum.repos.d/CentOS-Media.repo 文件，无需再写repo文件  

rpm -ivh /media/cdrom/Packages/wget-1.14-18.el7_6.1.x86_64.rpm
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup 
wget -O /etc/yum.repos.d/CentOS-Base.repo  https://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache
yumi -y update
yum install -y vim zip unzip lrzsz epel-release


echo "PS1=\"\[\033[0;32m\]\A \[\033[0;31m\]\u\[\033[0;34m\]@\[\033[0;35m\]\h\[\033[0;34m\]:\[\033[00;36m\]\w\[\033[0;33m\] \n$\[\033[0m\]\"" >> /etc/profile
echo alias vi=\'vim\'>> /etc/profile
echo alias les=\'less -S\'  >> /etc/profile
echo alias ll=\'ls -alh\' >>/etc/profile
source /etc/profile
