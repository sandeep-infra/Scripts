

-------------------------------------------------------------


$policyDefinition = '{
  "ClaimsMappingPolicy": {
    "Version": 1,
    "IncludeBasicClaimSet": "true",
    "ClaimsSchema": [
      {
        "Source": "user",
        "ID": "onpremisessamaccountname",
        "JwtClaimType": "onpremisessamaccountname"
      },
      {
        "Source": "user",
        "ID": "givenname",
        "JwtClaimType": "givenname"
      },
      {
        "Source": "user",
        "ID": "surname",
        "JwtClaimType": "surname"
      }

    ]
  }
}'

New-AzureADPolicy -Definition $policyDefinition -DisplayName "claims" -Type "ClaimsMappingPolicy"

-------------------------------------------------------------------------------------------------------------------------------
##WITH MGGraph module:



# Connect to Microsoft Graph with required permissions
Connect-MgGraph -Scopes "Policy.ReadWrite.ApplicationConfiguration", "Application.ReadWrite.All"

# Create the claims mapping policy
$policyParams = @{
    "definition" = @('{"ClaimsMappingPolicy":{"Version":1,"IncludeBasicClaimSet":"true", "ClaimsSchema": [{"Source":"user","ID":"onPremisesSamAccountName","JwtClaimType":"onPremisesSamAccountName"}]}}')
    "displayName" = "claims"
}

$policy = Invoke-MgGraphRequest -Method POST -Uri "/beta/policies/claimsMappingPolicies" -Body $policyParams

# Assign the policy to the service principal
$servicePrincipalId = "badfae04-4c39-42be-95f5-87e4d323aa1d"
$policyId = $policy.id

$refBody = @{
    "@odata.id" = "https://graph.microsoft.com/beta/policies/claimsMappingPolicies/$policyId"
}

Invoke-MgGraphRequest -Method POST -Uri "/beta/servicePrincipals/$servicePrincipalId/claimsMappingPolicies/`$ref" -Body $refBody

##For removing the policy:

# Service Principal ID and Policy ID to remove
$servicePrincipalId = "0fac8fd4-8ce3-481f-a38a-f796ee244e3c"
$policyId = "12b86b96-b35d-4796-884c-ace8fee73a4b"  # Replace with actual Policy ID

# Remove the policy assignment
Invoke-MgGraphRequest -Method DELETE `
    -Uri "/beta/servicePrincipals/$servicePrincipalId/claimsMappingPolicies/$policyId/`$ref"

##KBs:
    #Ref: https://learn.microsoft.com/en-us/entra/identity-platform/reference-claims-customization
   # https://learn.microsoft.com/en-us/entra/identity-platform/claims-customization-powershell
    
