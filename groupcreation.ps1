
Connect-AzureAD

---------------------------------------------------------------

#Create Groups##Working##

$groupProperties = Import-Csv -Path "C:\Users\sysvl-samed15\Group_Create.csv"

foreach ($groupProperty in $groupProperties) {
    $groupName = $groupProperty.Name
    $groupDescription = $groupProperty.Description
    $groupOwnerUPNs = $groupProperty.Owners -split ';'
    $mailNickname = $groupProperty.MailNickname

    # Create the security group
    $securityGroup = New-AzureADGroup -DisplayName $groupName -Description $groupDescription `
                        -SecurityEnabled $true -MailEnabled $false -MailNickname $mailNickname

    foreach ($ownerUPN in $groupOwnerUPNs) {
        $owner = Get-AzureADUser -Filter "userPrincipalName eq '$ownerUPN'"
        if ($owner -ne $null) {
            Add-AzureADGroupOwner -ObjectId $securityGroup.ObjectId -RefObjectId $owner.ObjectId
        } else {
            Write-Host "Owner with UPN '$ownerUPN' not found. Skipping."
        }
    }

    # Display the details of the created security group
    $securityGroup
}

--------------------------------------------------------------------------------------------------
#Add Owners to the SG

# Specify the ObjectId or group name of the Azure AD group
$groupIdOrName = "f94fafcc-e5c9-4cf0-8532-0cf3d44166e7"

# Load the CSV file containing UPNs of users to be added as owners
$csvPath = "C:\Users\sysvl-samed15\Group_Owner.csv"
$usersToAdd = Import-Csv -Path $csvPath

foreach ($userEntry in $usersToAdd) {
    $userUPN = $userEntry.UPN
    
    # Retrieve the user object based on UPN
    $user = Get-AzureADUser -Filter "userPrincipalName eq '$userUPN'"

    if ($user -ne $null) {
        # Add the user as an owner to the Azure AD group
        Add-AzureADGroupOwner -ObjectId $groupIdOrName -RefObjectId $user.ObjectId
        Write-Host "Added user with UPN '$userUPN' as an owner."
    } else {
        Write-Host "User with UPN '$userUPN' not found in Azure AD. Please check the UPN."
    }
}



-------------------------------------------------------------------

## Add user to multiple groups

# Load the CSV file containing UPNs of users to be added as owners
$csvPath = "C:\Users\sysvl-samed15\Group_Owner.csv"
$usersToAdd = Import-Csv -Path $csvPath

# Set the ID or name of the Azure AD group
$groupIdOrName = "YourGroupIdOrName"

foreach ($userEntry in $usersToAdd) {
    $userUPN = $userEntry.UPN
    
    # Retrieve the user object based on UPN
    $user = Get-AzureADUser -Filter "userPrincipalName eq '$userUPN'"

    if ($user -ne $null) {
        # Add the user as an owner to the Azure AD group
        Add-AzureADGroupOwner -ObjectId $groupIdOrName -RefObjectId $user.ObjectId
        Write-Host "Added user with UPN '$userUPN' as an owner."
    } else {
        Write-Host "User with UPN '$userUPN' not found in Azure AD. Please check the UPN."
    }
}
-------------------------------------------------------------------------------------------


# Variables
$CsvFilePath = "C:\path\to\users.csv"  # Update with the path to your CSV file
$GroupName = "YourSecurityGroupName"    # Update with the name of your security group



# Retrieve the security group
$Group = Get-AzureADGroup -Filter "DisplayName eq '$GroupName'"

if ($Group -ne $null) {
    # Read the CSV file and add users to the security group
    $UserList = Import-Csv -Path $CsvFilePath

    foreach ($User in $UserList) {
        $UserUPN = $User.UPN
        $UserObject = Get-AzureADUser -ObjectId $UserUPN

        if ($UserObject -ne $null) {
            Add-AzureADGroupMember -ObjectId $Group.ObjectId -RefObjectId $UserObject.ObjectId
            Write-Host "Added $UserUPN to $GroupName"
        } else {
            Write-Host "User with UPN $UserUPN not found."
        }
    }
} else {
    Write-Host "Security group $GroupName not found."
}


------------------------------------------------------------

## ADD users to group##

$csvPath = "C:\Users\sysvl-samed15\Groupmember.csv"
$usersToAdd = Import-Csv -Path $csvPath

# Set the ID or name of the Azure AD group
$groupIdOrName = "933cfed6-b75d-4caa-9524-8db92760af4f"

foreach ($userEntry in $usersToAdd) {
    $userUPN = $userEntry.UPN
    
    # Retrieve the user object based on UPN
    $user = Get-AzureADUser -Filter "userPrincipalName eq '$userUPN'"

    if ($user -ne $null) {
        # Add the user to the Azure AD group
        Add-AzureADGroupMember -ObjectId $groupIdOrName -RefObjectId $user.ObjectId
        Write-Host "Added user with UPN '$userUPN' to the group."
    } else {
        Write-Host "User with UPN '$userUPN' not found in Azure AD. Please check the UPN."
    }
}


--------------------------------------------------------

##Delete groups##


$csvPath = "C:\Users\sysvl-samed15\Group_del.csv"

# Import the CSV file
$groups = Import-Csv -Path $csvPath

# Loop through each group name in the CSV file
foreach ($group in $groups) {
    # Get the group object using the group name
    $groupObject = Get-AzureADGroup -Filter "DisplayName eq '$($group.GroupName)'"
    
    # Check if the group was found
    if ($groupObject) {
        # Remove the group
        Remove-AzureADGroup -ObjectId $groupObject.ObjectId
        Write-Output "Deleted group: $($group.GroupName)"
    } else {
        Write-Output "Group not found: $($group.GroupName)"
    }
}


