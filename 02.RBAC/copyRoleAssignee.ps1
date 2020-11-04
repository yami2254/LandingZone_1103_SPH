param ($sourceRole, $destinationRole, $subscriptionId)

if($subscriptionId) {
    Write-Output "az account set --subscription=$subscriptionId"
    az account set --subscription="$subscriptionId"
} else {
    $subid = (az account show | ConvertFrom-Json).id
    Write-Output "account ID($subid)"
    az account show
}

$users =  az role assignment list --role="$sourceRole" | 
  ConvertFrom-json | 
    Where-Object {($_.principalType -eq 'User') -or ($_.principalType -eq 'Group')} 

foreach($user_pi in $users.principalId) {
  Write-Output "az role assignment create --role '$destinationRole' --assignee $user_pi"
  az role assignment create --role "$destinationRole" --assignee "$user_pi"
}