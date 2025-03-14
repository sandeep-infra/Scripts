Connect-MgGraph -Scopes "Application.ReadWrite.All", "AppRoleAssignment.ReadWrite.All"

Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Property AppRoles | Select -ExpandProperty appRoles | Out-GridView

$params = @{
  "PrincipalId" ="d5bbba5c-d119-40d1-b571-51e9a0c61831" 
  "ResourceId" = "8155a763-169a-4df6-9cbc-139d00343a3b"
  "AppRoleId" = "3727fa0a-96f6-4610-a4e8-09d2610ca233"
}

New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId 'd5bbba5c-d119-40d1-b571-51e9a0c61831' -BodyParameter $params | 
  Format-List Id, AppRoleId, CreatedDateTime, PrincipalDisplayName, PrincipalId, PrincipalType, ResourceDisplayName


--------------------------------------------------------------

##Adding delegated permissions to SP##

Connect-MgGraph -Scopes "Application.ReadWrite.All", "DelegatedPermissionGrant.ReadWrite.All"

Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Property Oauth2PermissionScopes | Select -ExpandProperty Oauth2PermissionScopes | fl

$params = @{

"ClientId" = "ad272aac-519d-4397-91af-f62b9a506462"
"ConsentType" = "AllPrincipals"
"ResourceId" = "e0d62f1e-6093-4187-87d1-b71492fa19ee"
"Scope" = "Sites.FullControl.All"
}

New-MgOauth2PermissionGrant -BodyParameter $params | 
Format-List Id, ClientId, ConsentType, ResourceId, Scope

#Check granted perms

Get-MgOauth2PermissionGrant -Filter "clientId eq '4dca8115-268c-4b7c-889a-a791038d42e8' and consentType eq 'AllPrincipals'"

-----------------------------------------------------

Connect-MgGraph -Scopes "Application.ReadWrite.All", "AppRoleAssignment.ReadWrite.All"

Get-MgServicePrincipal -Filter "displayName eq 'Office 365 SharePoint Online'" -Property AppRoles | Select -ExpandProperty appRoles | Out-GridView

$params = @{
  "PrincipalId" ="ad272aac-519d-4397-91af-f62b9a506462" 
  "ResourceId" = "e0d62f1e-6093-4187-87d1-b71492fa19ee"
  "AppRoleId" = "5a54b8b3-347c-476d-8f8e-42d5c7424d29"
}

New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId 'ad272aac-519d-4397-91af-f62b9a506462' -BodyParameter $params | 
  Format-List Id, AppRoleId, CreatedDateTime, PrincipalDisplayName, PrincipalId, PrincipalType, ResourceDisplayName

  ----------------------------

  Connect-MgGraph -Scopes "Application.ReadWrite.All", "DelegatedPermissionGrant.ReadWrite.All"

  $params = @{
  Scope = "User.Read.All"
  }

Update-MgOauth2PermissionGrant -OAuth2PermissionGrantId 'ba9c0950-42ed-4380-9264-0ff66897415a' -BodyParameter $params
