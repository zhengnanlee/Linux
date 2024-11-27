#!/bin/bash
sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf
# 本地ISO yum 源
if [ ! -d "/media/cdrom" ]
then
	mkdir -p /media/cdrom
fi

mount /dev/sr0 /media/cdrom
echo "/dev/sr0                        /media/cdrom              iso9660  defaults        0 0"  >> /etc/fstab

echo "[rhel7.7-yum]" > /etc/yum.repos.d/rhel7.7.repo
echo "name=rhel7.7-cd-package" >> /etc/yum.repos.d/rhel7.7.repo
echo "baseurl=file:///media/cdrom/" >> /etc/yum.repos.d/rhel7.7.repo
echo -e "enable=1\ngpgcheck=0" >> /etc/yum.repos.d/rhel7.7.repo

yum clean all
yum makecache

# 安装wget
#yum install wget
rpm -ivh /media/cdrom/Packages/wget*.rpm

# 清除旧 yum 版本
rpm -qa|grep yum|xargs rpm -e --nodeps
# 下载安装centos的yum文件,已下载到yum_packages文件夹下 
#wget https://mirrors.aliyun.com/centos/7/os/x86_64/Packages/python-iniparse-0.4-9.el7.noarch.rpm --no-check-certificate
#wget https://mirrors.aliyun.com/centos/7/os/x86_64/Packages/yum-3.4.3-168.el7.centos.noarch.rpm --no-check-certificate
#wget https://mirrors.aliyun.com/centos/7/os/x86_64/Packages/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm --no-check-certificate
#wget https://mirrors.aliyun.com/centos/7/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.31-54.el7_8.noarch.rpm  --no-check-certificate
cd ./yum_packages/
rpm -ivh *.rpm --force --nodeps
# 下载替换centos源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i 's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
sed -i 's/http/https/g' /etc/yum.repos.d/CentOS-Base.repo
# 清缓存
yum clean all
yum makecache
#yum list
#yum update -y

