# Get sorted list of User Roles - Search by email
(gc.exe users list -a --expand="authorization" | ConvertFrom-Json) | Where-Object email -eq "thanos.mcsnappy@example.com" | Select-Object @{Name="roles"; Expression={$_.authorization.roles.name}} | Select-Object -ExpandProperty roles | Sort-Object 

########
# Composition:
# Search users first, then expand to get details
# Reduces data transmission at the expense of more API calls
########

# Search for a user by email, then expand to get user data 
(gc.exe users list -a | ConvertFrom-Json) | Where-Object email -eq "tony.stark@starkindustries.org" | ForEach-Object {gc.exe users get $_.id --expand="authorization"}
