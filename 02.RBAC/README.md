# Azure 사용자 지정 역할

Azure 기본 제공 역할이 조직의 특정 요구 사항을 충족하지 않는 경우  [사용자 지정 역할](https://docs.microsoft.com/ko-kr/azure/role-based-access-control/built-in-roles)을 만들면 됩니다.  기본 제공 역할과 마찬가지로 관리 그룹, 구독 및 리소스 그룹 범위에서 사용자, 그룹 및 서비스 사용자에 게 사용자 지정 역할을 할당할 수 있습니다.

동일한 Azure AD 디렉터리를 신뢰 하는 구독 간에 사용자 지정 역할을 공유할 수 있습니다.  디렉터리 당 사용자 지정 역할은  **5000**  개로 제한 됩니다.  (Azure 독일 및 Azure 중국 21Vianet의 경우 제한은 2000 사용자 지정 역할입니다.) Azure Portal, Azure PowerShell, Azure CLI 또는 REST API를 사용 하 여 사용자 지정 역할을 만들 수 있습니다.

## Azure 리소스 공급자 등록

리소스 공급자를 사용 하기 전에 Azure 구독에 대 한 리소스 공급자를 등록 해야 합니다.  이 단계에서는 리소스 공급자와 함께 작동 하도록 구독을 구성 합니다.  등록 범위는 항상 해당 구독입니다.  기본적으로 대부분의 리소스 공급자는 자동으로 등록됩니다.  그러나 일부 리소스 공급자는 수동으로 등록해야 할 수도 있습니다.

이 문서에서는 리소스 공급자의 등록 상태를 확인 하 고 필요에 따라 등록 하는 방법을 보여 줍니다.  `/register/action`리소스 공급자에 대 한 작업을 수행할 수 있는 권한이 있어야 합니다.  이 사용 권한은 참가자 및 소유자 역할에 포함 되어 있습니다.

응용 프로그램 코드는  **등록**  상태에 있는 리소스 공급자에 대 한 리소스 생성을 차단 하지 않아야 합니다.  리소스 공급자를 등록 하면 지원 되는 각 지역에 대해 작업이 개별적으로 수행 됩니다.  지역에서 리소스를 만들려면 해당 지역 에서만 등록을 완료 해야 합니다.  등록 상태에서 리소스 공급자를 차단 하지 않으면 응용 프로그램은 모든 지역이 완료 될 때까지 대기 하는 것 보다 훨씬 더 빨리 계속할 수 있습니다.

구독에서 해당 리소스 공급자의 리소스 형식이 여전히 있는 경우 리소스 공급자를 등록 취소할 수 없습니다.

### 1. Powershell

```
$arr_provider = "Microsoft.Sql", "Microsoft.DBforMariaDB", "Microsoft.DBforMySQL", "Microsoft.DBforPostgreSQL", "Microsoft.DocumentDB"

foreach($val in $arr_provider) {
	az provider register --namespace $val
}
```

### 2. Bash

```
array_provider=("Microsoft.Sql" "Microsoft.DBforMariaDB" "Microsoft.DBforMySQL" "Microsoft.DBforPostgreSQL" "Microsoft.DocumentDB")

for val in ${array_provider[@]}; do
	az provider register --namespace $val
done
```

### 3. Azure portal 
모든 리소스 공급자와 구독 등록 상태를 보려면 다음을 수행합니다.

1.  [Azure Portal](https://portal.azure.com/)에 로그인합니다.
    
2.  Azure Portal 메뉴에서  **모든 서비스**를 선택합니다.
    
    ![구독 선택](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/management/media/resource-providers-and-types/select-all-services.png)
    
3.  **모든 서비스 ** 상자에서  **구독**을 입력한 다음,  **구독**을 선택합니다.
    
4.  구독 목록에서 보려는 구독을 선택합니다.
    
5.  **리소스 공급자**를 선택하고 사용 가능한 리소스 공급자의 목록을 봅니다.
    
    ![리소스 공급자 보기](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/management/media/resource-providers-and-types/show-resource-providers.png)
    
6.  리소스 공급자를 등록하려면  **등록**을 선택합니다.  이전 스크린샷에는  **Microsoft.Blueprint**에 대한  **등록**  링크가 강조 표시되어 있습니다. 

## ARM Template을 활용하여 사용자 지정 역할 만들기

정의된 Policy를 Azure Cli와 template를 활용해 새로운 사용자 지정 역할을 생성합니다.

```
az deployment sub create `
  --name InitCustomRoleCreate `
  --location koreacentral `
  --template-file rbac_template.json `
  --parameters rbac_parameters.json
```

## 사용자 지정 역할을 만드는 단계

사용자 지정 역할을 만들려면 따라야 하는 기본 단계는 다음과 같습니다.

1.  사용자 지정 역할을 만들 방법을 결정 합니다.
    
    Azure Portal, Azure PowerShell, ARM template, Azure CLI 또는 REST API를 사용 하 여 사용자 지정 역할을 만들 수 있습니다.
    
2.  필요한 권한을 결정 합니다.
    
    사용자 지정 역할을 만들 때 사용 권한을 정의 하는 데 사용할 수 있는 작업을 알고 있어야 합니다.  작업 목록을 보려면  [Azure Resource Manager 리소스 공급자 작업](https://docs.microsoft.com/ko-kr/azure/role-based-access-control/resource-provider-operations)을 참조 하세요.  `Actions`  `NotActions`  [역할 정의](https://docs.microsoft.com/ko-kr/azure/role-based-access-control/role-definitions)의 또는 속성에 작업을 추가 합니다.  데이터 작업을 수행 하는 경우 또는 속성에 해당 작업을 추가 합니다  `DataActions`  `NotDataActions`  .
    
3.  사용자 지정 역할을 만듭니다.
    
    일반적으로 기존 기본 제공 역할로 시작한 다음, 필요에 따라 수정합니다.  가장 쉬운 방법은 Azure Portal를 사용 하는 것입니다.  Azure Portal를 사용 하 여 사용자 지정 역할을 만드는 방법에 대 한 단계는  [Azure Portal를 사용 하 여 Azure 사용자 지정 역할 만들기 또는 업데이트](https://docs.microsoft.com/ko-kr/azure/role-based-access-control/custom-roles-portal)를 참조 하세요.
    
4.  사용자 지정 역할을 테스트 합니다.
    
    사용자 지정 역할이 있으면 해당 역할을 테스트하여 예상대로 작동하는지 확인해야 합니다.  나중에 조정해야 하는 경우 사용자 지정 역할을 업데이트할 수 있습니다.