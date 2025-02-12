
$adminUnitObjectId = "0f6d35c3-afdf-4c0b-824d-f53c0fa96e82"

$csvFilePath = "C:\Users\sysvl-samed15\GroupAU.csv"


$groupIds = Import-Csv -Path $csvFilePath | Select-Object -ExpandProperty GroupId

foreach ($securityGroupObjectId in $groupIds) {
    Add-AzureADAdministrativeUnitMember -ObjectId $adminUnitObjectId -RefObjectId $securityGroupObjectId
    Write-Host "Added Security Group with ObjectId $($securityGroupObjectId) to Administrative Unit with ObjectId $($adminUnitObjectId)"
}


-------------------------------------------------------


#Get the group count in AU


$adminUnitObjectId = "0f6d35c3-afdf-4c0b-824d-f53c0fa96e82"

# Get the members (groups) of the Administrative Unit
$adminUnitMembers = Get-AzureADAdministrativeUnitMember -ObjectId $adminUnitObjectId

# Count the number of groups in the Administrative Unit
$groupCount = $adminUnitMembers.Count

Write-Host "Number of groups in Administrative Unit with ObjectId $($adminUnitObjectId): $groupCount"
