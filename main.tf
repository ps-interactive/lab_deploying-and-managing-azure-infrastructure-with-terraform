terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "tf_rg" {
  # TODO: Set the resource group of the current lab
  name = ""
}

resource "azurerm_virtual_network" "tf_vnet" {
  name                = "terraform-secondary-vnet"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.tf_rg.location
  resource_group_name = azurerm_resource_group.tf_rg.name
}

resource "azurerm_subnet" "tf_subnet" {
  name                 = "terraform-secondary-subnet"
  resource_group_name  = azurerm_resource_group.tf_rg.name
  virtual_network_name = azurerm_virtual_network.tf_vnet.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_public_ip" "tf_public_ip" {
  name                = "terraform-secondary-public-ip"
  location            = azurerm_resource_group.tf_rg.location
  resource_group_name = azurerm_resource_group.tf_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "tf_nsg" {
  name                = "terraform-secondary-nsg"
  location            = azurerm_resource_group.tf_rg.location
  resource_group_name = azurerm_resource_group.tf_rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "tf_nic" {
  name                = "terraform-secondary-nic"
  location            = azurerm_resource_group.tf_rg.location
  resource_group_name = azurerm_resource_group.tf_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tf_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "tf_nic_nsg" {
  network_interface_id      = azurerm_network_interface.tf_nic.id
  network_security_group_id = azurerm_network_security_group.tf_nsg.id
}

resource "azurerm_linux_virtual_machine" "tf_vm" {
  # TODO: Give the VM a unique name
  name = ""

  # TODO: Reference the Terraform-created resource group name
  resource_group_name = 

  # TODO: Reference the Terraform-created resource group location
  location = 

  # TODO: Choose a VM size, for example "Standard_B1s"
  size = ""

  # TODO: Set the admin username
  admin_username = ""

  # TODO: Set the admin password
  admin_password = ""

  # TODO: Allow password-based SSH login by setting as false
  disable_password_authentication = 

  network_interface_ids = [
    azurerm_network_interface.tf_nic.id
  ]

  os_disk {
    name = "terraform-secondary-osdisk"

    caching = "ReadWrite"

    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"

    offer = "0001-com-ubuntu-server-jammy"

    sku = "22_04-lts-gen2"

    version = "latest"
  }

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}

output "public_ip_address" {
  description = "Public IP address of the Terraform-created VM"
  value       = azurerm_public_ip.tf_public_ip.ip_address
}
