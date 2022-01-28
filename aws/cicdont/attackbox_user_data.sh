#!/bin/bash
apt update
apt upgrade -y
useradd -m -p $(openssl passwd -1 ${player_password}) ${player_username}
usermod -aG sudo ${player_username}
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
systemctl restart sshd