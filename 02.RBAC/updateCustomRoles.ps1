param ($env)

$subName = $null

. ../env.ps1 $env

if ($env -in 'prd', 'stg') {
    az account set --subscription $subName
}

#$subs = az account list | ConvertFrom-Json
$subs = az account management-group show --name "$managementGroupName" -e -r | ConvertFrom-Json | Get-Children-Subscriptions

$subIdsStr = "['" + ($subs.id -join "','") + "']"

$depTime = Get-Date -Format "MMddHHmm"
az deployment sub create `
--name "InitCustomRoleCreate_$depTime" `
--location koreacentral `
--template-file rbac_template.json `
--parameters rbac_parameters.json assignableScopes=$subIdsStr