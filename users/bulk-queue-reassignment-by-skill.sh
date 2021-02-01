# >> START cli-reassign-by-skill The code below identifies users by skill and joins them to a queue
# Get users with skill information
gc users list --pageSize=100 --expand="skills" > users.json

# Get queue ID
gc queues list --pageSize=100 --name="MyQueueName" | jq -r .[].id
cat users.json | jq -c '.[] | select( .skills[].name | contains("MySkillName"))' | jq -n  '[inputs]'| jq > skills-user.json
cat skills-user.json | jq .id | wc -l

# Iterate users
for i in {0..58}
do
   userIndex=$i*100
   userFinal=$userIndex+100
   echo "----"
   echo "Index ${i} StartIndex: ${userIndex} and stop index ${userFinal}"
   cat skills-user.json | jq -r ".[$userIndex:$userFinal] | map({id: .id, username: .username, joined    : true})" > /tmp/joinedUsers-${i}.json
   gc queues users move bcda7b20-3197-12a9-8332-5b4f774493cb -f /tmp/joinedUsers-${i}.json
done
# >> END cli-reassign-by-skill
