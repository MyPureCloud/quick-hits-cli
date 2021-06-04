# >> START Connect-NotificationsChannel Subscribe to notification events from the command line

<# 
    .DESCRIPTION
        Subscribe to notification events from the command line
        PowerShell v5.1 and up.
#>

####
# Step 1:  Create a channel
####
gc.exe notifications channels create |
    # (Optional) assign id to channelId variable
    ConvertFrom-Json |                  
    Select-Object -ExpandProperty id |
    Set-Variable -Name "channelId"

# Look at the output.  You will need the id value below to subscribe to the channel
<#
    {
        "connectUri": "wss://streaming.mypurecloud.com/channels/streaming-2-aa5h48uk0srhpugh2994klj918",
        "id": "streaming-2-aa5h48uk0srhpugh2994klj918",                                              
        "expires": "2021-02-03T17:59:07.650Z"
    }
#>

####
# Step 2: Create a subscription to a set of topics for the channel
####

Get-Content "subscriptions.json" | gc.exe notifications channels subscriptions subscribe $channelId
# channelId contains the if of the channel created in Step 1

#The content of the subscriptions.json is shown here
<#
    [{
        "id": "v2.analytics.queues.{QUEUE ID HERE}.observations"
    }]
#>

####
# Step 3: Listen to the channel for subscriptions.  
####

gc.exe notifications channels listen $channelId | 
    <# 
        The gc cli prints to standard output as events arrive.
        The ForEach below collects the line strings from the standard output 
        in order to build the complete JSON. Once it has the full event JSON,
        it will be forwarded to the next command in the pipeline by Write-Output
    #>
    ForEach-Object {$eventJson = ""} {
        if ($_ -ne "}") {
            $eventJson += $_
        } 
        else {
            $eventJson += "}"
            $eventJson | Write-Output
            $eventJson = ""
        }
    } | 
    # Loop through the JSON string objects and display the topicName and eventBody.
    ForEach-Object {
        $_ | ConvertFrom-Json | 
            Select-Object -Property topicName -ExcludeProperty eventBody -ExpandProperty eventBody
    }


# >> END Connect-NotificationsChannel
