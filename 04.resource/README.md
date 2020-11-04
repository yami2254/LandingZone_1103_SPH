# ResourceGroup, vnet, subnet 생성

## ARM Template을 활용하여 ResourceGroup 생성 script

```
az deployment sub create `
  --name CreateResourceGroup `
  --location koreacentral `
  --template-file rg_template.json `
  --parameters rg_parameters.json
```

## 자동화 범위

기존에 정의된 naming role에 따라 생성된 구독에  ResourceGroup, vnet, subnet 생성 합니다.
 
## Parameters 설정

새로운 리소스 생성을 위해 설정된 내용을 입력합니다.

- group : <부서  또는  영역>
- env : <환경>
- location : <리전>
- service : <기능  또는  애플리케이션  명>
- rgTags : <태그>
- tags : <태그>

```json
{
	"$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
	"contentVersion": "1.0.0.0",
	"parameters": {
		"group": {
			"value": "landingzone"
		},
		"env": {
			"value": "dev"
		},
		"location": {
			"value": "koreacentral"
		},
		"service": {
			"value": "nugu"
		},
		"rgTags": {
			"value": {
				"env": "dev"
			}
		},
		"vnetInfo": {
			"value": [
				{
					"addressPrefixes": [
						"10.0.0.0/16"
					],
					"subnets": [
						{
							"addressPrefix": "10.0.0.0/24"
						},
						{
							"addressPrefix": "10.0.1.0/24"
						}
					],
					"tags": {
						"env": "dev"
					}
				}
			]
		}
	}
}
```