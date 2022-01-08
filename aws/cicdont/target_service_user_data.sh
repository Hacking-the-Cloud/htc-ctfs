#!/bin/bash
apt update
apt upgrade -y
useradd -m -s /bin/bash -p $(openssl passwd -1 nicknick) nick
usermod -aG sudo nick
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
systemctl restart sshd

# Install GitLab
apt-get install -y curl openssh-server ca-certificates tzdata perl docker.io jq
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | bash
host_ip=$(curl -s checkip.amazonaws.com)
EXTERNAL_URL="http://$host_ip" GITLAB_ROOT_PASSWORD="${gitlab_root_password}" apt-get install gitlab-ee
gitlab-rails runner 'ApplicationSetting.last.update(signup_enabled: false)'
gitlab-rails runner "token = User.admins.last.personal_access_tokens.create(scopes: [:api], name: 'automation'); token.set_token('token-string-here123'); token.save!"
echo "done" > /tmp/done

# Install GitLab Runner


# GAMEMASTER 
# Ignore everything in the following block
##########################################
# Create ashley
curl -H "PRIVATE-TOKEN: token-string-here123" -X POST "http://localhost/api/v4/users?email=ashley@cloud.local&username=ashley&name=ashley&force_random_password=true&skip_confirmation=true"

# Create ashley access token
gitlab-rails runner "token = User.find_by_username('ashley').personal_access_tokens.create(scopes: [:api], name: 'automation'); token.set_token('aaaaaaaaaaaaaaaaaaaa'); token.save!"

# Create chicken-docker project
curl -H "PRIVATE-TOKEN: aaaaaaaaaaaaaaaaaaaa" -X POST "http://localhost:80/api/v4/projects?name=chicken-docker"

# Get Runner registration token
runner_registration_token=$(curl -H "PRIVATE-TOKEN: aaaaaaaaaaaaaaaaaaaa" -X POST "http://localhost:80/api/v4/projects/2/runners/reset_registration_token" | jq -r '.token')
echo $runner_registration_token > /tmp/token

# Register runner
docker run --name gitlab-registration-runner -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner register --executor "docker" --docker-image ubuntu:latest --url "http://172.17.0.1:80/" --registration-token $runner_registration_token --description "docker-runner" --non-interactive

# Start runner
docker run -d --name gitlab-runner -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner

##########################################