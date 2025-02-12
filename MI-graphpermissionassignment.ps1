$TenantID="a33c6ac4-a52e-45c5-af07-b972df9bd004"

$GraphAppId = "00000003-0000-0000-c000-000000000000"

$DisplayNameOfMSI="ap-msrpdppmmetrics-prod-app"

$PermissionName = "AdministrativeUnit.Read.All"

#Connect-AzureAD

 
 #AdministrativeUnit.Read.All
#Application.Read.All
#Group.Read.All
#User.Read.All


 

#Connect-AzureAD -TenantId $TenantID

$MSI = (Get-AzureADServicePrincipal -Filter "displayName eq '$DisplayNameOfMSI'")

Start-Sleep -Seconds 10

$GraphServicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$GraphAppId'"

$AppRole = $GraphServicePrincipal.AppRoles | `

Where-Object {$_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application"}

New-AzureAdServiceAppRoleAssignment -ObjectId $MSI.ObjectId -PrincipalId $MSI.ObjectId `

-ResourceId $GraphServicePrincipal.ObjectId -Id $AppRole.Id

---------------------------------------------------------------------------


$TenantID = "a33c6ac4-a52e-45c5-af07-b972df9bd004"
$GraphAppId = "00000003-0000-0000-c000-000000000000"
$DisplayNameOfMSI = "uami-rangegpt-rbac-conversational-cbrs"
$PermissionNames = @("User.Read.All","GroupMember.Read.All")



$MSI = Get-AzureADServicePrincipal -Filter "displayName eq '$DisplayNameOfMSI'"
Start-Sleep -Seconds 10

$GraphServicePrincipal = Get-AzureADServicePrincipal -Filter "appId eq '$GraphAppId'"

foreach ($PermissionName in $PermissionNames) {
    $AppRole = $GraphServicePrincipal.AppRoles | `
        Where-Object { $_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application" }

    New-AzureAdServiceAppRoleAssignment -ObjectId $MSI.ObjectId -PrincipalId $MSI.ObjectId `
        -ResourceId $GraphServicePrincipal.ObjectId -Id $AppRole.Id
}



