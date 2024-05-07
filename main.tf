# Define the Azure provider
provider "azurerm" {
  features {}
}

# Define the resource group
resource "azurerm_resource_group" "example_rg" {
  name     = "exampleResourceGroup"
  location = "eastus"  # Specify your desired Azure region
}

# Define the backend configuration for storing Terraform state in Azure Blob Storage


# Define the virtual network
resource "azurerm_virtual_network" "example_vnet" {
  name                = "exampleVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name
}

# Define the subnet
resource "azurerm_subnet" "example_subnet" {
  name                 = "exampleSubnet"
  resource_group_name  = azurerm_resource_group.example_rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define the network interface
resource "azurerm_network_interface" "example_nic" {
  count               = 3
  name                = "exampleNIC-${count.index}"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name

  ip_configuration {
    name                          = "exampleNICConfiguration"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Define the virtual machines
resource "azurerm_windows_virtual_machine" "example_vm" {
  count                = 2
  name                 = "exampleVM-${count.index}"
  resource_group_name  = azurerm_resource_group.example_rg.name
  location             = azurerm_resource_group.example_rg.location
  size                 = "Standard_DS1_v2"
  admin_username       = "azureuser"
  admin_password       = "Password1234!"  # Replace with your desired password

  network_interface_ids = [azurerm_network_interface.example_nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
