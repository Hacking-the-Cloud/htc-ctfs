#!/bin/bash
useradd -m -s /bin/bash -p $(openssl passwd -1 ${player_password}) ${player_username}
usermod -aG sudo ${player_username}
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
systemctl restart sshd

## Update some stuff
apt update
apt upgrade -y
apt install -y awscli