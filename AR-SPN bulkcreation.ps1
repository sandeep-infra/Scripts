Connect-AzureAD 

$csvPath = "C:\Users\sysvl-samed15\App_CreationBulk.csv"

$applications = Import-Csv -Path $csvPath

# Loop through each row in the CSV and register applications
foreach ($app in $applications) {
    $appName = $app.AppName
    $owners = $app.Owners -split ","

    # Create the Azure AD application
    $newApp = New-AzureADApplication -DisplayName $appName

    # Set owners for the application
    foreach ($owner in $owners) {
        $ownerUser = Get-AzureADUser -ObjectId $owner
        if ($ownerUser) {
            Add-AzureADApplicationOwner -ObjectId $newApp.ObjectId -RefObjectId $ownerUser.ObjectId
            Write-Output "Added owner $ownerUser.UserPrincipalName to application $appName"
        } else {
            Write-Warning "Owner $owner not found in Azure AD"
        }
    }
}



----------------------------------------------------------------------------
##Create App registration & corresponding SPN


$csvPath = "C:\Users\sysvl-samed15\App_CreationBulk.csv"

# Import CSV data
$applications = Import-Csv -Path $csvPath



# Loop through each row in the CSV and register applications
foreach ($app in $applications) {
    $appName = $app.AppName
    $owners = $app.Owners -split ","

    # Create the Azure AD application
    $newApp = New-AzureADApplication -DisplayName $appName

    # Set owners for the application
    foreach ($owner in $owners) {
        $ownerUser = Get-AzureADUser -ObjectId $owner
        if ($ownerUser) {
            Add-AzureADApplicationOwner -ObjectId $newApp.ObjectId -RefObjectId $ownerUser.ObjectId
            Write-Output "Added owner $ownerUser.UserPrincipalName to application $appName"
        } else {
            Write-Warning "Owner $owner not found in Azure AD"
        }
    }

    # Create service principal for the application
    $servicePrincipal = New-AzureADServicePrincipal -AppId $newApp.AppId
    Write-Output "Created service principal for application $appName"
}




  foreach ($owner in $owners) {
        $ownerUser = Get-AzureADUser -ObjectId $owner
        if ($ownerUser) {
            Add-AzureADServicePrincipalOwner -ObjectId $servicePrincipal.ObjectId -RefObjectId $ownerUser.ObjectId
            Write-Output "Added owner $ownerUser.UserPrincipalName to service principal of application $appName"
        } else {
            Write-Warning "Owner $owner not found in Azure AD"
        }
    }
