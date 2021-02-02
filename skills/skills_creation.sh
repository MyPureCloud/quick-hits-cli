# >> START cli-skill-creation Examples of creating Skills with the CLI


######## 
#   Exports the skilles definitions from one Genesys Cloud organization and re-creates them in another.  This will take all of the queues from the SOURCE_OAUTH_CLIENT and dump 
#   them to a file. In the process, it removes the id, dateModified, version, selfUri fields from the JSON.  It then iterates through all of the files and recreates the skills in the 
#   DEST_OAUTH_CLIENT
#######

gc --p SOURCE_OAUTH_CLIENT skills list > skills.json                                           # Dump all of the queues out of the target org into a file
cat skills.json |  jq 'map(del(.id, .dateModified, .version, .selfUri))' > input.json          # Get rid of all of the ids and create dates and dump into another file
jq -cr 'keys[] as $k | "\($k)\n\(.[$k])"' input.json |                                         # Shell command to split each record into a file
                        while read -r key ; do
                        read -r item
                        printf "%s\n" "$item" > "/tmp/skills/skills-$key.json"
        done
ls /tmp/skills-*.json  | xargs -I{} gc -p DEST_OAUTH_CLIENT skills create -f {}                # Take all the file names and use the cli to create the queue

# >> END cli-skill-creation