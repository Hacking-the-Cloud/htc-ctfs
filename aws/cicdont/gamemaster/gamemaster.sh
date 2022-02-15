#!/bin/bash

# Question: What is this? 
# Answer: This is all the "behind the scenes" activities to create the NPCs, along with their comments and what not.
# If you've somehow found this script while playing the CTF you can safely ignore it. Or use it to your advantage, idk.

# Create ashley
ashley_id=$(curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=ashley@cloud.local&username=ashley&name=ashley&force_random_password=true&skip_confirmation=true" | jq -r '.id')
# Create mark
mark_id=$(curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=mark@cloud.local&username=mark&name=mark&force_random_password=true&skip_confirmation=true" | jq -r '.id')
# Create carmen
carmen_id=$(curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=carmen@cloud.local&username=carmen&name=carmen&force_random_password=true&skip_confirmation=true" | jq -r '.id')
# Create sam
sam_id=$(curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=sam@cloud.local&username=sam&name=sam&force_random_password=true&skip_confirmation=true" | jq -r '.id')
# Create louis
louis_id=$(curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=louis@cloud.local&username=louis&name=louis&force_random_password=true&skip_confirmation=true" | jq -r '.id')
# Create daniel
daniel_id=$(curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=daniel@cloud.local&username=daniel&name=daniel&force_random_password=true&skip_confirmation=true" | jq -r '.id')

# Create ashley access token
ashley_token=$(curl -X POST -H "PRIVATE-TOKEN: $1" --data "name=automation" --data "scopes[]=api" "http://localhost/api/v4/users/$ashley_id/personal_access_tokens" | jq -r '.token')
mark_token=$(curl -X POST -H "PRIVATE-TOKEN: $1" --data "name=markauto" --data "scopes[]=api" "http://localhost/api/v4/users/$mark_id/personal_access_tokens" | jq -r '.token')
carmen_token=$(curl -X POST -H "PRIVATE-TOKEN: $1" --data "name=carmenauto" --data "scopes[]=api" "http://localhost/api/v4/users/$carmen_id/personal_access_tokens" | jq -r '.token')
sam_token=$(curl -X POST -H "PRIVATE-TOKEN: $1" --data "name=samauto" --data "scopes[]=api" "http://localhost/api/v4/users/$sam_id/personal_access_tokens" | jq -r '.token')
louis_token=$(curl -X POST -H "PRIVATE-TOKEN: $1" --data "name=louisauto" --data "scopes[]=api" "http://localhost/api/v4/users/$louis_id/personal_access_tokens" | jq -r '.token')
daniel_token=$(curl -X POST -H "PRIVATE-TOKEN: $1" --data "name=danielauto" --data "scopes[]=api" "http://localhost/api/v4/users/$daniel_id/personal_access_tokens" | jq -r '.token')

# Create mvp-docker project
curl -H "PRIVATE-TOKEN: $ashley_token" -X POST "http://localhost:80/api/v4/projects?name=mvp-docker&default_branch=main&import_url=https%3A%2F%2Fgithub.com%2FFrichetten%2Fmvp-docker&visibility=internal"

## Lore Stuff

# Creating Ashley's Projects
curl -H "PRIVATE-TOKEN: $ashley_token" -X POST "http://localhost/api/v4/projects?name=hackingthe.cloud&default_branch=main&import_url=https%3A%2F%2Fgithub.com%2FHacking-the-Cloud%2Fhackingthe.cloud%2F&visibility=internal"

# Fix everyone's profile pictures
curl -X PUT --form "avatar=@/tmp/gamemaster/profile_pictures/ashley_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/$ashley_id
curl -X PUT --form "avatar=@/tmp/gamemaster/profile_pictures/mark_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/$mark_id
curl -X PUT --form "avatar=@/tmp/gamemaster/profile_pictures/carmen_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/$carmen_id
curl -X PUT --form "avatar=@/tmp/gamemaster/profile_pictures/sam_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/$sam_id
curl -X PUT --form "avatar=@/tmp/gamemaster/profile_pictures/louis_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/$louis_id
curl -X PUT --form "avatar=@/tmp/gamemaster/profile_pictures/daniel_50.jpg" -H "PRIVATE-TOKEN: $1" http://localhost/api/v4/users/$daniel_id

# Creating Daniel's projects
curl -H "PRIVATE-TOKEN: $daniel_token" -X POST "http://localhost/api/v4/projects?name=mkdocs-material&default_branch=master&import_url=https%3A%2F%2Fgithub.com%2Fsquidfunk%2Fmkdocs-material&visibility=internal"

# Daniel's comment
curl -H "PRIVATE-TOKEN: $daniel_token" -X POST "http://localhost/api/v4/projects/2/issues?title=Should%20we%20port%20this%20to%20Rust%3F&description=In%20Rust%20we%20Trust"

# Creating Sam's projects
curl -H "PRIVATE-TOKEN: $sam_token" -X POST "http://localhost/api/v4/projects?name=Dank-Learning&default_branch=master&import_url=https%3A%2F%2Fgithub.com%2Falpv95%2FDank-Learning&visibility=internal"

# Create Player
player_id=$(curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/users?email=${player_username}@cloud.local&username=${player_username}&name=${player_username}&password=${player_password}&skip_confirmation=true" | jq -r '.id')
# Add player to target_project
curl -H "PRIVATE-TOKEN: $1" -X POST "http://localhost/api/v4/projects/2/members" --data "user_id=$player_id&access_level=40"

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

# Create Mark's projects
curl -X POST -H "PRIVATE-TOKEN: $mark_token" "http://localhost/api/v4/projects?name=infra-deployer&visibility=internal"
cd /tmp
git clone http://oauth2:$mark_token@localhost/mark/infra-deployer
cd infra-deployer
git switch -c main
cp -r /tmp/gamemaster/infra-deployer/* .
git config user.name "mark"
git config user.email "mark@cloud.local"
git add *
git commit -m "Adding README"
git push origin main
cd /tmp
rm -rf /tmp/infra-deployer

# Add environment variables
curl -X POST -H "PRIVATE-TOKEN: $mark_token" "http://localhost/api/v4/projects/6/variables?key=access_key&value=${access_key}"
curl -X POST -H "PRIVATE-TOKEN: $mark_token" "http://localhost/api/v4/projects/6/variables?key=secret_key&value=${secret_key}"

# Assign the issue to the player
curl -H "PRIVATE-TOKEN: $ashley_token" -X POST "http://localhost/api/v4/projects/2/issues?title=CI%2fCD%20Problem%20with%20Docker%20Container&assignee_id=8&description=Hey%20${player_username}%2C%20when%20you%20get%20a%20chance%20can%20you%20take%20a%20look%20at%20our%20CI%2FCD%20config%20%28gitlab-ci.yml%29%3F%20Something%20is%20going%20on%20with%20it.%20I%20was%20trying%20to%20build%20our%20new%20Docker%20container%20but%20it%20wasn%27t%20working%20right.%20Thanks%21"
