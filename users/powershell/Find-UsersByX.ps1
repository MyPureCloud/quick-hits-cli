# >> START Find-UsersByX A set of Genesys Cloud CLI commands the will identify a user by role, division, group or skill.

<# 
    .DESCRIPTION
        Example commands to search for all users by a role, division or group.
        PowerShell v5.1 and up.
#>

# Get a list of all of the user IDs with a given role, then export to file.
(gc.exe users list -a --expand="authorization" | ConvertFrom-Json) | Where-Object {$_.authorization.roles.name -eq "Supervisor"} | Select-Object -ExpandProperty id | Out-File -FilePath .\authorizations-user.txt
 
# Get a list of all users by role and convert the data to a csv file
(gc.exe users list -a --expand="authorization" | ConvertFrom-Json) | Where-Object {$_.authorization.roles.name -eq "Supervisor"} | Select-Object id, @{Name="division"; Expression={$_.division.name}}, email | Export-Csv -Path .\supervisors.csv -NoTypeInformation

# Get a list of all of the user ids with a particular skill
(gc.exe users list -a --expand="skills" | ConvertFrom-Json) | Where-Object {$_.skills.name -eq "Prince_Skill"} | Select-Object -ExpandProperty id | Out-File -FilePath .\authorizations-user.txt

# Get a list of all users by skill and convert the data to a csv file
(gc.exe users list -a --expand="skills" | ConvertFrom-Json) | Where-Object {$_.skills.name -eq "Prince_Skill"} | Select-Object id, @{Name="division"; Expression={$_.division.name}}, email | Export-Csv -Path .\users_with_skill.csv -NoTypeInformation

# Get a list of all of the user ids with their group information 
$groupId = (gc.exe groups list -a | ConvertFrom-Json) | Where-Object name -eq "TWICE_Group" | Select-Object -First 1 -ExpandProperty id
(gc.exe users list -a --expand="groups" | ConvertFrom-Json) | Where-Object {$_.groups.id -eq $groupId} | ConvertTo-Json -Depth 20 | Out-File -FilePath .\groups.json
 
# Get a list of all users by group and convert the data to a csv file
$groupId = (gc.exe groups list -a | ConvertFrom-Json) | Where-Object name -eq "BlackPink_Group" | Select-Object -First 1 -ExpandProperty id
(gc.exe users list -a --expand="groups" | ConvertFrom-Json) | Where-Object {$_.groups.id -eq $groupId} | Select-Object id, @{Name="division"; Expression={$_.division.name}}, email | Export-Csv -Path .\group_members.csv -NoTypeInformation

# Get a list of all of the user ids with their division information with their skill information
(gc.exe users list -a --expand="skills" | ConvertFrom-Json) | Where-Object {$_.division.name -eq "DivisionA"} | Select-Object -ExpandProperty id | Out-File -FilePath .\division-users.txt
 
# Get a list of all users by division and convert the data to a csv file
(gc.exe users list -a --expand="skills" | ConvertFrom-Json) | Where-Object {$_.division.name -eq "DivisionA"} | Select-Object id, @{Name="division"; Expression={$_.division.name}}, email | Export-Csv -Path .\division_users.csv -NoTypeInformation

# >> END Find-UsersByX
