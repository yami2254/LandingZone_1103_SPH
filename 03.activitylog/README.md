# ActivityLog 설정

## ARM Template을 활용하여 ActivityLog 설정

```
az deployment sub create `
  --name InitActivityLogSetting `
  --location koreacentral `
  --template-file log_template.json `
  --parameters log_parameters.json
```

## 레거시 컬렉션 메서드

이 섹션에서는 진단 설정 전에 사용 된 활동 로그를 수집 하는 레거시 방법에 대해 설명 합니다.  이러한 방법을 사용 하는 경우 리소스 로그와 더 나은 기능 및 일관성을 제공 하는 진단 설정으로 전환 하는 것을 고려해 야 합니다.

### [](https://docs.microsoft.com/ko-kr/azure/azure-monitor/platform/activity-log#log-profiles)로그 프로필

로그 프로필은 활동 로그를 Azure storage 또는 event hubs로 전송 하는 레거시 방법입니다.  다음 절차를 사용 하 여 로그 프로필 작업을 계속 하거나 진단 설정으로 마이그레이션하기 위한 준비에서 로그 프로필을 사용 하지 않도록 설정할 수 있습니다.

1.  Azure Portal  **Azure Monitor**  메뉴에서  **활동 로그**를 선택 합니다.
    
2.  **진단 설정**을 클릭합니다.
    
    ![진단 설정](https://docs.microsoft.com/ko-kr/azure/azure-monitor/platform/media/diagnostic-settings-subscription/diagnostic-settings.png)
    
3.  레거시 환경에 대해 자주색 배너를 클릭 합니다.
    
    ![레거시 환경](https://docs.microsoft.com/ko-kr/azure/azure-monitor/platform/media/diagnostic-settings-subscription/legacy-experience.png)
    

### [](https://docs.microsoft.com/ko-kr/azure/azure-monitor/platform/activity-log#configure-log-profile-using-powershell)PowerShell을 사용 하 여 로그 프로필 구성

로그 프로필이 이미 있는 경우 먼저 기존 로그 프로필을 제거한 다음 새 로그 프로필을 만들어야 합니다.

1.  `Get-AzLogProfile`를 사용하여 로그 프로필이 있는지 확인합니다.  로그 프로필이 있는 경우  _name_  속성을 적어둡니다.
    
2.  _name_  속성의 값을 사용하여 로그 프로필을 제거하려면  `Remove-AzLogProfile`을 사용합니다.
    
    PowerShell복사
    
    ```
    # For example, if the log profile name is 'default'
    Remove-AzLogProfile -Name "default"
    
    ```
    
3.  `Add-AzLogProfile`를 사용하여 새 로그 프로필을 만듭니다.
    
    PowerShell복사
    
    ```
    Add-AzLogProfile -Name my_log_profile \
      -StorageAccountId /subscriptions/s1/resourceGroups/myrg1/providers/Microsoft.Storage/storageAccounts/my_storage \
      -serviceBusRuleId /subscriptions/s1/resourceGroups/Default-ServiceBus-EastUS/providers/Microsoft.ServiceBus/namespaces/mytestSB/authorizationrules/RootManageSharedAccessKey \
      -Location global,westus,eastus \
      -RetentionInDays 90 -Category Write,Delete,Action
    
    ```
 
    수집할 쉼표로 구분된 이벤트 범주 목록입니다.  가능한 값은  _쓰기_, _삭제_및 _동작_입니다.
    

### [](https://docs.microsoft.com/ko-kr/azure/azure-monitor/platform/activity-log#example-script)예제 스크립트

다음은 저장소 계정 및 이벤트 허브 모두에 활동 로그를 기록 하는 로그 프로필을 만드는 샘플 PowerShell 스크립트입니다.

PowerShell복사

```
# Settings needed for the new log profile
$logProfileName = "default"
$locations = (Get-AzLocation).Location
$locations += "global"
$subscriptionId = "<your Azure subscription Id>"
$resourceGroupName = "<resource group name your event hub belongs to>"
$eventHubNamespace = "<event hub namespace>"

# Build the service bus rule Id from the settings above
$serviceBusRuleId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.EventHub/namespaces/$eventHubNamespace/authorizationrules/RootManageSharedAccessKey"

# Build the storage account Id from the settings above
$storageAccountId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageAccountName"

Add-AzLogProfile -Name $logProfileName -Location $locations -ServiceBusRuleId $serviceBusRuleId

```

### [](https://docs.microsoft.com/ko-kr/azure/azure-monitor/platform/activity-log#configure-log-profile-using-azure-cli)Azure CLI를 사용 하 여 로그 프로필 구성

로그 프로필이 이미 있으면 먼저 기존 로그 프로필을 제거한 다음, 새 로그 프로필을 생성해야 합니다.

1.  `az monitor log-profiles list`를 사용하여 로그 프로필이 있는지 확인합니다.
    
2.  _name_  속성의 값을 사용하여 로그 프로필을 제거하려면  `az monitor log-profiles delete --name "<log profile name>`을 사용합니다.
    
3.  `az monitor log-profiles create`를 사용하여 새 로그 프로필을 만듭니다.
    
    Azure CLI복사
    
    사용해 보세요.
    
    ```
    az monitor log-profiles create --name "default" --location null --locations "global" "eastus" "westus" --categories "Delete" "Write" "Action"  --enabled false --days 0 --service-bus-rule-id "/subscriptions/<YOUR SUBSCRIPTION ID>/resourceGroups/<RESOURCE GROUP NAME>/providers/Microsoft.EventHub/namespaces/<EVENT HUB NAME SPACE>/authorizationrules/RootManageSharedAccessKey"
    
    ```
    
    
    수집해야 할 공백으로 구분된 이벤트 범주 목록입니다.  가능한 값은 쓰기, 삭제 및 작업입니다.
    

### [](https://docs.microsoft.com/ko-kr/azure/azure-monitor/platform/activity-log#log-analytics-workspace)Log Analytics 작업 영역

활동 로그를 Log Analytics 작업 영역으로 보내는 레거시 방법은 작업 영역 구성의 로그에 연결 하는 것입니다.

1.  Azure Portal  **Log Analytics 작업 영역**  메뉴에서 작업 영역을 선택 하 여 활동 로그를 수집 합니다.
    
2.  작업 영역 메뉴의  **작업 영역 데이터 원본**  섹션에서  **Azure 활동 로그**를 선택 합니다.
    
3.  연결 하려는 구독을 클릭 합니다.
    
    ![작업 영역](https://docs.microsoft.com/ko-kr/azure/azure-monitor/platform/media/activity-log-collect/workspaces.png)
    
4.  **연결**  을 클릭 하 여 구독의 활동 로그를 선택한 작업 영역에 연결 합니다.  구독이 다른 작업 영역에 이미 연결 되어 있는 경우 먼저  **연결 끊기**  를 클릭 하 여 연결을 끊습니다.
    
    ![작업 영역 연결](https://docs.microsoft.com/ko-kr/azure/azure-monitor/platform/media/activity-log-collect/connect-workspace.png)
    

설정을 사용 하지 않도록 설정 하려면 동일한 절차를 수행 하 고  **연결 끊기**  를 클릭 하 여 작업 영역에서 구독을 제거 합니다.

### [](https://docs.microsoft.com/ko-kr/azure/azure-monitor/platform/activity-log#data-structure-changes)데이터 구조 변경

진단 설정은  _azureactivity_  테이블의 구조에 대 한 일부 변경 내용으로 활동 로그를 보내는 데 사용 되는 레거시 방법과 동일한 데이터를 보냅니다.

다음 표의 열은 업데이트 된 스키마에서 더 이상 사용 되지 않습니다.  이러한 작업은 여전히  _azureactivity_  에 있지만 데이터는 없습니다.  이러한 열에 대 한 대체는 새로운 것은 아니지만 사용 되지 않는 열과 동일한 데이터를 포함 합니다.  서로 다른 형식 이므로이를 사용 하는 로그 쿼리를 수정 해야 할 수도 있습니다.


경우에 따라 이러한 열의 값은 모두 대문자 일 수 있습니다.  이러한 열을 포함 하는 쿼리가 있는 경우  [= ~ 연산자](https://docs.microsoft.com/ko-kr/azure/kusto/query/datatypes-string-operators)  를 사용 하 여 대/소문자를 구분 하지 않는 비교를 수행 해야 합니다.

다음 열이 업데이트 된 스키마의  _Azureactivity_  에 추가 되었습니다.

-   Authorization_d
-   Claims_d
-   Properties_d