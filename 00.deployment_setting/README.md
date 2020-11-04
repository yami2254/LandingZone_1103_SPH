# ARM 템플릿 및 Azure CLI를 사용하여 리소스 배포

이 문서에서는 Azure Resource Manager 템플릿 (ARM 템플릿)과 함께 Azure CLI를 사용 하 여 Azure에 리소스를 배포 하는 방법을 설명 합니다.  Azure 솔루션 배포 및 관리 개념을 잘 모르는 경우  [템플릿 배포 개요](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/overview)를 참조 하세요.

Azure CLI 버전 2.2.0에서 배포 명령이 변경 되었습니다.  이 문서의 예제에는 Azure CLI 버전 2.2.0 이상이 필요 합니다.

이 샘플을 실행하려면 최신 버전의  [Azure CLI](https://docs.microsoft.com/ko-kr/cli/azure/install-azure-cli)를 설치합니다.  시작하려면  `az login`을 실행하여 Azure와 연결합니다.

Azure CLI 샘플은  `bash`  셸용으로 작성됩니다.  Windows PowerShell 또는 명령 프롬프트에서 이 샘플을 실행하려면 스크립트의 요소를 변경해야 할 수도 있습니다.

Azure CLI가 설치되어 있지 않으면  [Cloud Shell](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#deploy-template-from-cloud-shell)을 사용할 수 있습니다.

## [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#deployment-scope)배포 범위

리소스 그룹, 구독, 관리 그룹 또는 테 넌 트에 대 한 배포를 대상으로 지정할 수 있습니다.  대부분의 경우 리소스 그룹에 대 한 배포를 대상으로 합니다.  더 큰 범위에서 정책 및 역할 할당을 적용 하려면 구독, 관리 그룹 또는 테 넌 트 배포를 사용 합니다.  구독에 배포 하는 경우 리소스 그룹을 만들고 여기에 리소스를 배포할 수 있습니다.

배포의 범위에 따라 다른 명령을 사용합니다.

-   **리소스 그룹**에 배포 하려면  [az deployment group create](https://docs.microsoft.com/ko-kr/cli/azure/deployment/group#az-deployment-group-create)를 사용 합니다.
    
    Azure CLI복사
    
    사용해 보세요.
    
    ```
    az deployment group create --resource-group <resource-group-name> --template-file <path-to-template>
    
    ```
    
-   **구독**에 배포 하려면  [az deployment sub create](https://docs.microsoft.com/ko-kr/cli/azure/deployment/sub#az-deployment-sub-create)를 사용 합니다.
    
    Azure CLI복사
    
    사용해 보세요.
    
    ```
    az deployment sub create --location <location> --template-file <path-to-template>
    
    ```
    
    구독 수준 배포에 대한 자세한 내용은  [구독 수준에서 리소스 그룹 및 리소스 만들기](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-to-subscription)를 참조하세요.
    
-   **관리 그룹**에 배포 하려면  [az deployment mg create](https://docs.microsoft.com/ko-kr/cli/azure/deployment/mg#az-deployment-mg-create)를 사용 합니다.
    
    Azure CLI복사
    
    사용해 보세요.
    
    ```
    az deployment mg create --location <location> --template-file <path-to-template>
    
    ```
    
    관리 그룹 수준 배포에 대한 자세한 내용은  [관리 그룹 수준에서 리소스 만들기](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-to-management-group)를 참조하세요.
    
-   **테 넌 트**에 배포 하려면  [az deployment tenant create](https://docs.microsoft.com/ko-kr/cli/azure/deployment/tenant#az-deployment-tenant-create)를 사용 합니다.
    
    Azure CLI복사
    
    사용해 보세요.
    
    ```
    az deployment tenant create --location <location> --template-file <path-to-template>
    
    ```
    
    테넌트 수준 배포에 대한 자세한 내용은  [테넌트 수준에서 리소스 만들기](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-to-tenant)를 참조하세요.
    

이 문서의 예제에서는 리소스 그룹 배포를 사용합니다.

## [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#deploy-local-template)로컬 템플릿 배포

Azure에 리소스를 배포할 때 다음을 수행합니다.

1.  Azure 계정에 로그인
2.  배포된 리소스에 대한 컨테이너 역할을 하는 리소스 그룹을 만듭니다.  리소스 그룹의 이름은 영숫자, 마침표, 밑줄, 하이픈 및 괄호만 포함할 수 있습니다.  최대 90자까지 가능합니다.  마침표로 끝날 수 없습니다.
3.  만들 리소스를 정의 하는 템플릿을 리소스 그룹에 배포 합니다.

템플릿에는 템플릿 배포를 사용자 지정할 수 있도록 하는 매개 변수가 포함될 수 있습니다.  예를 들어 특정 환경(예: 개발, 테스트 및 프로덕션)에 맞게 조정되는 값을 제공할 수 있습니다.  샘플 템플릿은 스토리지 계정 SKU에 대한 매개 변수를 정의합니다.

다음 예제에서는 리소스 그룹을 만들고 로컬 컴퓨터에서 템플릿을 배포합니다.

Azure CLI복사

사용해 보세요.

```
az group create --name ExampleGroup --location "Central US"
az deployment group create \
  --name ExampleDeployment \
  --resource-group ExampleGroup \
  --template-file storage.json \
  --parameters storageAccountType=Standard_GRS

```

배포가 완료될 때까지 몇 분 정도 걸릴 수 있습니다.  완료되면 결과가 포함된 메시지가 표시됩니다.

출력복사

```
"provisioningState": "Succeeded",

```

## [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#deployment-name)배포 이름

앞의 예제에서는 배포의 이름을 지정  `ExampleDeployment`  했습니다.  배포 이름을 제공 하지 않으면 템플릿 파일의 이름이 사용 됩니다.  예를 들어 이라는 템플릿을 배포 하  `azuredeploy.json`  고 배포 이름을 지정 하지 않는 경우 배포의 이름은  `azuredeploy`  입니다.

배포를 실행할 때마다 배포 이름으로 리소스 그룹의 배포 기록에 항목이 추가 됩니다.  다른 배포를 실행 하 고 동일한 이름을 지정 하는 경우 이전 항목이 현재 배포로 바뀝니다.  배포 기록에서 고유한 항목을 유지 하려면 각 배포에 고유한 이름을 지정 합니다.

고유 이름을 만들려면 난수를 할당 하면 됩니다.

Azure CLI복사

사용해 보세요.

```
deploymentName='ExampleDeployment'$RANDOM

```

또는 날짜 값을 추가 합니다.

Azure CLI복사

사용해 보세요.

```
deploymentName='ExampleDeployment'$(date +"%d-%b-%Y")

```

동일한 배포 이름을 가진 동일한 리소스 그룹에 동시 배포를 실행 하는 경우 마지막 배포만 완료 됩니다.  완료 되지 않은 동일한 이름의 배포는 마지막 배포로 대체 됩니다.  예를 들어 라는 저장소 계정을 배포 하는 라는 배포를 실행 하는 경우 동일한에 이라는  `newStorage`  `storage1`  저장소 계정을 배포 하는 이라는 다른 배포를 실행 하는 경우  `newStorage`  `storage2`  저장소 계정을 하나만 배포 합니다.  결과 저장소 계정의 이름은  `storage2`  입니다.

그러나 이라는 이름의 저장소 계정을 배포 하는 라는 배포를 실행 하는 경우,가 완료 된 직후에 라는  `newStorage`  `storage1`  저장소 계정을 배포 하는 이라는 다른 배포를 실행 하면  `newStorage`  `storage2`  두 개의 저장소 계정이 있습니다.  하나는 이름이이  `storage1`  고 다른 하나는 이름이로 지정 됩니다  `storage2`  .  그러나 배포 기록에는 하나의 항목만 있습니다.

각 배포에 고유한 이름을 지정 하는 경우 충돌 없이 동시에 실행할 수 있습니다.  이라는 저장소 계정을 배포 하는 라는 배포를 실행 하는 경우 동시에 라는  `newStorage1`  `storage1`  저장소 계정을 배포 하는 이라는 다른 배포를 실행 하는 경우  `newStorage2`  `storage2`  두 개의 저장소 계정 및 두 개의 항목이 배포 기록에 있습니다.

동시 배포와의 충돌을 방지 하 고 배포 기록에서 고유한 항목을 확인 하려면 각 배포에 고유한 이름을 지정 합니다.

## [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#deploy-remote-template)원격 템플릿 배포

ARM 템플릿을 로컬 컴퓨터에 저장 하는 대신 외부 위치에 저장 하는 것이 좋습니다.  원본 제어 리포지토리(예: GitHub)에 템플릿을 저장할 수 있습니다.  또는 조직에서 공유 액세스에 대한 Azure Storage 계정에 저장할 수 있습니다.

외부 템플릿을 배포하려면  **template-uri**  매개 변수를 사용합니다.  예제의 URI를 사용하여 GitHub에서 샘플 템플릿을 배포합니다.

Azure CLI복사

사용해 보세요.

```
az group create --name ExampleGroup --location "Central US"
az deployment group create \
  --name ExampleDeployment \
  --resource-group ExampleGroup \
  --template-uri "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-storage-account-create/azuredeploy.json" \
  --parameters storageAccountType=Standard_GRS

```

앞의 예제에서는 템플릿에 중요한 데이터가 포함되어 있지 않으므로 대부분의 시나리오에 적합한 이 템플릿에 대해 공개적으로 액세스할 수 있는 URI가 필요합니다.  중요한 데이터(예: 관리자 암호)를 지정해야 하는 경우 해당 값을 안전한 매개 변수로 전달합니다.  그러나 템플릿에 공개적으로 액세스할 수 있도록 하지 않으려면 프라이빗 스토리지 컨테이너에 저장하여 보호할 수 있습니다.  SAS(공유 액세스 서명) 토큰이 필요한 템플릿을 배포하는 데 관한 내용은  [SAS 토큰으로 프라이빗 템플릿 배포](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/secure-template-with-sas-token)를 참조하세요.

## [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#deploy-template-spec)템플릿 사양 배포

로컬 또는 원격 템플릿을 배포 하는 대신  [템플릿 사양을](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/template-specs)만들 수 있습니다. 템플릿 사양은 ARM 템플릿을 포함 하는 Azure 구독에 있는 리소스입니다.  이를 통해 조직의 사용자와 쉽게 템플릿을 안전 하 게 공유할 수 있습니다.  RBAC (역할 기반 액세스 제어)를 사용 하 여 템플릿 사양에 대 한 액세스 권한을 부여 합니다. 이 기능은 현재 미리 보기 상태입니다.

다음 예에서는 템플릿 사양을 만들고 배포 하는 방법을 보여 줍니다. 이러한 명령은  [미리 보기에 등록 한 경우에](https://aka.ms/templateSpecOnboarding)만 사용할 수 있습니다.

먼저 ARM 템플릿을 제공 하 여 템플릿 사양을 만듭니다.

Azure CLI복사

```
az ts create \
  --name storageSpec \
  --version "1.0" \
  --resource-group templateSpecRG \
  --location "westus2" \
  --template-file "./mainTemplate.json"

```

그런 다음 템플릿 사양의 ID를 가져와서 배포 합니다.

Azure CLI복사

```
id = $(az ts show --name storageSpec --resource-group templateSpecRG --version "1.0" --query "id")

az deployment group create \
  --resource-group demoRG \
  --template-spec $id

```

자세한 내용은  [Azure Resource Manager 템플릿 사양 (미리 보기)](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/template-specs)을 참조 하세요.

## [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#preview-changes)변경 내용 미리 보기

템플릿을 배포 하기 전에 템플릿이 사용자 환경에 적용 되는 변경 내용을 미리 볼 수 있습니다.  [가상 작업](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/template-deploy-what-if)  을 사용 하 여 템플릿이 필요한 변경을 수행 하는지 확인 합니다.  이 경우에서 템플릿의 오류도 확인 합니다.

## [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#deploy-template-from-cloud-shell)Cloud Shell에서 템플릿 배포

[Cloud Shell](https://docs.microsoft.com/ko-kr/azure/cloud-shell/overview)을 사용하여 템플릿을 배포할 수 있습니다.  외부 템플릿을 배포하려면 모든 외부 배포에서와 정확히 동일한 형식으로 템플릿의 URI를 입력합니다.  로컬 템플릿을 배포하려면 먼저 Cloud Shell용 스토리지 계정에 템플릿을 로드해야 합니다.  이 섹션에서는 Cloud Shell 계정에 템플릿을 로드한 다음 로컬 파일로 배포하는 방법을 설명합니다.  Cloud Shell을 사용해 본 적이 없다면  [Azure Cloud Shell 개요](https://docs.microsoft.com/ko-kr/azure/cloud-shell/overview)에서 Cloud Shell 설정 방법을 참조하세요.

1.  [Azure Portal](https://portal.azure.com/)에 로그인합니다.
    
2.  Cloud Shell 리소스 그룹을 선택합니다.  이름 패턴은  `cloud-shell-storage-<region>`입니다.
    
    ![리소스 그룹 선택](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/select-cloud-shell-resource-group.png)
    
3.  Cloud Shell용 스토리지 계정을 선택합니다.
    
    ![스토리지 계정 선택](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/select-storage.png)
    
4.  **Blob**을 선택합니다.
    
    ![Blob 선택](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/select-blobs.png)
    
5.  **+컨테이너**를 선택합니다.
    
    ![컨테이너 추가](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/add-container.png)
    
6.  컨테이너에 이름과 액세스 수준을 지정합니다.  이 문서의 샘플 템플릿에는 중요한 정보가 없으므로 익명 읽기 액세스를 허용합니다.  **확인**을 선택합니다.
    
    ![컨테이너 값 제공](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/provide-container-values.png)
    
7.  만든 컨테이너를 선택합니다.
    
    ![새 컨테이너 선택](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/select-container.png)
    
8.  **업로드**를 선택합니다.
    
    ![Blob 업로드](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/upload-blob.png)
    
9.  템플릿을 찾아서 업로드합니다.
    
    ![파일 업로드](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/find-and-upload-template.png)
    
10.  업로드된 후 템플릿을 선택합니다.
    
    ![새 템플릿 선택](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/select-new-template.png)
    
11.  URL을 복사합니다.
    
    ![URL 복사](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/copy-url.png)
    
12.  프롬프트를 엽니다.
    
    ![Cloud Shell 열기](https://docs.microsoft.com/ko-kr/azure/includes/media/resource-manager-cloud-shell-deploy/start-cloud-shell.png)
    

Cloud Shell에서 다음 명령을 사용합니다.

Azure CLI복사

사용해 보세요.

```
az group create --name examplegroup --location "South Central US"
az deployment group create --resource-group examplegroup \
  --template-uri <copied URL> \
  --parameters storageAccountType=Standard_GRS

```

## [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#parameters)매개 변수

매개 변수 값을 전달하려면 인라인 매개 변수 또는 매개 변수 파일을 사용할 수 있습니다.

### [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#inline-parameters)인라인 매개 변수입니다.

인라인 매개 변수를 전달하려면  `parameters`에 값을 제공합니다.  예를 들어 Bash 셸에서 문자열 및 배열을 템플릿에 전달하려면 다음을 사용합니다.

Azure CLI복사

사용해 보세요.

```
az deployment group create \
  --resource-group testgroup \
  --template-file demotemplate.json \
  --parameters exampleString='inline string' exampleArray='("value1", "value2")'

```

Windows 명령 프롬프트 (CMD) 또는 PowerShell을 사용 하 여 Azure CLI를 사용 하는 경우 배열을 형식으로 전달  `exampleArray="['value1','value2']"`  합니다.

파일의 콘텐츠를 가져와서 해당 콘텐츠를 인라인 매개 변수로 제공할 수도 있습니다.

Azure CLI복사

사용해 보세요.

```
az deployment group create \
  --resource-group testgroup \
  --template-file demotemplate.json \
  --parameters exampleString=@stringContent.txt exampleArray=@arrayContent.json

```

파일에서 매개 변수 값을 가져오면 구성 값을 제공해야 하는 경우에 유용합니다.  예를 들어,  [Linux 가상 머신에 대한 Cloud-Init 값](https://docs.microsoft.com/ko-kr/azure/virtual-machines/linux/using-cloud-init)을 제공할 수 있습니다.

arrayContent.json 형식은 다음과 같습니다.

JSON복사

```
[
    "value1",
    "value2"
]

```

예를 들어 태그를 설정 하기 위해 개체를 전달 하려면 JSON을 사용 합니다.  예를 들어 템플릿에 다음과 같은 매개 변수가 포함 될 수 있습니다.

JSON복사

```
    "resourceTags": {
      "type": "object",
      "defaultValue": {
        "Cost Center": "IT Department"
      }
    }

```

이 경우 다음 Bash 스크립트와 같이 JSON 문자열을 전달 하 여 매개 변수를 설정할 수 있습니다.

Bash복사

```
tags='{"Owner":"Contoso","Cost Center":"2345-324"}'
az deployment group create --name addstorage  --resource-group myResourceGroup \
--template-file $templateFile \
--parameters resourceName=abcdef4556 resourceTags="$tags"

```

개체에 전달 하려는 JSON 주위에 큰따옴표를 사용 합니다.

### [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#parameter-files)매개 변수 파일

매개 변수를 스크립트에 인라인 값으로 전달하는 것보다는, 매개 변수 값이 포함된 JSON 파일을 사용하는 것이 더 쉬울 수 있습니다.  매개 변수 파일은 로컬 파일이어야 합니다.  외부 매개 변수 파일은 Azure CLI에서 사용할 수 없습니다.

매개 변수 파일에 대한 자세한 내용은  [Resource Manager 매개 변수 파일 만들기](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/parameter-files)를 참조하세요.

로컬 매개 변수 파일을 전달하려면  `@`을 사용하여 storage.parameters.json이라는 로컬 파일을 지정합니다.

Azure CLI복사

사용해 보세요.

```
az deployment group create \
  --name ExampleDeployment \
  --resource-group ExampleGroup \
  --template-file storage.json \
  --parameters @storage.parameters.json

```

## [](https://docs.microsoft.com/ko-kr/azure/azure-resource-manager/templates/deploy-cli#handle-extended-json-format)확장 JSON 형식 처리

2.3.0 또는 이전 버전의 Azure CLI을 사용 하 여 여러 줄 문자열이 나 주석이 포함 된 템플릿을 배포 하려면 스위치를 사용 해야 합니다  `--handle-extended-json-format`  .  예를 들면 다음과 같습니다.

JSON복사

```
{
  "type": "Microsoft.Compute/virtualMachines",
  "apiVersion": "2018-10-01",
  "name": "[variables('vmName')]", // to customize name, change it in variables
  "location": "[
    parameters('location')
    ]", //defaults to resource group location
  /*
    storage account and network interface
    must be deployed first
  */
  "dependsOn": [
    "[resourceId('Microsoft.Storage/storageAccounts/', variables('storageAccountName'))]",
    "[resourceId('Microsoft.Network/networkInterfaces/', variables('nicName'))]"
  ],

```
