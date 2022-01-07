# >> START cli-queue-creation Examples for creating and migrating queues via the Genesys Cloud CLI

# Creates a queue based on whats passed in on standard in and then returns the queue id of the newly created queue.
echo '{"name": "chat4"}' | gc routing queues create | jq -r .id

######## 
#   Exports the queue definitions from one Genesys Cloud organization and creates them in another.  This will take all of the queues from the SOURCE_OAUTH_CLIENT and dump 
#   them to a file. In the process, it removes the id, division, selfUri, dateCreated fields from the JSON.  It then iterates through all of the files recreates the items in the 
#   DEST_OAUTH_CLIENT
#######

gc -p SOURCE_OAUTH_CLIENT routing queues list -a > queues.json                                                       # Dump all of the queues out of the target org into a file
cat queues.json |  jq 'map(del(.id, .division, .selfUri, .dateCreated, .createdBy))' > input.json          # Get rid of all of the ids and create dates and dump into another file
jq -cr 'keys[] as $k | "\($k)\n\(.[$k])"' input.json |                                                     # Shell command to split each record into a file
                        while read -r key ; do
                        read -r item
                        printf "%s\n" "$item" > "/tmp/queues-$key.json"
        done
ls /tmp/queues-*.json  | xargs -I{} gc -p DEST_OAUTH_CLIENT routing queues create -f {}                            # Take all the file names and use the cli to create the queue

# >> END cli-queue-creation