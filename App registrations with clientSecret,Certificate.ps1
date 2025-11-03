Write-Host "Fetching applications with Client Secrets and Certificates..." -ForegroundColor Cyan

# Fetch all applications
$apps = Get-MgApplication -All -Property "id,appId,displayName,passwordCredentials,keyCredentials"

$reportData = [System.Collections.Generic.List[PSObject]]::new()
$processedApps = @{}

foreach ($app in $apps) {
    $appId = $app.AppId
    $appName = $app.DisplayName
    
    # Skip if we've already processed this app
    if ($processedApps.ContainsKey($appId)) { continue }
    
    $latestSecret = $null
    $latestCert = $null
    $credentialType = "None"
    
    # Check for Client Secrets (PasswordCredentials)
    if ($app.PasswordCredentials.Count -gt 0) {
        $latestSecret = $app.PasswordCredentials | Sort-Object EndDateTime -Descending | Select-Object -First 1
        $credentialType = "Client Secret"
    }
    
    # Check for Certificates (KeyCredentials)
    if ($app.KeyCredentials.Count -gt 0) {
        $latestCert = $app.KeyCredentials | Sort-Object EndDateTime -Descending | Select-Object -First 1
        $credentialType = "Certificate"
    }
    
    # Only include apps that have at least one credential type (Client Secret or Certificate)
    if ($latestSecret -or $latestCert) {
        # Determine which credential to show (prioritize secret > cert)
        if ($latestSecret) {
            $credentialName = $latestSecret.DisplayName
            $startDate = Get-Date $latestSecret.StartDateTime -Format "dd/MM/yyyy"
            $endDate = Get-Date $latestSecret.EndDateTime -Format "dd/MM/yyyy"
            $credentialInfo = "Client Secret: $credentialName"
        }
        elseif ($latestCert) {
            $credentialName = $latestCert.DisplayName
            $startDate = Get-Date $latestCert.StartDateTime -Format "dd/MM/yyyy"
            $endDate = Get-Date $latestCert.EndDateTime -Format "dd/MM/yyyy"
            $credentialInfo = "Certificate: $credentialName"
        }
        
        $entry = [PSCustomObject]@{
            ApplicationName = $appName
            ApplicationID   = $appId
            CredentialType  = $credentialType
            CredentialName  = $credentialName
            StartDate       = $startDate
            EndDate         = $endDate
            LatestCredential = $credentialInfo
        }
        
        $reportData.Add($entry)
        $processedApps[$appId] = $true
        
        Write-Output "`n==== Application with Credentials ===="
        Write-Output "App Name: $($entry.ApplicationName)"
        Write-Output "App ID: $($entry.ApplicationID)"
        Write-Output "Credential Type: $($entry.CredentialType)"
        Write-Output "Credential Name: $($entry.CredentialName)"
        Write-Output "Start Date: $($entry.StartDate)"
        Write-Output "End Date: $($entry.EndDate)"
    }
}

# Display summary
Write-Output "`n✅ Summary: Found $($reportData.Count) applications with client secrets or certificates." -ForegroundColor Green

# Export to CSV if needed
if ($reportData.Count -gt 0) {
    $reportData | Export-Csv -Path "C:\Users\sande\OneDrive\data-inout-PS\AppsWithCredentials_enhanced.csv" -NoTypeInformation
    Write-Output "📄 Report exported to: AppsWithCredentials.csv" -ForegroundColor Yellow
    
    # Display in table format
    $reportData | Format-Table ApplicationName, ApplicationID, CredentialType, CredentialName, StartDate, EndDate -AutoSize
}
