$depTime = Get-Date -Format "MMddHHmm"
az deployment sub create `
  --name "CreateResourceGroup_$depTime" `
  --location koreacentral `
  --template-file rg_template.json `
  --parameters rg_parameters.json