param location string = resourceGroup().location
param vnet string
param databricksPublicIPRange string
param databricksPrivateIPRange string

var subnetDatabricksPublicName = 'AzureDatabricksPublic'
var subnetDatabricksPrivateName = 'AzureDatabricksPrivate'

resource nsgPublic 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: 'databricksPublicNSG'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound'
        properties: {
            description: 'Required for worker nodes communication within a cluster.'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'VirtualNetwork'
            access: 'Allow'
            priority: 100
            direction: 'Inbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp'
        properties: {
            description: 'Required for workers communication with Databricks Webapp.'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'AzureDatabricks'
            access: 'Allow'
            priority: 100
            direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql'
        properties: {
            description: 'Required for workers communication with Azure SQL services.'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '3306'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'Sql'
            access: 'Allow'
            priority: 101
            direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage'
        properties: {
            description: 'Required for workers communication with Azure Storage services.'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'Storage'
            access: 'Allow'
            priority: 102
            direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound'
        properties: {
            description: 'Required for worker nodes communication within a cluster.'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'VirtualNetwork'
            access: 'Allow'
            priority: 103
            direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub'
        properties: {
            description: 'Required for worker communication with Azure Eventhub services.'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '9093'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'EventHub'
            access: 'Allow'
            priority: 104
            direction: 'Outbound'
        }
      }
    ]
  }
}

resource nsgPrivate 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: 'databricksPrivateNSG'
  location: location
properties: {
    securityRules: [
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound'
        properties: {
            description: 'Required for worker nodes communication within a cluster.'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'VirtualNetwork'
            access: 'Allow'
            priority: 100
            direction: 'Inbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp'
        properties: {
            description: 'Required for workers communication with Databricks Webapp.'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'AzureDatabricks'
            access: 'Allow'
            priority: 100
            direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql'
        properties: {
            description: 'Required for workers communication with Azure SQL services.'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '3306'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'Sql'
            access: 'Allow'
            priority: 101
            direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage'
        properties: {
            description: 'Required for workers communication with Azure Storage services.'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'Storage'
            access: 'Allow'
            priority: 102
            direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound'
        properties: {
            description: 'Required for worker nodes communication within a cluster.'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'VirtualNetwork'
            access: 'Allow'
            priority: 103
            direction: 'Outbound'
        }
      }
      {
        name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub'
        properties: {
            description: 'Required for worker communication with Azure Eventhub services.'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '9093'
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'EventHub'
            access: 'Allow'
            priority: 104
            direction: 'Outbound'
        }
      }
    ]
  }
}


resource VNET 'Microsoft.Network/virtualNetworks@2021-02-01' existing  = {
  name: vnet
}

resource publicSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: subnetDatabricksPublicName
  parent: VNET
  properties: {
    addressPrefix: databricksPublicIPRange
          networkSecurityGroup: {
        id: nsgPublic.id
      }
      delegations: [
        {
          name: 'databricks-delegation-public'
          properties: {
            serviceName: 'Microsoft.Databricks/workspaces'
          }
        }
    ]
    
  }
}


resource privateSubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: subnetDatabricksPrivateName
  parent: VNET
  dependsOn: [
    publicSubnet
  ]
  properties: {
    addressPrefix: databricksPrivateIPRange
          networkSecurityGroup: {
        id: nsgPrivate.id
      }
      delegations: [
        {
          name: 'databricks-delegation-public'
          properties: {
            serviceName: 'Microsoft.Databricks/workspaces'
          }
        }
    ]
    
  }
}
