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


##Mggraph module

$TenantID = "dbd89e6f-09ec-40c1-bf9d-c240aa470657"
$GraphAppId = "00000003-0000-0000-c000-000000000000"
$DisplayNameOfMSI = "uami-azacc-test"
$PermissionNames = @("Application.Read.All", "User.Read.All")

Connect-MgGraph -TenantId $TenantID -Scopes "AppRoleAssignment.ReadWrite.All", "Application.Read.All"

$MSI = Get-MgServicePrincipal -Filter "displayName eq '$DisplayNameOfMSI'"
Start-Sleep -Seconds 10

$GraphServicePrincipal = Get-MgServicePrincipal -Filter "appId eq '$GraphAppId'"

foreach ($PermissionName in $PermissionNames) {
    $AppRole = $GraphServicePrincipal.AppRoles | Where-Object {
        $_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application"
    }

    if ($AppRole) {
        New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $MSI.Id -PrincipalId $MSI.Id `
            -ResourceId $GraphServicePrincipal.Id -AppRoleId $AppRole.Id
        Write-Host "✅ Assigned $PermissionName to $DisplayNameOfMSI"
    } else {
        Write-Host "❌ AppRole for $PermissionName not found"
    }
}

