# >> START cli-queue-queries A set of Genesys Cloud CLI Queuries for queues

#Query all of the queues, sort them by memberCount and name, pull the fields we want with JQ and the dump them out to a CSV file format (you can just dump the JSON), but it is not always usable.
gc routing queues list -a --pageSize 100 | jq -r '. | sort_by(.memberCount,.name)| reverse' | jq -r '. | map({id: .id, name: .name, membercount: .memberCount})' | jq -r '(.[0] | keys_unsorted) as $keys | ([$keys] + map([.[ $keys[] ]])) [] | @csv' 

#Returns all the queues a user belongs to when you only know the user name and convert to CSV
gc users list -a | jq -c '.[] | select( .username | contains("user24927@testme.test"))' |jq -r '. | .id' | xargs -I{} gc users queues list {} | jq -r '(.[0] | keys_unsorted) as $keys | ([$keys] + map([.[ $keys[] ]])) [] | @csv'

#Get a list of user (details) for a specific queue when you don't know the id of the queue.  Dump some of the information to a CSV
gc routing queues list -a |jq -c '.[] | select( .name | contains("jcc-chat6"))' | jq -r '. | .id' | xargs -I{} gc routing queues users get {} |jq -n '[inputs]'| jq -r '.[] | map({"id": .user.id, "username": .user.username})' | jq -r '(.[0] | keys_unsorted) as $keys | ([$keys] + map([.[ $keys[] ]])) [] | @csv'

# >> END cli-queue-queries
