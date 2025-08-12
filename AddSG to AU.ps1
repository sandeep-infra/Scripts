##With Csv##

Connect-MgGraph -Scopes "Group.ReadWrite.All", "AdministrativeUnit.ReadWrite.All"

$administrativeUnitId = "0244b8bc-ec58-43d2-95f0-c28f9dcde39b"  # Replace with your actual AU ID

# Load group IDs from CSV
$csvPath = "C:\Path\To\groupIds.csv"  # Update with your actual path #(Columnname with groupId)
$groupIds = Import-Csv -Path $csvPath

foreach ($entry in $groupIds) {
    $groupId = $entry.groupId  # Assumes the column header is 'groupId'

    try {
        # Add the group to the administrative unit
        New-MgDirectoryAdministrativeUnitMemberByRef `
            -AdministrativeUnitId $administrativeUnitId `
            -OdataId "https://graph.microsoft.com/v1.0/groups/$groupId"

        Write-Host "✅ Successfully added group '$groupId' to administrative unit '$administrativeUnitId'" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error adding group '$groupId': $($_.Exception.Message)" -ForegroundColor Red
    }
}

-----------------------------------------------------------------------
## With Array
Connect-MgGraph -Scopes "Group.ReadWrite.All", "AdministrativeUnit.ReadWrite.All"

$administrativeUnitId = "0244b8bc-ec58-43d2-95f0-c28f9dcde39b"  # Replace with the actual AU ID
$securityGroupIds = @("2047b54e-39ec-40bf-b3ce-36c81f028e14")

foreach ($groupId in $securityGroupIds) {
    try {
        # Add the group to the administrative unit
        New-MgDirectoryAdministrativeUnitMemberByRef -AdministrativeUnitId $administrativeUnitId -OdataId "https://graph.microsoft.com/v1.0/groups/$groupId"
 
        Write-Host "Successfully added group '$groupId' to administrative unit '$administrativeUnitId'" -ForegroundColor Green
    } catch {
        Write-Host "Error adding group '$groupId' to administrative unit '$administrativeUnitId': $($_.Exception.Message)" -ForegroundColor Red
    }
}

---------------------------------------------------------------------------

#Get the group count in AU


$adminUnitObjectId = "0f6d35c3-afdf-4c0b-824d-f53c0fa96e82"

# Get the members (groups) of the Administrative Unit
$adminUnitMembers = Get-AzureADAdministrativeUnitMember -ObjectId $adminUnitObjectId

# Count the number of groups in the Administrative Unit
$groupCount = $adminUnitMembers.Count

Write-Host "Number of groups in Administrative Unit with ObjectId $($adminUnitObjectId): $groupCount"
