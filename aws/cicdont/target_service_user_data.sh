#!/bin/bash

# Install GitLab
host_ip=$(curl -s checkip.amazonaws.com)
admin_token=$(openssl rand -hex 20)

apt update
apt-get install -y curl openssh-server ca-certificates tzdata perl docker.io jq awscli
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | bash
EXTERNAL_URL="http://$host_ip" GITLAB_ROOT_PASSWORD="${gitlab_root_password}" apt-get install gitlab-ee
gitlab-rails runner 'ApplicationSetting.last.update(signup_enabled: false)'
gitlab-rails runner "token = User.admins.last.personal_access_tokens.create(scopes: [:api], name: 'automation'); token.set_token('$admin_token'); token.save!"
sleep 2

## Install GitLab Runner
# Get Runner registration token (sleeps are to give it time to catch up)
runner_registration_token=""
while [[ $${#runner_registration_token} -ne 20 ]]
do
    runner_registration_token=$(curl -H "PRIVATE-TOKEN: $admin_token" -X POST "http://localhost:80/api/v4/runners/reset_registration_token" | jq -r '.token')
    sleep 4
done

# Register runner
docker run --rm --name gitlab-registration-runner -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner register --executor "docker" --url "http://172.17.0.1:80/" --registration-token "$runner_registration_token" --description "docker-runner" --docker-image "ubuntu:latest" --docker-volumes /var/run/docker.sock:/var/run/docker.sock --non-interactive

# Start runner
docker run -d --name gitlab-runner -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner


# GAMEMASTER 
# Ignore everything in the following block. This is for gameplay purposes
##########################################
mkdir /tmp/gamemaster
cd /tmp/gamemaster
aws s3 sync s3://${gamemaster_bucket} .
chmod +x /tmp/gamemaster/gamemaster.sh
/tmp/gamemaster/gamemaster.sh $admin_token
aws s3 rm s3://${gamemaster_bucket} --recursive
cd /
rm -rf /tmp/gamemaster
docker run --rm --name gitlab-registration-runner -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner register --executor "docker" --url "http://172.17.0.1:80/" --registration-token "$runner_registration_token" --description "docker-runner" --docker-image "ubuntu:latest" --docker-volumes /var/run/docker.sock:/var/run/docker.sock --non-interactive
##########################################