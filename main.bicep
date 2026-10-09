@description('Base name for the App Service and its plan. App Service names must be globally unique.')
param appName string

@description('Deployment environment.')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string = 'dev'

@description('Azure region in which to deploy the resources.')
param location string = resourceGroup().location

var appServiceName = '${appName}-${environment}'
var planName = '${appServiceName}-plan'

// Linux App Service plan using the lowest Linux-compatible Free SKU.
resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: planName
  location: location
  kind: 'linux'
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  properties: {
    reserved: true
  }
}

// Linux web app configured to accept HTTPS traffic only.
resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: appServiceName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
    }
  }
}

resource lang 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: 'lang-${appName}-${environment}'
  location: location
  kind: 'TextAnalytics'
  sku: { name: 'F0' }
  properties: {
    customSubDomainName: 'lang-${appName}-${environment}'
    publicNetworkAccess: 'Enabled'
  }
}
output languageEndpoint string = lang.properties.endpoint
