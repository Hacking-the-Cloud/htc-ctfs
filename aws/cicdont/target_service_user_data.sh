#!/bin/bash
apt update
apt upgrade -y
useradd -m -p $(openssl passwd -1 nicknick) nick
usermod -aG sudo nick
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
systemctl restart sshd

# Install GitLab
apt-get install -y curl openssh-server ca-certificates tzdata perl
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | bash
host_ip=$(curl -s checkip.amazonaws.com)
EXTERNAL_URL="http://$host_ip" GITLAB_ROOT_PASSWORD="nicknick" apt-get install gitlab-ee