#!/bin/bash

# Question: What is this? 
# Answer: This is all the "behind the scenes" activities to create the NPCs, along with their comments and what not.
# If you've somehow found this script while playing the CTF you can safely ignore it. Or use it to your advantage, idk.

ashley_token=$(openssl rand -hex 20)
daniel_token=$(openssl rand -hex 20)
sam_token=$(openssl rand -hex 20)
mark_token=$(openssl rand -hex 20)
carmen_token=$(openssl rand -hex 20)
louis_token=$(openssl rand -hex 20)

# Create ashley
curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=ashley@cloud.local&username=ashley&name=ashley&force_random_password=true&skip_confirmation=true"
# Create mark
curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=mark@cloud.local&username=mark&name=mark&force_random_password=true&skip_confirmation=true"
# Create carmen
curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=carmen@cloud.local&username=carmen&name=carmen&force_random_password=true&skip_confirmation=true"
# Create sam
curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=sam@cloud.local&username=sam&name=sam&force_random_password=true&skip_confirmation=true"
# Create louis
curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=louis@cloud.local&username=louis&name=louis&force_random_password=true&skip_confirmation=true"
# Create daniel
curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=daniel@cloud.local&username=daniel&name=daniel&force_random_password=true&skip_confirmation=true"

# Create ashley access token
gitlab-rails runner "token = User.find_by_username('ashley').personal_access_tokens.create(scopes: [:api], name: 'automation'); token.set_token('$ashley_token'); token.save!"
gitlab-rails runner "token = User.find_by_username('daniel').personal_access_tokens.create(scopes: [:api], name: 'danielauto'); token.set_token('$daniel_token'); token.save!"
gitlab-rails runner "token = User.find_by_username('sam').personal_access_tokens.create(scopes: [:api], name: 'samauto'); token.set_token('$sam_token'); token.save!"
gitlab-rails runner "token = User.find_by_username('mark').personal_access_tokens.create(scopes: [:api], name: 'markauto'); token.set_token('$mark_token'); token.save!"
gitlab-rails runner "token = User.find_by_username('carmen').personal_access_tokens.create(scopes: [:api], name: 'carmenauto'); token.set_token('$carmen_token'); token.save!"
gitlab-rails runner "token = User.find_by_username('louis').personal_access_tokens.create(scopes: [:api], name: 'louisauto'); token.set_token('$louis_token'); token.save!"

# Create mvp-docker project
curl -H "PRIVATE-TOKEN: $ashley_token" -X POST "http://localhost:80/api/v4/projects?name=mvp-docker&default_branch=main&import_url=https%3A%2F%2Fgithub.com%2FFrichetten%2Fmvp-docker&visibility=internal"

## Lore Stuff

# Creating Ashley's Projects
curl -H "PRIVATE-TOKEN: $ashley_token" -X POST "http://localhost/api/v4/projects?name=hackingthe.cloud&default_branch=main&import_url=https%3A%2F%2Fgithub.com%2FHacking-the-Cloud%2Fhackingthe.cloud%2F&visibility=internal"

# Fix everyone's profile pictures
cd /tmp
git clone http://oauth-token:$ashley_token@localhost/ashley/mvp-docker
curl -X PUT --form "avatar=@/tmp/mvp-docker/pics/ashley_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/2
curl -X PUT --form "avatar=@/tmp/mvp-docker/pics/mark_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/3
curl -X PUT --form "avatar=@/tmp/mvp-docker/pics/carmen_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/4
curl -X PUT --form "avatar=@/tmp/mvp-docker/pics/sam_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/5
curl -X PUT --form "avatar=@/tmp/mvp-docker/pics/louis_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/6
curl -X PUT --form "avatar=@/tmp/mvp-docker/pics/daniel_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/7
rm -rf /tmp/mvp-docker


# Creating Daniel's projects
curl -H "PRIVATE-TOKEN: $daniel_token" -X POST "http://localhost/api/v4/projects?name=mkdocs-material&default_branch=master&import_url=https%3A%2F%2Fgithub.com%2Fsquidfunk%2Fmkdocs-material&visibility=internal"

# Daniel's comment
curl -H "PRIVATE-TOKEN: $daniel_token" -X POST "http://localhost/api/v4/projects/2/issues?title=Should%20we%20port%20this%20to%20Rust%3F&description=In%20Rust%20we%20Trust"

# Creating Sam's projects
curl -H "PRIVATE-TOKEN: $sam_token" -X POST "http://localhost/api/v4/projects?name=Dank-Learning&default_branch=master&import_url=https%3A%2F%2Fgithub.com%2Falpv95%2FDank-Learning&visibility=internal"

# Create Player
curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=${player_username}@cloud.local&username=${player_username}&name=${player_username}&password=${gitlab_root_password}&skip_confirmation=true"
# Add player to target_project
curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/projects/2/members" --data "user_id=8&access_level=40"

# Adding Ashley's Joke Comment
curl -H "PRIVATE-TOKEN: $ashley_token" -X POST "http://localhost/api/v4/projects/2/issues/1/notes?body=No."
# Daniel's response
curl -X POST -H "PRIVATE-TOKEN: $daniel_token" "http://localhost/api/v4/projects/2/issues/1/notes?body=Oh%20come%20on%21%20Rust%20is%20great%21"
# Sam's response
curl -H "PRIVATE-TOKEN: $sam_token" -X POST "http://localhost/api/v4/projects/2/issues/1/notes?body=No."
# Daniel's response
curl -X POST -H "PRIVATE-TOKEN: $daniel_token" "http://localhost/api/v4/projects/2/issues/1/notes?body=But%20Crates%21"
# Mark's response
curl -X POST -H "PRIVATE-TOKEN: $mark_token" "http://localhost/api/v4/projects/2/issues/1/notes?body=No."
# Daniel's response
curl -X POST -H "PRIVATE-TOKEN: $daniel_token" "http://localhost/api/v4/projects/2/issues/1/notes?body=Strong%20memory%20management%21"
# Carmen's response
curl -X POST -H "PRIVATE-TOKEN: $carmen_token" "http://localhost/api/v4/projects/2/issues/1/notes?body=No."
# Daniel's response
curl -X POST -H "PRIVATE-TOKEN: $daniel_token" "http://localhost/api/v4/projects/2/issues/1/notes?body=The%20ecosystem%21"
# Louis' response
curl -X POST -H "PRIVATE-TOKEN: $louis_token" "http://localhost/api/v4/projects/2/issues/1/notes?body=No."

# Assign the issue to the player
curl -H "PRIVATE-TOKEN: $ashley_token" -X POST "http://localhost/api/v4/projects/2/issues?title=CI%2fCD%20Problem%20with%20Docker%20Container&assignee_id=8&description=Hey%20${player_username}%2C%20when%20you%20get%20a%20chance%20can%20you%20take%20a%20look%20at%20our%20CI%2FCD%20config%20%28gitlab-ci.yml%29%3F%20Something%20is%20going%20on%20with%20it.%20I%20was%20trying%20to%20build%20our%20new%20Docker%20container%20but%20it%20wasn%27t%20working%20right.%20Thanks%21"
echo blah > /tmp/done