#!/usr/bin/env python3
# >> START delete-unused-webrtc Determine unused WebRTC phones and delete them

"""
This script provides an example on how to migrate phones from one site to another

Python(3.6+)
Genesys Cloud CLI (v13.0.0+)
JQ (v1.6+) 
"""
import subprocess
import json


def _execute(cmd, input=None):
    """Simple wrapper around the shell call.  Execute the passed in command, check for error and return the results"""
    result = subprocess.run(cmd, shell=True, text=True, input=input, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result.check_returncode()  # Automatically raises an error if there is any in the subprocess execution
    print(result.stdout)
    return json.loads(result.stdout)

def change_phone_site(phone, new_site_id):
    """Edit a Phone with the id parameter"""
    phone['site']['id'] = new_site_id
    with open('phone.json', 'w') as outfile:
        json.dump(phone, outfile)
    migrated_phone = _execute(f"gc telephony providers edges phones update {phone['id']} -f phone.json")
    print(f"Migrated Phone: {phone['id']}")


def migrate_phone_sites(old_site_id, new_site_id):
    """Migrate all phones from old site to new site"""
    
    # Query all Phones
    phones = _execute('gc telephony providers edges phones list -a --expand lines')

    print(f"There are {len(phones)} phones in the old site.")

    if len(phones) > 0:
        print('Starting migration of phones...')
        for phone in phones:
            if phone['site']['id'] == old_site_id:
                change_phone_site(phone, new_site_id)
        print('Successfully migrated all phones.')
    else:
        print('No phones to migrate.')


def main():
    old_site_id = input("Old site id: ")
    new_site_id = input("New site id: ")
    migrate_phone_sites(old_site_id, new_site_id)


if __name__ == "__main__":
    main()

# >> END migrate_phone_sites
