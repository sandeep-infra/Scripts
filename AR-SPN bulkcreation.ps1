Connect-AzureAD 


    ------------------------------------------

    ##Azure AD Module

    $csvPath = "C:\Users\sysvl-samed15\App_CreationBulk.csv"

    $applications = Import-Csv -Path $csvPath

# Loop through each row in the CSV and register applications
foreach ($app in $applications) {
    $appName = $app.AppName
    $owners = $app.Owners -split ";"

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

    
    # Set owners for the service principal
    $servicePrincipalOwners = $app.Owners -split ";"
    foreach ($owner in $servicePrincipalOwners) {
        $ownerUser = Get-AzureADUser -ObjectId $owner
        if ($ownerUser) {
            Add-AzureADServicePrincipalOwner -ObjectId $servicePrincipal.ObjectId -RefObjectId $ownerUser.ObjectId
            Write-Output "Added owner $ownerUser.UserPrincipalName to service principal of application $appName"
        } else {
            Write-Warning "Owner $owner not found in Azure AD"
        }
    }
}

    

    ------------------------------------------------
    ##MgGraph Module

    $csvPath = "C:\Users\sysvl-samed15\App_CreationBulk.csv"

$applications = Import-Csv -Path $csvPath

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Application.ReadWrite.All", "User.Read.All", "Directory.ReadWrite.All"

# Loop through each row in the CSV and register applications
foreach ($app in $applications) {
    $appName = $app.AppName
    $owners = $app.Owners -split ";"

    # Create the Azure AD application
    $newApp = New-MgApplication -DisplayName $appName

    # Create service principal for the application
    $servicePrincipal = New-MgServicePrincipal -AppId $newApp.AppId
    Write-Output "Created service principal for application $appName"

    # Set owners for the application and the service principal
    foreach ($owner in $owners) {
        # Get the owner user
        $ownerUser = Get-MgUser -UserId $owner
        if ($ownerUser) {
            # Add owner to application
            Add-MgApplicationOwner -ApplicationId $newApp.Id -DirectoryObjectId $ownerUser.Id
            Write-Output "Added owner $ownerUser.UserPrincipalName to application $appName"

            # Add owner to service principal
            Add-MgServicePrincipalOwner -ServicePrincipalId $servicePrincipal.Id -DirectoryObjectId $ownerUser.Id
            Write-Output "Added owner $ownerUser.UserPrincipalName to service principal of application $appName"
        } else {
            Write-Warning "Owner $owner not found in Azure AD"
        }
    }

 
