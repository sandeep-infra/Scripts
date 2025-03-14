# Connect to Azure AD
Connect-AzureAD

# Define the path to your CSV file
$csvPath = "C:\Users\sysvl-samed15\guestuser-domainname.csv"

# Import the CSV file
$domains = Import-Csv -Path $csvPath

# Initialize an array to store the guest users
$guestUsers = @()

# Loop through each domain in the CSV file
foreach ($domain in $domains) {
    $domainName = $domain.DomainName
    Write-Output "Fetching users for domain: $domainName"

    # Query Azure AD for guest users with the specified email domain
    $users = Get-AzureADUser -All $true | Where-Object { $_.Mail -like "*@$domainName" -and $_.UserType -eq "Guest"}
    
    # Add the results to the guestUsers array
    $guestUsers += $users
}

# Output the guest users
$guestUsers

# Optional: Export the guest users to a new CSV file
$guestUsers | Select-Object DisplayName, Mail, UserPrincipalName, UserType | Export-Csv -Path "C:\Users\sysvl-samed15\guestUsersdomain.csv" -NoTypeInformation
