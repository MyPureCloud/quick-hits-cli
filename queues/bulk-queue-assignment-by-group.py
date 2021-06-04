# >> START queue_migrator An example of how create to migrate users by groups between two orgs

#!/usr/bin/python
import subprocess
import sys
import math

groupName = sys.argv[1]
srcQueue = sys.argv[2]
destQueue   = sys.argv[3]

#########################################################################################################################################
#                                                                                                                                       #  
#  This script provide a simple example of how to wrapper the Genesys Cloud CLI (v3.0.0+), JQ (v1.6+) and Python to demonstrate how     #
#  to perform move a users belonging to a group from one queue to another queue.                                                        #
#                                                                                                                                       #        
#########################################################################################################################################
 
# Simple wrapper around the shell call.  Execute the passed in command, check for error and return the results 
def execute(cmd):
  results, error = subprocess.Popen(['/bin/bash', '-c', cmd], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
  if  error !="":
    print("Error encounter: {} when executing cmd: {}".format(error, cmd))
    sys.exit(1)

  return results  

# Look an the id of an object based on a name
def getId(gcObject,name):
  id=execute( ''' gc {} list -a --pageSize=100 | jq -rc '.[] | select(.name == "{}") | .id' '''.format(gcObject,name))
  return id.rstrip("\n")

# Move the users to the target queue and remove them off their old queue
def moveUsersQueue(userIndex,userFinal,queueId,deleteUsers):
   mapCmd = '{id: .id, username: .username, joined : true}'
   if deleteUsers==True:
     return execute(''' cat export/users_in_group.json |  jq -r ".[{}:{}] | map({})" |  gc routing queues members move --delete=true {} '''.format(userIndex,userFinal,mapCmd,queueId))
   else:
     return execute(''' cat export/users_in_group.json |  jq -r ".[{}:{}] | map({})" |  gc routing queues members move {} '''.format(userIndex,userFinal,mapCmd,queueId))
  
# Start of main  
groupId = getId("groups",groupName) 
srcQueueId = getId("routing queues",srcQueue) 
destQueueId = getId("routing queues",destQueue) 

#Find all the members in that group and dump them to a file
results = execute(''' gc groups members list -a --pageSize=100 {}  > export/users_in_group.json '''.format(groupId))
 
# #Get the number of records in file.
count = execute(''' cat export/users_in_group.json | jq .[].id | wc -l ''')
count = int(count.rstrip("\n"))

# Execute the move of users to a new queue and then delete the users afterword.  Note:  There is a lag on the updateof the memberCount field
# Member counts on a queue happen asynchronously via our assignment service so the member counts for a large queue will have a lag time 
# on the member count field. 
print("Beginning migration....")
if count<101:
  moveUsersQueue(0,count,destQueueId,False)
  moveUsersQueue(0,count,srcQueueId,True)
else:
  for x in range(0, (count/100)+1):
    userIndex=x*100
    userFinal=userIndex+100
    print("Migrating batch number: {}".format(x))
    moveUsersQueue(userIndex,userFinal,destQueueId,False)
    moveUsersQueue(userIndex,userFinal,srcQueueId,True)

# >> END queue migrator
