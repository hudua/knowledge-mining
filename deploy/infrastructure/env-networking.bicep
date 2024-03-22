param location string = resourceGroup().location
param vnetName string
param appServiceIPRange string
param subnetAppServiceName string

resource VNET 'Microsoft.Network/virtualNetworks@2021-02-01' existing  = {
  name: vnetName
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

