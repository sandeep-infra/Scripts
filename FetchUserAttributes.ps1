
$UPN = "sandeep.medishetty@inter.ikea.com"

$user = Get-MgUser -Filter "UserPrincipalName eq '$UPN'" -Property ID, DisplayName, UserPrincipalName, onPremisesSamAccountName, onPremisesExtensionAttributes | 
        Select-Object ID, DisplayName, UserPrincipalName, OnPremisesSamAccountName, 
                      @{Name="ExtensionAttribute15"; Expression={$_.OnPremisesExtensionAttributes.extensionAttribute15}}

# Display the result
$user | Format-Table -AutoSize




------------------------------------------------------

$csvPath = "C:\Users\sysvl-samed15\onpremdetfetch.csv"

# Read the CSV file
$upnList = Import-Csv -Path $csvPath

# Initialize an array to hold the results
$userDetails = @()

# Loop through each UPN and fetch the user details
foreach ($upn in $upnList) {
    $user = Get-MgUser -Filter "UserPrincipalName eq '$($upn.UPN)'" -Property ID, DisplayName, UserPrincipalName, onPremisesSamAccountName, onPremisesExtensionAttributes | 
            Select-Object ID, DisplayName, UserPrincipalName, OnPremisesSamAccountName, 
                          @{Name="ExtensionAttribute15"; Expression={$_.OnPremisesExtensionAttributes.extensionAttribute15}}
    
    # Add the fetched user details to the array
    $userDetails += $user
}

# Display the results
$userDetails | Format-Table -AutoSize

$outputCsvPath = "C:\Users\sysvl-samed15\onpremdetfetchoutput12.csv"

$userDetails | Export-Csv -Path $outputCsvPath -NoTypeInformation

