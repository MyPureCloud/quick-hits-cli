# >> START Request-UsageApi A set of Genesys Cloud CLI commands for querying the usage api

<#
    .DESCRIPTION    
        This example will query the API usage by day for an entire week of time and map a summary of all status codes to a CSV file.
    
        For a further explanation on the usage API, please see: https://developer.mypurecloud.com/blog/2021-01-04-API-Usage/
        
        PowerShell v5.1 and up
#>

Get-Content -Path ".\query-api-usage-for-week.json" |
    gc.exe usage query create -t 10 | ConvertFrom-Json |
    Select-Object -ExpandProperty results |
    Sort-Object -Property date, clientName |
    Select-Object date, clientName, templateUri, requests, status200, status300, status400, status429, status500 | 
    Export-Csv -Path .\api_usage.csv -NoTypeInformation


# Here is the contents of the query-api-usage-for-a-week.json file
# {
#   "interval": "2020-02-01/2020-02-28",
#   "granularity": "Day",
#   "groupBy": [
#     "OAuthClientId",
#     "TemplateUri"
#   ]
# }

# >> END Request-UsageApi
