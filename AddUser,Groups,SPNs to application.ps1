$TenantId = "tenantid"
$ClientId = "cid"
$ClientSecret = "clientsecret"| ConvertTo-SecureString -AsPlainText -Force

# Connect to Microsoft Graph
$Credential = New-Object System.Management.Automation.PSCredential($ClientId, $ClientSecret)
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $Credential


$enterpriseAppId = "b8ad91c3-aa6a-46ef-a232-d26d8616f02e" #enterprise app to which the app/group/user should be added
$servicePrincipalId = "34e31e15-a0d1-4bbb-8082-02673400eaf0" #ObjectId of the application which should be added to above enterprise app
$appRoleId = "roleid" (#RoleID from the enterprise app)


New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipalId -BodyParameter @{
     "PrincipalId" = $servicePrincipalId
    "ResourceId" = $enterpriseAppId
    "AppRoleId" = $appRoleId
}
   
