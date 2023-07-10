# Provider configuration for Azure
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "rg1" {
  name     = "my-resource-group"
  location = "eastus"
}

# Network tier - Virtual Network and Subnets
resource "azurerm_virtual_network" "rg-vnet" {
  name                = "test-vnet"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}
#subnet
resource "azurerm_subnet" "frontend" {
  name                 = "test-subnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.rg1.name
  address_prefixes     = ["10.0.1.0/26"]
}
resource "azurerm_subnet" "backend" {
  name                 = "test-backend-subnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.rg1.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "vm-subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.rg1.name
  address_prefixes     = ["10.0.0.0/16"]
}



# Application tier - Virtual Machines and Load Balancer
# ... Define virtual machines or virtual machine scale sets, load balancer configuration, and related resources for the application tier
# Create a network security group

resource "azurerm_network_security_group" "rg1" {

  name                = "test-nsg"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
#Create a public IP address
resource "azurerm_public_ip" "rg1" {

  name                = "test-public-ip"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Static"
}
# Create a network interface
resource "azurerm_network_interface" "rg1" {
  name                      = "test-nic"
  location                  = azurerm_resource_group.rg1.location
  resource_group_name       = azurerm_resource_group.rg1.name
  network_security_group_id = azurerm_network_security_group.rg1.id
ip_configuration {
    name                          = "rg1-ip-config"
    subnet_id                     = azurerm_subnet.rg1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rg1.id
  }
}
# Create a virtual machine
resource "azurerm_virtual_machine" "rg1" {
  name                  = "rg1-vm"
  location              = azurerm_resource_group.rg1.location
  resource_group_name   = azurerm_resource_group.rg1.name
  network_interface_ids = [azurerm_network_interface.rg1.id]
  vm_size               = "Standard_DS2_v2"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "rg1-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"

  }
  os_profile {
    computer_name  = "rg1vm"
    admin_username = "adminuser"
    admin_password = "Password123!"

  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}


# Database tier - Azure SQL Database or Azure Database for MySQL/PostgreSQL
# ... Define the Azure database service, server configuration, and databases for the database tier

Create an Azure SQL Server
resource "azurerm_sql_server" "rg1" {
  name                         = "test-sql-server"
  resource_group_name          = azurerm_resource_group.rg1.name
  location                     = azurerm_resource_group.rg1.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd123!"

 

  tags = {
    environment = "poc"
  }
}
# Create an Azure SQL Database
resource "azurerm_sql_database" "rg1" {
  name                = "test-sql-database"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  server_name         = azurerm_sql_server.rg1.name
  edition             = "Standard"
  compute_model       = "Serverless"
  capacity             = 1

 

  tags = {
    environment = "dev"
  }
}


has context menu
Compose