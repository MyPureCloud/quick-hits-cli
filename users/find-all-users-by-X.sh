# >> START find-all-users-by-X A set of Genesys Cloud CLI commands the will identify a user by role, division, group or skill.

########
#  Example commands to search for all users by a role, division or group.
#######

# Get a list of all of the users with their authorization information
gc users list -a --pageSize=100 --expand="authorization" | jq -c '.[] | select( .authorization.roles[].name =="Supervisor")' | -r jq .id > authorizations-user.json
 
# Get a list of all users by role and convert the data to a csv file
gc users list -a --pageSize=100 --expand="authorization" | jq -c '.[] | select( .authorization.roles[].name =="Supervisor")' |jq -n '[inputs]'|  jq -r '. | map({"id": .id, "division": .division.name, "email": .email})' | jq -r '(.[0] | keys_unsorted) as $keys | ([$keys] + map([.[ $keys[] ]])) [] | @csv'

# Get a list of all of the user ids with their skill information with their skill information
gc users list -a --pageSize=100 --expand="skills" | jq -c '.[] |  select( .skills[].name == "AcdSkill9")' | jq -r .id > skills-user.json
 
# Get a list of all users by skill and convert the data to a csv file
gc users list -a --pageSize=100 --expand="skills" | jq -c '.[] |  select( .skills[].name == "AcdSkill9")' |jq -n '[inputs]'|  jq -r '. | map({"id": .id, "division": .division.name, "email": .email})' | jq -r '(.[0] | keys_unsorted) as $keys | ([$keys] + map([.[ $keys[] ]])) [] | @csv'

# Get a list of all of the user ids with their group information 
gc groups list |  jq -c '.[] | select (.name == "IRA")' | jq -r '. | .id'
gc users list -a --expand="groups" | jq -c '.[] | select( .groups[].id == "231f7f33-faea-41c7-a04f-a4fd47eefcad")' | jq . > groups.json
 
# Get a list of all users by group and convert the data to a csv file
gc groups list |  jq -c '.[] | select (.name == "IRA")' | jq -r '. | .id'
gc users list -a --expand="groups" | jq -c '.[] | select( .groups[].id == "231f7f33-faea-41c7-a04f-a4fd47eefcad")' | jq . | jq -n '[inputs]'|  jq -r '. | map({"id": .id, "division": .division.name, "email": .email})' | jq -r '(.[0] | keys_unsorted) as $keys | ([$keys] + map([.[ $keys[] ]])) [] | @csv'

# Get a list of all of the user ids with their division information with their skill information
gc users list -a --pageSize=100 | jq -c '.[] |  select( .division.name  == "DivisionA")' | jq -r .id > division-user.json
 
# Get a list of all users by division and convert the data to a csv file
gc users list -a --pageSize=100  | jq -c '.[] |  select(  .division.name  == "DivisionA")' |jq -n '[inputs]'|  jq -r '. | map({"id": .id, "division": .division.name, "email": .email})' | jq -r '(.[0] | keys_unsorted) as $keys | ([$keys] + map([.[ $keys[] ]])) [] | @csv'

# >> END find-all-users-by-X
