# Define a function to check the runners
function CheckRunners($jsonResponse) {
    # Convert the JSON response to a PowerShell object
    $object = $jsonResponse | ConvertFrom-Json
    
$object.runners | Format-Table

# Get the types of status and busy
$object.runners | Get-Member -MemberType Properties

# Output:
# Name   MemberType   Definition
# ----   ----------   ----------
# busy   NoteProperty bool busy=True
# id     NoteProperty long id=22
# labels NoteProperty Object[] labels=System.Object[]
# name   NoteProperty string name=GH-01
# os     NoteProperty string os=Windows
# status NoteProperty string status=online

    # Check if there is at least one item with a status of "online" and busy of false
    $onlineAndNotBusy = $object.runners | Where-Object { $_.status -eq "online" -and $_.busy -eq $false }

    # Return true if there is at least one item with a status of "online" and busy of false
    if ($onlineAndNotBusy) {
        return $true
    } else {
        return $false
    }
}

# Get the JSON response from the API for the specific repository
$jsonResponseRepo = gh api /repos/IntelliTect-Dev/StormingTheCastle/actions/runners | Out-String

# Check the runners for the specific repository
$repoRunnersOnlineAndNotBusy = CheckRunners $jsonResponseRepo

if ($repoRunnersOnlineAndNotBusy) {
    # If there are online and not busy runners for the specific repository, return true
    $true
} else {
    # If there are no online and not busy runners for the specific repository, check the runners at the organization level
    $jsonResponseOrg = gh api /orgs/IntelliTect-Dev/actions/runners | Out-String
    $orgRunnersOnlineAndNotBusy = CheckRunners $jsonResponseOrg

    # Return the result of checking the runners at the organization level
    $orgRunnersOnlineAndNotBusy
}
