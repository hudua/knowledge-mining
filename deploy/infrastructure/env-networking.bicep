param location string = resourceGroup().location
param vnet string
param appServiceIPRange string

var subnetAppServiceName = 'appServiceSubnet'

resource VNET 'Microsoft.Network/virtualNetworks@2021-02-01' existing  = {
  name: vnet
}

resource appServiceSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: subnetAppServiceName
  parent: VNET
  properties: {
    addressPrefix: appServiceIPRange
      delegations: [
            {
              name: 'appservice-serverfarm'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
    ]
    
  }
}

