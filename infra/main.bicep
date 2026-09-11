@description('Linux App Service Plan only. Individual apps deploy onto this plan later.')

param location string
param appServicePlanName string
param skuName string

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: 'Basic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

output appServicePlanName string = plan.name
output appServicePlanId string = plan.id
