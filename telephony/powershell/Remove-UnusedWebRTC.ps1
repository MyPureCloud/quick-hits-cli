# >> START Remove-UnusedWebRTC

<#
    .DESCRIPTION
        This script provides an example on how to delete WebRTC phones that are not assigned 
        to any users or assigned previously to users which are now inactive or deleted.

        PowerShell v5.1 and up
#>

# Query all Phones in the Genesys Cloud Org
(gc.exe telephony providers edges phones list -a --fields webRtcUser | ConvertFrom-Json ) | 
    # Get all phones that are WebRTC and does not have any users assigned to them
    Where-Object {!$_.webRtcUser -and ($_.phoneMetaBase.id -eq "inin_webrtc_softphone.json")} | 
    ForEach-Object {
        Write-Host "Starting deletion of unassigned WebRTC Phones..."
        $i = 0
    }{
        # Delete the WebRTC Phone
        gc.exe telephony providers edges phones delete $_.id | ConvertFrom-Json | Select-Object id
        Write-Host "Deleted $($_.name)"
        $i++
    }{
        Write-Host "Finished. Number of WebRTC phones deleted: $($i)" -ForegroundColor Green
    }
    

# >> END Remove-UnusedWebRTC
