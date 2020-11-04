param ($env)

switch ( $env )
{
    prd
    {
        $managementGroupIds = "SKT", "LZ_Core", "LZ_Divisions"
        $storageId = "/subscriptions/6024ec3f-ae7f-40a8-9deb-28e86606bcc8/resourceGroups/rg-log-archive-prd/providers/Microsoft.Storage/storageAccounts/sktsharednsgflowlogs"
        $subName = 'Landing Zone'
        $managementGroupName = 'LZ_Divisions'
        $storageAccountId = '/subscriptions/6024ec3f-ae7f-40a8-9deb-28e86606bcc8/resourceGroups/rg-log-archive-prd/providers/Microsoft.Storage/storageAccounts/sktsharedactivitylogs'
    }
    stg
    {
        $managementGroupIds = "SKT", "Core", "Divisions"
        $storageId = "/subscriptions/c2c65df4-7afd-47b6-bee9-24fcbcae3010/resourceGroups/rg-log-archive-stg/providers/Microsoft.Storage/storageAccounts/sktsharedstgnsgflowlogs"
        $subName = 'Landing Zone Staging'
        $managementGroupName = 'Divisions'
        $storageAccountId = '/subscriptions/c2c65df4-7afd-47b6-bee9-24fcbcae3010/resourceGroups/rg-log-archive-stg/providers/Microsoft.Storage/storageAccounts/sktsharedstgactivitylogs'
    }
    dev
    {
        Write-Output "Do Nothing."
        $managementGroupName = 'rootmgmt'
    }
    default
    {
        throw "Invalid Parameter Excpetion. (env)"
    }
}

function Get-Children-Subscriptions {

    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        $ManagementGroup
    )

    $subs = @()

    foreach ($child in $ManagementGroup.children) {
        if($child.type -eq '/providers/Microsoft.Management/managementGroups') {
            $subs += Get-Children-Subscriptions $child
        } elseif ($child.type -eq '/subscriptions') {
            $subs += $child
        }
    }

    return $subs
}