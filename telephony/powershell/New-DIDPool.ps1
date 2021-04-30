# >> START New-DIDPool

<#
    .DESCRIPTION
        This file shows sample commands for creating new DID pools.
    
        PowerShell v5.1 and up
#>

# Create a DID pool. In this sample, the request body is defined in the script.
# (If you a JSON file for the body, use the next script instead)

Write-Output @{
    description = "Twilio"              # Description will show up under the 'Service Provider' column in Genesys Cloud UI
    comments = "DIDs for call flows."   # Additional comments
    startPhoneNumber = "+13175550000"   # Starting phone number for the range. Must be in E-164 format 
    endPhoneNumber = "13175550099"      # Ending phone number for the range. Must be in E-164 format
} | ConvertTo-Json |
    gc.exe edges didpools create        # gc cli command to create the DID pool


# Create a DID pool from a pre-defined JSON file.
# For this method, you should have a JSON file prepared with the following format:
<#
    {
        "description": "Twilio",
        "comments": "DIDs for call flows",
        "startPhoneNumber": "+13175559900",
        "endPhoneNumber": "13175559910"
    }
#>
Get-Content "new-did-pool.json" | gc.exe edges didpools create

# >> END New-DIDPool
