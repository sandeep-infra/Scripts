# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Path to the CSV file
$csvPath = "C:\Users\sysvl-samed15\removeusersg.csv"

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Define the group names or IDs from which the users need to be removed
$groupNames = @(
    "SG-CBRS-SSO-1Password-Prod"
)

foreach ($groupName in $groupNames) {
    $group = Get-AzureADGroup -Filter "DisplayName eq '$groupName'"

    if ($group) {
        foreach ($user in $users) {
            $userObj = Get-AzureADUser -ObjectId $user.UserPrincipalName

            if ($userObj) {
                # Remove the user from the group if they are a member
                $groupMembers = Get-AzureADGroupMember -ObjectId $group.ObjectId
                if ($groupMembers.ObjectId -contains $userObj.ObjectId) {
                    Remove-AzureADGroupMember -ObjectId $group.ObjectId -MemberId $userObj.ObjectId
                    Write-Host "Removed $($userObj.UserPrincipalName) from $($group.DisplayName)"
                } else {
                    Write-Host "$($userObj.UserPrincipalName) is not a member of $($group.DisplayName)"
                }
            } else {
                Write-Host "User not found: $($user.UserPrincipalName)"
            }
        }
    } else {
        Write-Host "Group not found: $groupName"
    }
}
