# >> START usage-api-query A set of Genesys Cloud CLI commands for querying the usage api.

##### 
#  This example will query the API usage by day for an entire week of time and map a summary of all status codes to a CSV file.
#  Note:  The command below will need to have all the lines concated together on one line.  I broke the lines apart to make the command easier to read. 
#
#  Also, for a further explanation on the usage API, please see: https://developer.mypurecloud.com/blog/2021-01-04-API-Usage/
##### 
cat query-api-usage-for-week.json \
  | gc usage query create -t 10 \
  | jq -r '.results |   sort_by(.date,.clientName)' \
  | jq -r '. | map({date: .date, clientName: .clientName, templateUri: .templateUri, requests: .requests, status200: .status200, status300: .status300, status400: .status400, status429: .status429, status500: .status500})' \
  | jq -r '(.[0] | keys_unsorted) as $keys | ([$keys] + map([.[ $keys[] ]])) [] | @csv'


# Here is the contents of the query-api-usage-for-a-week.json file
{
  "interval": "2020-02-01/2020-02-28",
  "granularity": "Day",
  "groupBy": [
    "OAuthClientId",
    "TemplateUri"
  ]
}

# >> END usage-api-query
