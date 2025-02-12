App deletion with CSV:

# Specify the path to your CSV file
$csvFilePath = "C:\Users\sysvl-samed15\AppID.csv"

# Read the CSV file
$appRegistrations = Import-Csv -Path $csvFilePath

# Loop through each row in the CSV and delete app registrations
foreach ($app in $appRegistrations) {
    $appId = $app.AppId

    # Search for the app registration by AppId
    $appToDelete = Get-AzureADApplication -Filter "AppId eq '$appId'"

    if ($appToDelete) {
        Write-Host "Deleting app registration with AppId: $appId"
        # Delete the app registration
        Remove-AzureADApplication -ObjectId $appToDelete.ObjectId
        Write-Host "Deleted."
    }
    else {
        Write-Host "App registration not found with AppId: $appId"
    }
}




----------------------------------------------------------------------------------------------------

With Functions:

function Remove-AzureADApplications 
{
    [CmdletBinding()]
    param
    (
        [Parameter(HelpMessage = "The ApplicationID/ClientID of the application to remove.")]
        [string]
        $ApplicationId,

        [Parameter(HelpMessage = "Forces the command to run without asking for user confirmation.")]
        [Switch]
        $Force
    )

    Import-Module "AzureAD";

    if (-not $ApplicationId) {
        Write-Error "ApplicationID/ClientID is required."
        return
    }

    # Get the application by ApplicationID/ClientID
    $appToDelete = Get-AzureADApplication -Filter "AppId eq '$ApplicationId'"

    if ($appToDelete) {
        if ($Force -or (Read-Host "Are you sure you want to delete the application with AppID $ApplicationId? (Y/N)").ToLower() -eq 'y') {
            try {
                Remove-AzureADApplication -ObjectId $appToDelete.ObjectId
                Write-Host "Removed application with AppID $ApplicationId..." -ForegroundColor Green;
            }
            catch {
                Write-Host "Failed to remove application with AppID $ApplicationId..." -ForegroundColor Red;
            }
        }
        else {
            Write-Host "Operation canceled." -ForegroundColor Yellow;
        }
    }
    else {
        Write-Host "Application with AppID $ApplicationId not found." -ForegroundColor Yellow;
    }
}

# Example usage:
# Remove-AzureADApplications -ApplicationId "your_application_id" -Force
