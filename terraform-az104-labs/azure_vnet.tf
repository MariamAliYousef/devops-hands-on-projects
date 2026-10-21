# Create an Azure VNET1 ==> Production
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-prod"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]
    dns_servers         = ["10.0.0.4", "10.0.0.5"]
 
    tags = {
        environment = "Production"
    }
}

# Create Azure VNET2 ==> Development
resource "azurerm_virtual_network" "vnet-dev" {
    name                = "vnet-dev"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    address_space       = ["10.1.0.0/16"]

    tags = {
        environment = "Development"
    }
}

# Create Frontend subnet ==> vnet-prod
resource "azurerm_subnet" "frontend" {
    name                 = "frontend-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.1.0/24"]
}

# Create Backend subnet ==> vnet-prod
resource "azurerm_subnet" "backend" {
    name                 = "backend-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.2.0/24"]
}

# Create Dev subnet ==> vnet-dev
resource "azurerm_subnet" "dev-subnet" {
    name                 = "dev-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet-dev.name
    address_prefixes     = ["10.1.1.0/24"]
}

# Create Network security group with an inbound rule allowing SSH traffic
resource "azurerm_network_security_group" "nsg" {
    name                = "frontend-nsg"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name      = "allowSSH"
        priority  = 100
        direction = "Inbound"
        access    = "Allow"
        protocol  = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Associate NSG with the frontend subnet
resource "azurerm_subnet_network_security_group_association" "frontend-assoc" {
    subnet_id                 = azurerm_subnet.frontend.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

# VNET Peering (Direction 1: Production to Development)
resource "azurerm_virtual_network_peering" "prod-to-dev" {
    name                         = "prod-to-dev"
    resource_group_name          = azurerm_resource_group.rg.name
    virtual_network_name         = azurerm_virtual_network.vnet.name
    remote_virtual_network_id    = azurerm_virtual_network.vnet-dev.id
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
}

# VNET Peering (Direction 2: Development to Production)
resource "azurerm_virtual_network_peering" "dev-to-prod" {
    name                         = "dev-to-prod"
    resource_group_name          = azurerm_resource_group.rg.name
    virtual_network_name         = azurerm_virtual_network.vnet-dev.name
    remote_virtual_network_id    = azurerm_virtual_network.vnet.id
    allow_forwarded_traffic      = true
    allow_virtual_network_access = true
}

