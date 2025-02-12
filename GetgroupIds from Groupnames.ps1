$inputCsvFilePath = "C:\Users\sysvl-samed15\SGNames.csv"

# Specify the path for the output CSV file
$outputCsvFilePath = "C:\Users\sysvl-samed15\fetchgroupid.csv"

# Read group names from the CSV file
$inputGroups = Import-Csv $inputCsvFilePath | Select-Object -ExpandProperty GroupName

# Initialize an array to store the results
$outputData = @()

# Iterate through each group name and retrieve the ObjectId
foreach ($groupName in $inputGroups) {
    $group = Get-AzureADGroup -Filter "displayName eq '$groupName'"
    
    if ($group -ne $null) {
        $groupObject = [PSCustomObject]@{
            GroupName = $groupName
            ObjectId = $group.ObjectId
        }
        $outputData += $groupObject
        Write-Host "Group '$groupName' found with ObjectId: $($group.ObjectId)"
    } else {
        Write-Host "Group '$groupName' not found."
    }
}

# Output the array of group ObjectIds to the CSV file
$outputData | Export-Csv -Path $outputCsvFilePath -NoTypeInformation

Write-Host "Results exported to $outputCsvFilePath"
