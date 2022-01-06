#!/bin/bash
apt update
apt upgrade -y
useradd -m -p $(openssl passwd -1 nicknick) nick
usermod -aG sudo nick
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
systemctl restart sshd