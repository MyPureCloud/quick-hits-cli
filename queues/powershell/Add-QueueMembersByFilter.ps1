# >> START Add-QueueMembersByFilter A set of Genesys Cloud CLI commands the will identify a user by a specific filter and then add those users to a queue.

<#
    .DESCRIPTION
        Bulk assignment to queue by filter

        This files show the list of Genesys Cloud CLI commands needed for assigning a select number of users to a queue.
        In this example, users with a "Supervisor" role are selected but the script is meant to be modified to filter on whichever field desired.
        This file may not be a fully functional shell script, but rather a list of commands with a small shell script at the end to show to how to repeatedly
        call the GC queue commands to add a 100 users at a time to a queue.  

        Note: (Step 4) The 100 users at a time is a limitation on the routing API that restricts a dev from adding more then 100 users at a time.
        
        PowerShell v5.1 and up
#>

# Step #1:  Get a list of all of the users and apply filter.
#           IDs of the selected users will be saved to a file (newline-delimted)
#           In this example, users with a "Supervisor" role are selected
(gc.exe users list -a --expand="authorization" | ConvertFrom-Json) | 
    Where-Object {$_.authorization.roles.name -eq "Supervisor"} | 
    Select-Object -ExpandProperty id | 
    Out-File -FilePath .\authorizations-user.txt
 
# Step #2: Find the id of the target Queue and set it to a variable
(gc.exe routing queues list -a --name="Grocery_Queue" | ConvertFrom-Json) | 
    Select-Object -First 1 -ExpandProperty id |
    Set-Variable -Name "queueId"

# Step #3:  Find out the total number of users that were filtered
#           in Step 1 and assign to a variable. 
Get-Content ".\authorizations-user.txt" | Measure-Object -Line | 
    Select-Object -ExpandProperty Lines | 
    Set-Variable -Name "usersCount"

# Step 4: Process the users in batches of 100. This is due to the Routing API
#         having a set maximum of 100 users when bulk assigning to a queue.  
#         Ex: If we have 5791 users to add, there'd be 58 batches.
$batchSize = 100
$batchesCount = [int][Math]::Floor($usersCount / $batchSize) + 1

Get-Content -ReadCount $batchSize -Path ".\authorizations-user.txt" |
    ForEach-Object { $i = 1 } {
        Write-Host "Processing Batch ($i / $batchesCount)"

        # Build the JSON file with the user ids of this batch
        $_ | Select-Object @{Name="id"; Expression={$_}} | ConvertTo-Json |
            Out-File -FilePath ".\users_batch-$(($i)).json"

        # Invoke the gc cli to add the users from the JSON file
        gc.exe routing queues members move $queueId -f ".\users_batch-${i}.json"

        $i++    # Increment loop index
    } { Write-Host "Finished assigning users to Queue"}

# >> END Add-QueueMembersByRole
