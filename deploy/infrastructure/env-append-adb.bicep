param location string = resourceGroup().location

param vnetID string
parma databricksName string

var subnetDatabricksPublicName = 'AzureDatabricksPublic'
var subnetDatabricksPrivateName = 'AzureDatabricksPrivate'

resource databricks 'Microsoft.Databricks/workspaces@2018-04-01' = {
  name: databricksName
  location: location
  sku: {
    name: 'premium'
  }
  properties: {
managedResourceGroupId: '${subscription().id}/resourceGroups/db-rg-managed'
    parameters: {
      customVirtualNetworkId: {
        value: vnetID
      } 
      customPrivateSubnetName: {
        value: subnetDatabricksPrivateName
      }
      customPublicSubnetName: {
        value: subnetDatabricksPublicName
      }
      enableNoPublicIp: {
        value: true
      }
    }
  }
}
