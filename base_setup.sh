#!/bin/bash

yum install -y vim zip unzip lrzsz epel-release

# 设置时区
#timedatectl set-timezone Asia/Shanghai

echo "PS1=\"\[\033[0;32m\]\A \[\033[0;31m\]\u\[\033[0;34m\]@\[\033[0;35m\]\h\[\033[0;34m\]:\[\033[00;36m\]\w\[\033[0;33m\] \n$\[\033[0m\]\"" >> /etc/profile
echo alias vi=\'vim\'>> /etc/profile
echo alias les=\'less -S\'  >> /etc/profile
echo alias ll=\'ls -alh\' >>/etc/profile
source /etc/profile
