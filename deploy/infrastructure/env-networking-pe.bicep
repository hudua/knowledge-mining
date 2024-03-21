
param vnetName string
param subnetPrivateEndpointsName string
param subnetAppServiceName string
param location string = resourceGroup().location

var uniqueness = uniqueString(resourceGroup().id)
var keyVaultName = 'akv-${uniqueness}'
var searchName = 'search-${uniqueness}'
var cognitiveAccountName = 'cognitive-account-${uniqueness}'
var storageAccountNameData = 'stg${uniqueness}'
var appServicePlanName = 'app-plan-${uniqueness}'
var webAppName = 'site-${uniqueness}'
var functionAppName = 'function-app-${uniqueness}'
var cosmosName = 'cosmos-${uniqueness}'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing  = {
  name: vnetName
}

// Key Vault
resource azure_key_vault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
}

resource azure_key_vault_pe 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${azure_key_vault.name}-endpoint'
  location: location
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetPrivateEndpointsName}'
    }
    privateLinkServiceConnections: [
      {
        name: 'MyConnection'
        properties: {
          privateLinkServiceId: azure_key_vault.id
          groupIds: [
            'vault'
          ]
        }
      }
    ]
  }
}



// Search
resource azure_search_service 'Microsoft.Search/searchServices@2020-08-01' existing = {
  name: searchName
}

resource azure_search_service_pe 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${azure_search_service.name}-endpoint'
  location: location
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetPrivateEndpointsName}'
    }
    privateLinkServiceConnections: [
      {
        name: 'MyConnection'
        properties: {
          privateLinkServiceId: azure_search_service.id
          groupIds: [
            'searchService'
          ]
        }
      }
    ]
  }
}


// Azure OpenAI

resource openAI 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: 'openai'
}

resource azure_openai_pe 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${openAI.name}-endpoint'
  location: location
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetPrivateEndpointsName}'
    }
    privateLinkServiceConnections: [
      {
        name: 'MyConnection'
        properties: {
          privateLinkServiceId: openAI.id
          groupIds: [
            'account'
          ]
        }
      }
    ]
  }
}


// Cosmos DB

resource dbaccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosName
}

resource azure_cosmos_db_pe 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${dbaccount.name}-endpoint'
  location: location
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetPrivateEndpointsName}'
    }
    privateLinkServiceConnections: [
      {
        name: 'MyConnection'
        properties: {
          privateLinkServiceId: dbaccount.id
          groupIds: [
            'Sql'
          ]
        }
      }
    ]
  }
}

// Cognitive Services
resource azure_congnitive_account 'Microsoft.CognitiveServices/accounts@2017-04-18' existing = {
  name: cognitiveAccountName
}

resource azure_congnitive_account_pe 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${azure_congnitive_account.name}-endpoint'
  location: location
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetPrivateEndpointsName}'
    }
    privateLinkServiceConnections: [
      {
        name: 'MyConnection'
        properties: {
          privateLinkServiceId: azure_congnitive_account.id
          groupIds: [
            'account'
          ]
        }
      }
    ]
  }
}

// Storage Accounts
resource azure_storage_account_data 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: storageAccountNameData
}

resource azure_storage_account_data_blob_pe 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  location: location
  name: '${azure_storage_account_data.name}-blob-endpoint'
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetPrivateEndpointsName}'
    }
    privateLinkServiceConnections: [
      {
        name: '${azure_storage_account_data.name}-blob-endpoint'
        properties: {
          privateLinkServiceId: azure_storage_account_data.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}


resource azure_storage_account_functions 'Microsoft.Storage/storageAccounts@2019-06-01' existing = {
  name: 'stgfunc${uniqueness}'
}

resource azure_storage_account_functions_blob_pe 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  location: location
  name: '${azure_storage_account_functions.name}-endpoint'
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetPrivateEndpointsName}'
    }
    privateLinkServiceConnections: [
      {
        name: '${azure_storage_account_functions.name}-blob-endpoint'
        properties: {
          privateLinkServiceId: azure_storage_account_functions.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}



resource app_services_website 'Microsoft.Web/sites@2020-06-01' existing = {
  name: webAppName
}

resource app_services_website_vnet 'Microsoft.Web/sites/networkConfig@2020-06-01' = {
  name: '${app_services_website.name}/VirtualNetwork'
  properties: {
    subnetResourceId: '${vnet.id}/subnets/${subnetAppServiceName}'
    swiftSupported: true
  }
}

resource app_services_website_pe 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${app_services_website.name}-endpoint'
  location: location
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetPrivateEndpointsName}'
    }
    privateLinkServiceConnections: [
      {
        name: 'MyConnection'
        properties: {
          privateLinkServiceId: app_services_website.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}


resource app_services_function_app 'Microsoft.Web/sites@2020-06-01' existing = {
  name: functionAppName

}

resource app_services_function_app_vnet 'Microsoft.Web/sites/networkConfig@2020-06-01' = {
  name: '${app_services_function_app.name}/VirtualNetwork'
  properties: {
    subnetResourceId: '${vnet.id}/subnets/${subnetAppServiceName}'
    swiftSupported: true
  }
}

resource app_services_function_app_pe 'Microsoft.Network/privateEndpoints@2021-08-01' = {
  name: '${app_services_function_app.name}-endpoint'
  location: location
  properties: {
    subnet: {
      id: '${vnet.id}/subnets/${subnetPrivateEndpointsName}'
    }
    privateLinkServiceConnections: [
      {
        name: 'MyConnection'
        properties: {
          privateLinkServiceId: app_services_function_app.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}
