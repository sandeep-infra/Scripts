
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

--------------------------------------------------------------------------------------------------------------------

#Non-Interactive signins

Connect-MgGraph -Scopes "User.Read.All"

# Path to the CSV file containing UPNs
$csvPath = "C:\Users\sande\OneDrive\data-inout-PS\UPN.csv"

# Import the CSV file
$UPNs = Import-Csv -Path $csvPath

# Define the properties to fetch, which includes SignInActivity
$Properties = "DisplayName,UserPrincipalName,SignInActivity,AccountEnabled"

# Initialize an empty array to collect user objects with sign-in activity
$UsersWithSignInActivity = @()

# Fetch data for each user specified in the CSV
foreach ($user in $UPNs) {
    $userPrincipalName = $user.UserPrincipalName
    Write-Host "Processing $userPrincipalName..." -ForegroundColor Cyan

    try {
        # Get the user object with specified properties using filtering
        $userObject = Get-MgUser -Filter "UserPrincipalName eq '$userPrincipalName'" `
            -Property $Properties -ErrorAction Stop

        if ($userObject) {
            # Get both sign-in dates from the SignInActivity property
            $interactiveSignIn = $userObject.SignInActivity.LastSignInDateTime
            $nonInteractiveSignIn = $userObject.SignInActivity.LastNonInteractiveSignInDateTime
            
            # Calculate days since last sign-in
            $daysSinceInteractive = if ($interactiveSignIn) { 
                [math]::Round(((Get-Date) - $interactiveSignIn).TotalDays) 
            } else { $null }
            
            $daysSinceNonInteractive = if ($nonInteractiveSignIn) { 
                [math]::Round(((Get-Date) - $nonInteractiveSignIn).TotalDays) 
            } else { $null }

            # Create a new custom object with the required properties
            $customUserObject = [PSCustomObject]@{
                DisplayName              = $userObject.DisplayName
                UserPrincipalName       = $userObject.UserPrincipalName
                AccountEnabled          = $userObject.AccountEnabled
                LastInteractiveSignIn   = $interactiveSignIn
                LastNonInteractiveSignIn= $nonInteractiveSignIn
                #DaysSinceInteractive    = $daysSinceInteractive
                #DaysSinceNonInteractive = $daysSinceNonInteractive
            }

            # Collect the custom user object
            $UsersWithSignInActivity += $customUserObject
        } else {
            Write-Host "User not found: $userPrincipalName" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Error processing $userPrincipalName : $_" -ForegroundColor Red
    }
}

# Export the users along with their sign-in dates to a CSV file
$outputPath = "C:\Users\sande\OneDrive\data-inout-PS\non-interactiveSMB.csv"
$UsersWithSignInActivity | Export-Csv -Path $outputPath -NoTypeInformation -Force

# Display results
$UsersWithSignInActivity | Format-Table DisplayName, UserPrincipalName, LastInteractiveSignIn, LastNonInteractiveSignIn, DaysSinceInteractive, AccountEnabled -AutoSize

#Write-Host "Report exported to $outputPath" -ForegroundColor Green
