# >> START delete-unused-webrtc Determine unused WebRTC phones and delete them

"""
This script provides an example on how to delete WebRTC phones that are not assigned to any users or assigned previously 
to users which are now inactive or deleted.

Python(3.6+)
Genesys Cloud CLI (v13.0.0+)
JQ (v1.6+) 
"""
import subprocess
import sys


def _execute(cmd, input=None):
    """Simple wrapper around the shell call.  Execute the passed in command, check for error and return the results"""
    result = subprocess.run(cmd, shell=True, text=True, input=input, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    result.check_returncode()  # Automatically raises an error if there is any in the subprocess execution

    return result.stdout


def delete_phone(id):
    """Delete a WebRTC Phone with the id parameter"""
    deleted_webrtc = _execute(f"gc telephony providers edges phones delete {id}")
    print(f"Deleted WebRTC Phone: {id}")


def delete_unused_webrtc_phones():
    """Delete all of the unassigned WebRTC Phones in the Genesys Cloud org"""
    
    # Query all Phones
    phones = _execute('gc telephony providers edges phones list -a --fields webRtcUser')
    # Perform JSON transformations using JQ
    unused_webrtc_ids_str = _execute(
        'jq -r ".[] | select(.phoneMetaBase.id == \\"inin_webrtc_softphone.json\\") | select(has(\\"webRtcUser\\") | not) | .id"',
        phones)

    unused_webrtc_ids = unused_webrtc_ids_str.split('\n')
    # Remove the last element which is an empty string. (JQ has an added empty line in its output)
    unused_webrtc_ids.pop()

    print(f"There are {len(unused_webrtc_ids)} WebRTC phones with no active users assigned.")

    if len(unused_webrtc_ids) > 0:
        print('Starting deletion of phones...')
        for phone_id in unused_webrtc_ids:
            delete_phone(phone_id)
        print('Successfully deleted all unused WebRTC phones.')
    else:
        print('No phones to delete.')


def main():
    delete_unused_webrtc_phones()


if __name__ == "__main__":
    main()

# >> END delete-unused-webrtc
