# >> START Export-Queues Examples for creating and migrating queues via the Genesys Cloud CLI

<#
    .DESCRIPTION
        Examples for creating and migrating queues via the Genesys Cloud CLI

        PowerShell v5.1 and up.
#>

# Creates a queue based on whats passed in on standard in and then returns the queue id of the newly created queue.
Write-OutPut '{"name": "Barbie_Queue"}' | gc.exe routing queues create | ConvertFrom-Json | Select-Object id

######
#   Exports the queue definitions from one Genesys Cloud organization and creates them in another.  This will take all of the queues from the SOURCE_OAUTH_CLIENT and dump 
#   them to a file. In the process, it removes the id, division, selfUri, dateCreated fields from the JSON.  It then iterates through all of the files recreates the items in the 
#   DEST_OAUTH_CLIENT
######

gc.exe -p SOURCE_OAUTH_CLIENT routing queues list -a > queues.json                  # Dump all of the queues out of the target org into a file
(Get-Content -Path ".\queues.json" | ConvertFrom-Json) |            
    Select-Object * -ExcludeProperty id, division, selfUri, dateCreated |   # Remove unneeded properties
    ForEach-Object { $i = 0 } {                                             # Split each record into its own file
        $_ | ConvertTo-JSON -Depth 20 | 
            Out-File -FilePath ".\temp\queue-$(($i++)).json"
    }
Get-ChildItem -Path ".\temp\*" -Include queue-*.json -Name |                # Take all the file names and use the cli to create the queues
    ForEach-Object { gc.exe -p DEST_OAUTH_CLIENT routing queues create -f $_ }

# >> END Export-Queues
