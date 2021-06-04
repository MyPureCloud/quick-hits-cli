# >> START Import-BulkCannedResponse Create a canned response using the Genesys Cloud CLI

<#
    .DESCRIPTION
        An example of how create a canned response using the Genesys Cloud CLI
        PowerShell v5.1 and up
#>

####
# Step 1:  Create the Libraries 
####
Write-Output '{"name": "Bulk Example Library","version": 1}' | 
    gc.exe responsemanagement libraries create 

####
# Step 2: From the response, copy the Id generated for your new Library:
####
<# -- Example JSON Response
    {
        "id": "1adacdea-9543-4b00-b48d-5776dr34c4fe", 
        "name": "Bulk Example Library",
        "version": 1,
        "createdBy": {
            "id": "",
            "selfUri": ""
        },
        "dateCreated": "",
        "selfUri": ""
    }
#>

####
# Step 3: Create your canned response files using the following templates. 
####
<#
    {
        "name": "Response Name",
        "version": 1,
        "libraries": [
            {
                "id": "Your LibraryId ",
                "name": "",
                "selfUri": ""
            }
        ],
        "texts": [
            {
                "content": "Your Response text goes here",
                "contentType": "text/html"
            }
        ]
    }
#>

####
#Step 4> Create the Responses: 
####

Get-ChildItem -Path ".\*" -Include canned*.json |  
    ForEach-Object {
        $_ | Get-Content |
            gc.exe responsemanagement responses create
    }

# for f in canned*;do cat "$f" | gc responsemgt responses create;done

# this command will read all the files created in Step3, in this example filename convention was canned1.json, canned2.json and so on. Feel free to use your own filenames.


# >> END Import-BulkCannedResponse
