
##fetching UPNS from objectId
#Requires -Module Microsoft.Graph.Users

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All"

# Input and output file paths
$inputCsvPath = "C:\Users\sande\OneDrive\data-inout-PS\UserId.csv"
$outputCsvPath = "C:\Users\sande\OneDrive\data-inout-PS\UPNOutput.csv"

try {
    # Import user Object IDs from CSV
    $userData = Import-Csv -Path $inputCsvPath
    $objectIds = $userData.UserId

    if (-not $objectIds) {
        Write-Host "No UserId values found in the CSV file." -ForegroundColor Yellow
        exit
    }

    # Batch process users (300 per request)
    $batchSize = 300
    $results = @()
    
    for ($i = 0; $i -lt $objectIds.Count; $i += $batchSize) {
        $batchIds = $objectIds[$i..([Math]::Min($i + $batchSize - 1, $objectIds.Count - 1))]
        $filter = "id in ('$($batchIds -join "','")')"
        
        Write-Host "Processing batch $([math]::Ceiling($i/$batchSize)+1) of $([math]::Ceiling($objectIds.Count/$batchSize))" -ForegroundColor Cyan
        
        try {
            $batchUsers = Get-MgUser -Filter $filter -All `
                -Property Id, UserPrincipalName -ConsistencyLevel eventual -ErrorAction Stop
            
            $results += $batchUsers | Select-Object Id, UserPrincipalName
        }
        catch {
            Write-Warning "Error processing batch: $_"
            # Fallback to individual processing for this batch
            foreach ($id in $batchIds) {
                try {
                    $user = Get-MgUser -UserId $id -Property Id, UserPrincipalName -ErrorAction Stop
                    $results += $user | Select-Object Id, UserPrincipalName
                }
                catch {
                    Write-Warning "Failed to retrieve user $id : $_"
                    $results += [PSCustomObject]@{
                        Id = $id
                        UserPrincipalName = "Error: Not Found"
                    }
                }
            }
        }
    }

    # Output results to CSV
    $results | Export-Csv -Path $outputCsvPath -NoTypeInformation -Encoding UTF8
    Write-Host "Results exported to $outputCsvPath" -ForegroundColor Green

    # Display results in console
    $results | Format-Table Id, UserPrincipalName -AutoSize
}
catch {
    Write-Error "Critical error: $_"
}
