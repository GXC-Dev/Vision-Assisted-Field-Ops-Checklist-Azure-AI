
<# ===============================================
 Field Ops Vision Checklist 
 Author: GXC-Dev | Version: v1.3
================================================ #>

param(
  [string]$SubscriptionId = "<PUT-YOURS>",
  [string]$Location = "australiaeast",
  [string]$Env = "dev",
  [bool]$UseExistingResources = $false,

  [string]$ResourceGroup = "rg-field-ops",
  [string]$StorageAccountName = "stfieldops",
  [string]$SearchServiceName = "srchfieldops",
  [string]$CosmosAccountName = "cosfieldops",
  [string]$WebAppInfer = "app-fieldops-infer",
  [string]$WebAppRag = "app-fieldops-rag",
  [string]$WebAppReport = "app-fieldops-report"
)

$ErrorActionPreference = "Stop"

Write-Host ">>> Login & set subscription"
az account show 1>$null 2>$null; if ($LASTEXITCODE -ne 0) { az login | Out-Null }
az account set --subscription $SubscriptionId

if (-not $UseExistingResources) {
  $ResourceGroup      = "rg-field-ops-$Env"
  $StorageAccountName = "st$($Env)$(Get-Random)"
  $SearchServiceName  = "srch$($Env)$(Get-Random)"
  $CosmosAccountName  = "cos$($Env)$(Get-Random)"
  $WebAppInfer        = "app-infer-$Env-$(Get-Random)"
  $WebAppRag          = "app-rag-$Env-$(Get-Random)"
  $WebAppReport       = "app-report-$Env-$(Get-Random)"

  Write-Host ">>> Creating resource group and deploying Bicep..."
  az group create -n $ResourceGroup -l $Location | Out-Null

  az deployment group create `
    -g $ResourceGroup `
    -f ./deploy/main.bicep `
    -p location=$Location `
       storageAccountName=$StorageAccountName `
       searchServiceName=$SearchServiceName `
       cosmosAccountName=$CosmosAccountName `
       webAppInfer=$WebAppInfer `
       webAppRag=$WebAppRag `
       webAppReport=$WebAppReport | Out-Null
}

Write-Host ">>> Fetching endpoints"
$ST_CONN = az storage account show-connection-string -g $ResourceGroup -n $StorageAccountName --query connectionString -o tsv
$SEARCH_ENDPOINT = "https://" + (az search service show -g $ResourceGroup -n $SearchServiceName --query "hostName" -o tsv)
$SEARCH_ADMIN_KEY = az search admin-key show -g $ResourceGroup -n $SearchServiceName --query "primaryKey" -o tsv

'{"AZURE_STORAGE_CONNECTION_STRING":"'+$ST_CONN+'","SEARCH_ENDPOINT":"'+$SEARCH_ENDPOINT+'","SEARCH_ADMIN_KEY":"'+$SEARCH_ADMIN_KEY+'"}' | Out-File -Encoding utf8 ./deploy/local.settings.json

Write-Host "`n✅ Deployed RG: $ResourceGroup"
Write-Host "   Storage:   $StorageAccountName"
Write-Host "   Search:    $SearchServiceName"
Write-Host "   Cosmos:    $CosmosAccountName"
Write-Host "   Web (infer/rag/report): $WebAppInfer / $WebAppRag / $WebAppReport"
