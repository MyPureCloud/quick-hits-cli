# >> START Add-DIDToIVR

<#
    .DESCRIPTION
        This script shows sample commands for adding/updating IVR DIDs.

        This file is not meant to be run as is, but contains PowerShell
        snippets you can use in your own scripts.

        PowerShell v5.1 and up
#>

# Array of numbers to assign to the IVR. 
# You always need to use an array, even if you're only going to assign one number.
$dnisArray = @('+13175559905')

# Before starting you need the IVR Id.
$ivrId = "f833e1cc-96a0-4db5-977d-4b942cdf7341"

# OR 
# if you only have the IVR name, you can get the ID by running this:
$ivrId = (gc.exe architect ivrs list --name "-- EXACT IVR NAME --" -a | 
    ConvertFrom-Json) | Select-Object -ExpandProperty id | Write-Output


# Assign DIDs to the IVR. 
# Note: This will replace the existing DID configuration from the IVR
gc.exe architect ivrs get $ivrId | ConvertFrom-Json |              # Get the current configuration of the IVR.  
    Select-Object * -ExcludeProperty dnis, version |    # Remove the dnis and version properties
    # Add the dnis phone numbers array as the dnis property
    Add-Member -PassThru `
               -MemberType NoteProperty `
               -Name dnis -Value $dnisArray |
    ConvertTo-Json -Depth 10 |
    gc.exe architect ivrs update $ivrId                            # Invoke the Genesys Cloud API to execute the changes

# >> END Add-DIDToIVR
