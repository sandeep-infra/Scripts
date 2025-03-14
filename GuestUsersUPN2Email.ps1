$inputCsvPath = 'C:\Users\sysvl-samed15\UserUPN.csv'

# Path to the output CSV file to store results
$outputCsvPath = 'C:\Users\sysvl-samed15\UsersWithEmail1.csv'

# Connect to Azure AD
Connect-AzureAD

# Read the CSV file
$userUPNs = Import-Csv $inputCsvPath -Header "UserPrincipalName" | Select-Object -ExpandProperty UserPrincipalName

# Initialize an array to store results
$results = @()

foreach ($userUPN in $userUPNs) {
    try {
        # Get the user by UPN
        $user = Get-AzureADUser -ObjectId $userUPN
        
        # Check if user is found
        if ($user) {
            $userEmail = $user.Mail   # Use the 'Mail' property to get the email attribute
            # Create a custom object to store the user details
            $result = [PSCustomObject]@{
                UserPrincipalName = $userUPN
                UserEmail         = $userEmail
            }
            # Add the result to the results array
            $results += $result
        } else {
            Write-Host "User '$userUPN' not found."
        }
    } catch {
        Write-Host "Error fetching user '$userUPN': $_"
    }
}

# Export results to CSV
$results | Export-Csv -Path $outputCsvPath -NoTypeInformation

Write-Host "Script completed. Results exported to: $outputCsvPath"
