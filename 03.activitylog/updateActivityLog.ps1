param ($env)

. ../env.ps1 $env

if ($env -in 'prd', 'stg') {
    az account set --subscription $subName
}

#$subs = az account list | ConvertFrom-Json
$subs = az account management-group show --name "$managementGroupName" -e -r | ConvertFrom-Json | Get-Children-Subscriptions

foreach($sub in $subs) {
    Write-Output "az account set --subscription $($sub.name)"
    az account set --subscription $sub.name
    $al= (az monitor diagnostic-settings list --resource="$($sub.id)" | ConvertFrom-Json).value.length

    $depTime = Get-Date -Format "MMddHHmm"
    if( $al -eq 0 ) {
        az deployment sub create `
            --name "InitActivityLogSetting_$depTime" `
            --location koreacentral `
            --template-file log_template.json `
            --parameters log_parameters.json storageAccountId=$storageAccountId
    } else {
        Write-Output "sub ($sub) already setted."
    }
}