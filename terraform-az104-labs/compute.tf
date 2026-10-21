# Create a Simple Windows Server 2025 VM

# Create Virtual network interface for the standalone dev VM
resource "azurerm_network_interface" "dev-vm-nic" {
    name                = "dev-vm-nic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
      name                          = "internal"
      subnet_id                     = azurerm_subnet.dev-subnet.id
      private_ip_address_allocation = "Dynamic"
    }
}

# Create standalone Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
    name                = "dev-server"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = "Standard_E2s_v7"
    admin_username      = "adminuser"
    admin_password      = "P@ssw0rd@123"
    network_interface_ids = [ azurerm_network_interface.dev-vm-nic.id, ]

    os_disk {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition"
      version   = "latest"
    }
}

# ---------------------------------------------------
# High Availability Configuration (Availability Set)

# Create Availability Set for High Availability across Fault & Update Domains
resource "azurerm_availability_set" "avset" {
    name                         = "vmss1"
    resource_group_name          = azurerm_resource_group.rg.name
    location                     = azurerm_resource_group.rg.location
    platform_fault_domain_count  = 2
    platform_update_domain_count = 5
    managed = true

    tags = {
      environment = "Production"
    }
}

# Create Network Interface for the web VM in the frontend subnet
resource "azurerm_network_interface" "vmss-nic" {
    #count              = 2
    #name               = "nic-vm-${count.index + 1}"
    name                = "nic-vm-1"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
      name                          = "internal"
      subnet_id                     = azurerm_subnet.frontend.id
      private_ip_address_allocation = "Dynamic"
    }
}

# Create Windows Virtual Machine attached to the Availability Set
resource "azurerm_windows_virtual_machine" "web" {
    #count                = 2
    #name                 = "web-vm-${count.index + 1}"
    name                  = "web-vm-1"
    location              = azurerm_resource_group.rg.location
    resource_group_name   = azurerm_resource_group.rg.name
    size                  = "Standard_E2s_v7"
    availability_set_id   = azurerm_availability_set.avset.id
    network_interface_ids = [ azurerm_network_interface.vmss-nic.id, ]
    admin_username        = "adminuser"
    admin_password        = "P@ssw0rd@123"

    os_disk {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2022-datacenter-azure-edition"
      version   = "latest"
    }

    tags = {
        environment = "Production"
    }
}

