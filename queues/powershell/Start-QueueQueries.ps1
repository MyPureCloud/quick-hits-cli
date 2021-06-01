# >> START Start-QueueQueries A set of Genesys Cloud CLI Queuries for queues

<#
    .DESCRIPTION
        A set of Genesys Cloud CLI Queuries for queues

        PowerShell v5.1 and up.
#>

# Query all of the queues, sort them by memberCount and name, pull the fields we want with JQ and the dump them out to a CSV file format (you can just dump the JSON), but it is not always usable.
(gc.exe routing queues list -a | ConvertFrom-Json) | 
    Select-Object id, name, memberCount |
    Sort-Object -Property @{Expression="memberCount"; Descending=$True}, name | 
    Export-Csv -Path ".\queue.csv" -NoTypeInformation

# Returns all the queues a user belongs to when you only know the user name and convert to CSV
(gc.exe users list -a | ConvertFrom-Json) |
    Where-Object username -eq "kokey@yekok.com" |
    Select-Object id -First 1 | 
    ForEach-Object { (gc.exe users queues list $_.id -a | ConvertFrom-Json) | Write-Output } | 
    Export-Csv -Path ".\queues_of_user.csv" -NoTypeInformation 

# Get a list of user (details) for a specific queue when you don't know the id of the queue.  Dump some of the information to a CSV
(gc.exe routing queues list -a | ConvertFrom-Json) | 
    Where-Object name -eq "Support" |
    Select-Object id | 
    ForEach-Object { 
        (gc.exe routing queues members list $_.id -a | ConvertFrom-Json) | 
            Select-Object @{Name="id"; Expression={$_.user.id}}, @{Name="username"; Expression={$_.user.username}} |  
            Export-Csv -Path ".\users_of_queue.csv" -NoTypeInformation
    } 

# >> END Start-QueueQueries
