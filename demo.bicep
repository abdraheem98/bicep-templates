param location string = 'East US'
param vmName string = 'myBicepVM'
param adminUsername string = 'azureuser'
param adminPassword string = 'P@ssw0rd123' 

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: 'MyResourceGroup'
}


resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: 'myVNet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
  }
}


resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-03-01' = {
  parent: vnet
  name: 'mySubnet'
  properties: {
    addressPrefix: '10.0.0.0/24'
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: 'myPublicIP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}


resource nic 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: 'myNIC'
  location: location
  properties: {
    ipConfigurations: [{
      name: 'ipconfig1'
      properties: {
        subnet: {
          id: subnet.id
        }
        publicIPAddress: {
          id: publicIP.id
        }
      }
    }]
  }
}


resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [{
        id: nic.id
      }]
    }
  }
}
