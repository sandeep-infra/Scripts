Connect-AzureAD

New-AzureADPolicy -Definition @('{"ClaimsMappingPolicy":{"Version":1,"IncludeBasicClaimSet":"true", "ClaimsSchema": [{"Source":"user","ID":"onPremisesSamAccountName","JwtClaimType":"onPremisesSamAccountName"}]}}') -DisplayName "claims" -Type "ClaimsMappingPolicy"
 
Add-AzureADServicePrincipalPolicy -Id "0fac8fd4-8ce3-481f-a38a-f796ee244e3c" -RefObjectId "12b86b96-b35d-4796-884c-ace8fee73a4b"

Add-AzureADServicePrincipalPolicy -Id "ServicePrincipalID(Ent App)" -RefObjectId "PolicyID

Remove-AzureADServicePrincipalPolicy -Id "0fac8fd4-8ce3-481f-a38a-f796ee244e3c" -PolicyId "PolicyIdOfTheExistingPolicy"


Get-AzureADServicePrincipalPolicy -Id "0fac8fd4-8ce3-481f-a38a-f796ee244e3c"

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
