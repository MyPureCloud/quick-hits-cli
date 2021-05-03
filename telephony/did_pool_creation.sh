# >> START create-did-pool A set of Genesys Cloud CLI commands that will create a new DID pool

# Create a DID pool from a pre-defined JSON file.
# You should have a JSON file prepared with the following format:
#
#  {
#    "description": "Service Provider X",   # Description will show up under the 'Service Provider' column in Genesys Cloud UI
#    "comments": "DIDs for call flows",     # Additional comments
#    "startPhoneNumber": "+13175550000",    # Starting phone number for the range. Must be in E-164 format 
#    "endPhoneNumber": "+13175550099"       # Ending phone number for the range. Must be in E-164 format
#  }
# 

gc edges didpools create -f new-did-pool.json


# >> END create-did-pool
