# >> START cli-assign-to-queue-by-role A set of Genesys Cloud CLI commands the will identify a user by role and then add those users to a queue.

#######
#   Bulk assignment to queue by role
#  
#  This files show the list of Genesys Cloud CLI commands needed to find all the users belonging to a particular role and move those users to a queue.
#  This file is not a fully functional shell script, but rather a list of commands with a small shell script at the end to show to how to repeatedly
#  call the GC queue commands to add a 100 users at a time to a queue.  
#
#  Note: The 100 users at a time is a limitation on the routing API that restricts a dev from adding more then 100 users at a time.
######

# Step #1:   Get a list of all of the users with their authorization information
gc users list -a --pageSize=100 --expand="authorization" | jq -c '.[] | select( .authorization.roles[].name | contains("Supervisor"))' | jq .id > authorizations-user.json
 
# Step #2: Find the id of the Queue by retrieving all of the queues and using jq to parse the id of the file
gc routing queues list -a --pageSize=100 --name="MyQueueName" | jq -r .[].id

# Step #3:  Find out the total number of users with that division
cat authorizations-user.json | jq .[].id | wc -l

# Step 4: You are going to iterate the total number of users/100 by 100.  If we have 5791 users that belong to a role, you are going to iterate 58 times.
for i in {0..58}
do
   userIndex=$i*100
   userFinal=$userIndex+100
   echo "----"
   echo "Index ${i} StartIndex: ${userIndex} and stop index ${userFinal}"

   # Chunk out 100 records from the divisions-user.json file and create a set of files by batch to create the users. 
   cat authorizations-user.json | jq -r ".[$userIndex:$userFinal] | map({id: .id, username: .username, joined    : true})" > /tmp/joinedUsers-${i}.json

   # Add the users with the command below.  If you want to delete these users instead of adding them pass in the --delete=true flag
   gc routing queues members move QUEUE_ID_HERE -f /tmp/joinedUsers-${i}.json
done
# >> END cli-assign-to-queue-by-role
