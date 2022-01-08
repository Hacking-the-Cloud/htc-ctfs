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
# Create mark
curl -H "PRIVATE-TOKEN: token-string-here123" -X POST "http://localhost/api/v4/users?email=mark@cloud.local&username=mark&name=mark&force_random_password=true&skip_confirmation=true"
# Create carmen
curl -H "PRIVATE-TOKEN: token-string-here123" -X POST "http://localhost/api/v4/users?email=carmen@cloud.local&username=carmen&name=carmen&force_random_password=true&skip_confirmation=true"
# Create sam
curl -H "PRIVATE-TOKEN: token-string-here123" -X POST "http://localhost/api/v4/users?email=sam@cloud.local&username=sam&name=sam&force_random_password=true&skip_confirmation=true"
# Create louis
curl -H "PRIVATE-TOKEN: token-string-here123" -X POST "http://localhost/api/v4/users?email=louis@cloud.local&username=louis&name=louis&force_random_password=true&skip_confirmation=true"
# Create daniel
curl -H "PRIVATE-TOKEN: token-string-here123" -X POST "http://localhost/api/v4/users?email=daniel@cloud.local&username=daniel&name=daniel&force_random_password=true&skip_confirmation=true"

# Create ashley access token
gitlab-rails runner "token = User.find_by_username('ashley').personal_access_tokens.create(scopes: [:api], name: 'automation'); token.set_token('aaaaaaaaaaaaaaaaaaaa'); token.save!"

# Create chicken-docker project
curl -H "PRIVATE-TOKEN: aaaaaaaaaaaaaaaaaaaa" -X POST "http://localhost:80/api/v4/projects?name=chicken-docker&default_branch=main&initialize_with_readme=true"

# Get Runner registration token
runner_registration_token=$(curl -H "PRIVATE-TOKEN: aaaaaaaaaaaaaaaaaaaa" -X POST "http://localhost:80/api/v4/projects/2/runners/reset_registration_token" | jq -r '.token')

# Register runner
docker run --name gitlab-registration-runner -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner register --executor "docker" --docker-image ubuntu:latest --url "http://172.17.0.1:80/" --registration-token $runner_registration_token --description "docker-runner" --non-interactive

# Start runner
docker run -d --name gitlab-runner -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner

# Lore Stuff
curl -H "PRIVATE-TOKEN: token-string-here123" -X POST "http://localhost/api/v4/projects/2/members" --data "user_id=8&access_level=30"

# Create Player
curl -H "PRIVATE-TOKEN: token-string-here123" -X POST "http://localhost/api/v4/users?email=${player_username}@cloud.local&username=${player_username}&name=${player_username}&password=${gitlab_root_password}&skip_confirmation=true"
# Add player to target_project
curl -H "PRIVATE-TOKEN: token-string-here123" -X POST "http://localhost/api/v4/projects/2/members" --data "user_id=8&access_level=30"
echo token > /tmp/token

# Assign the issue to the player
curl -H "PRIVATE-TOKEN: token-string-here123" -X POST "http://localhost/api/v4/projects/2/issues?title=CI%2fCD%20Problem%20with%20Docker%20Container&assignee_id=8"

##########################################