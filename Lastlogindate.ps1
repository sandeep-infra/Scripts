
Connect-MgGraph -Scopes "AuditLog.Read.All"

# Path to the CSV file containing UPNs
$csvPath = "C:\Users\sysvl-samed15\UPN.csv"

# Import the CSV file
$UPNs = Import-Csv -Path $csvPath

# Define the properties to fetch, which includes SignInActivity
$Properties = "DisplayName,UserPrincipalName,SignInActivity"

# Initialize an empty array to collect user objects with sign-in activity
$UsersWithSignInActivity = @()

# Fetch data for each user specified in the CSV
foreach ($user in $UPNs) {
    $userPrincipalName = $user.UserPrincipalName

    # Get the user object with specified properties using filtering
    $userObject = Get-MgUser -Filter "UserPrincipalName eq '$userPrincipalName'" -Property $Properties

    if ($userObject) {
        # Get the last sign-in date from the SignInActivity property
        $LastLoginDate = $userObject.SignInActivity.LastSignInDateTime

        # Create a new custom object with the required properties
        $customUserObject = [PSCustomObject]@{
            DisplayName    = $userObject.DisplayName
            UserPrincipalName = $userObject.UserPrincipalName
            LastLoginDate  = $LastLoginDate
        }

        # Collect the custom user object
        $UsersWithSignInActivity += $customUserObject
    } else {
        Write-Output "User not found: $userPrincipalName"
    }
}

# Export the users along with their last sign-in dates to a CSV file
$UsersWithSignInActivity | Export-Csv -Path "C:\Users\sysvl-samed15\lastlogin.csv" -NoTypeInformation -Force
