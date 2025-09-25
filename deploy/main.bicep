
param location string
param storageAccountName string
param searchServiceName string
param cosmosAccountName string
param webAppInfer string
param webAppRag string
param webAppReport string

module storage 'modules/storage.bicep' = {
  name: 'storage'
  params: { location: location, name: storageAccountName }
}

module search 'modules/search.bicep' = {
  name: 'search'
  params: { location: location, name: searchServiceName }
}

module cosmos 'modules/cosmos.bicep' = {
  name: 'cosmos'
  params: { location: location, name: cosmosAccountName }
}

module infer 'modules/webapp.bicep' = {
  name: 'infer'
  params: { location: location, name: webAppInfer }
}
module rag 'modules/webapp.bicep' = {
  name: 'rag'
  params: { location: location, name: webAppRag }
}
module report 'modules/webapp.bicep' = {
  name: 'report'
  params: { location: location, name: webAppReport }
}
