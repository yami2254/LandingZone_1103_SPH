param ($env)

. ../env.ps1 $env

if ($env -in 'prd', 'stg') {
    az account set --subscription $subName
}

foreach($managementGroupId in $managementGroupIds) {
  $ap = az policy assignment list --scope "/providers/Microsoft.Management/managementGroups/$managementGroupId/" | ConvertFrom-Json

  $parameterFilename = "policy_parameters_$managementGroupId.json" -replace 'LZ_', ''

  $policy_parameters = Get-Content "./$parameterFilename" | ConvertFrom-Json  
  $p = $policy_parameters.parameters.customPolicyDefinitions.value.name + $policy_parameters.parameters.policyDefinitions.value.name 

  $dp = $ap.name | ? {$_ -notin $p}

  foreach($policy in $dp) {
    echo "az policy assignment delete --name $policy --scope /providers/Microsoft.Management/managementGroups/$managementGroupId/"
    az policy assignment delete --name $policy --scope "/providers/Microsoft.Management/managementGroups/$managementGroupId/"
  }
  
  $envParams = @{
    'storageId' = $storageId;
    'storageAccountId' = $storageAccountId;
  }

  $envParamsString = $envParams | ConvertTo-Json -Compress
  $envParamsString = $envParamsString -replace '"', "'"
  
  $depTime = Get-Date -Format "MMddHHmm"
  az deployment mg create `
    --name "InitPolicyAssignment_$depTime" `
    --template-file policy_template.json `
    --parameters $parameterFilename managementGroupId=$managementGroupId env=$envParamsString `
    --management-group-id $managementGroupId `
    --location koreacentral
}