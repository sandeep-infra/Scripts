# Specify the path to your CSV file containing AppIds	
$csvFilePath = "C:\Users\sysvl-samed15\App_Disable.csv"	
	
# Read the CSV file	
$appIds = Import-Csv -Path $csvFilePath | Select-Object -ExpandProperty AppId	
	
# Loop through each AppId and disable the corresponding application	
foreach ($appId in $appIds) {	
    # Check if a service principal already exists for the app	
    $servicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$appId'"	
    	
    if ($servicePrincipal) {	
        # Service principal exists already	 disable it
        Set-AzureADServicePrincipal -ObjectId $servicePrincipal.ObjectId -AccountEnabled $false	
        Write-Host "Disabled application with AppId: $appId"	
    } else {	
        Write-Host "Service principal not found for AppId: $appId"	
    }	
}	
	
------------------------------------------	
	
# Specify the path to your CSV file containing AppIds	
$csvFilePath = "C:\Users\sande\AppID_disable.csv"	
	
# Read the CSV file	
$appIds = Import-Csv -Path $csvFilePath | Select-Object -ExpandProperty AppId	
	
# Loop through each AppId and disable the corresponding application	
foreach ($appId in $appIds) {	
    # Check if a service principal already exists for the app	
    $servicePrincipal = Get-AzureADServicePrincipal | Where-Object { $_.AppId -eq $appId }	
    	
    if ($servicePrincipal) {	
        # Service principal exists already	 disable it
        Set-AzureADServicePrincipal -ObjectId $servicePrincipal.ObjectId -AccountEnabled $false	
        Write-Host "Disabled application with AppId: $appId"	
    } else {	
        Write-Host "Service principal not found for AppId: $appId"	
    }	
}	
