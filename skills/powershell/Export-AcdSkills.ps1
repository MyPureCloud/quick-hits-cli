# >> START Export-AcdSkill Examples of creating Skills with the CLI

<#
    DESCRIPTION
        Exports the skills definitions from one Genesys Cloud organization and re-creates them in another.  
        This will take all of the skills from the SOURCE_OAUTH_CLIENT and dump 
        them to a file - retaining only the 'name' property.
        It then iterates through all of the files and recreates the skills in the 
        DEST_OAUTH_CLIENT

    POWERSHELL_VERSION
        PowerShell v5.1 and up
#>

gc.exe -p SOURCE_OAUTH_CLIENT routing skills list -a > skills.json  # Dump all of the skills out of the target org into a file
(Get-Content -Path ".\skills.json" | ConvertFrom-Json) |            
    Select-Object name |                                            # Retain only the name property
    ForEach-Object { $i = 0 } {                                     # Split each record into its own file
        $_ | ConvertTo-JSON | 
            Out-File -FilePath ".\temp\skill-$(($i++)).json"
    }
Get-ChildItem -Path ".\temp\*" -Include skill-*.json -Name |        # Take all the file names and use the cli to create the skill
    ForEach-Object { gc.exe -p DEST_OAUTH_CLIENT routing skills create -f $_ }


# >> END Export-AcdSkill
