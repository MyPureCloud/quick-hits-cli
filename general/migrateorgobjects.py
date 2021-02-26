## >> START migrate_objects An example of how create to migrate users by groups between two orgs

#!/usr/bin/python
import subprocess
import time
import sys


######################################################################################################
#  This is a simple example of how to use the Genesys Cloud CLI (v3.0+), JQ (1.6+) and Python 3      #
#  to wrapper the CLI to export Genesys Cloud objects from one org and move them into another        #
######################################################################################################
sourceOrg = sys.argv[1]
destOrg   = sys.argv[2]
timestr= time.strftime("%Y%m%d-%H%M%S")

print("Beginning Export")
actions = [["skills","--pageSize=100", ".id, .dateModified, .version, .selfUri"],
           ["groups", "--pageSize=100", ".id, .dateModified, .version, .memberCount,.chat,.owners,.selfUri"], 
           ["roles", "--pageSize=100", ".id, .dateModified, .version, .userCount,.selfUri"],
           ["queues","--pageSize=100", ".id, .division, .selfUri, .dateCreated, .createdBy"],
           ["locations","--pageSize=100", ".id, .division, .selfUri, .dateCreated, .createdBy"],
           ["users", '--pageSize=150 --expand="authorization, groups,skills,languages,geolocation,station,team,location"', ".id, .division, .selfUri, .dateCreated, .createdBy,.roles"]]

for action in actions:
  print("Exporting {} from {}".format(action[0], sourceOrg))
  cmd = "gc --profile {} {} list -a --pageSize=100 {} > export/{}-{}.json".format(sourceOrg, action[0], action[1],timestr,action[0])
  output,error = subprocess.Popen(['/bin/bash', '-c', cmd], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
  print(error)

for action in actions:
  print("Importing {} to {}".format(action[0], destOrg))
  cmd = '''
     cat export/{}-{}.json | jq 'map(del({}))'  |  jq -cr 'keys[] as $k | "\($k)\n\(.[$k])"' |
     while read -r key ; do  
       read -r item 
       echo $item | gc -p {} {} create 
     done
  '''.format(timestr, action[0],action[2],destOrg,action[0])
  output,error = subprocess.Popen(['/bin/bash', '-c', cmd], stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
  print(error)

