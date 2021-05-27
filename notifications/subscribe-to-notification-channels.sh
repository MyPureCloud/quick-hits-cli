# >> START subscribe_to_notification_events Subscribe to notification events from the command line

 # Step 1:  Create a channel
 echo "" | gc notifications channels create 

# Look at the output.  You will need the id value below to subscribe to the channel
{
  "connectUri": "wss://streaming.mypurecloud.com/channels/streaming-2-aa5h48uk0srhpugh2994klj918",
  "id": "streaming-2-aa5h48uk0srhpugh2994klj918",                                              
  "expires": "2021-02-03T17:59:07.650Z"
}

# Step 2: Create a subscription to a set of topics for the channel
cat subscriptions.json | gc notifications channels subscriptions subscribe streaming-2-aa5h48uk0srhpugh2994klj918  #The channel created in step #1

#The content of the subscriptions.json is shown here
[
  {
    "id": "v2.analytics.queues.{QUEUE ID HERE}.observations"
  }
]

# Step 3: Listen to the channel for subscriptions.  At this point all events you have subscribed to on the channel should flow to standard out.  
# Note:  The output from this command will also include the channel. 
gc notifications channels listen streaming-2-aa5h48uk0srhpugh2994klj918  #The channel create in step #1.  


# >> END subscribe_to_notification_events