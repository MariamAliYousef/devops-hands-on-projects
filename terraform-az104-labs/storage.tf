# Create a Storage Account with standard performance and locally redundant storage (LRS)
resource "azurerm_storage_account" "sa" {
    name                     = "az104sademo"
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "Production"
    }
}

# ------------------------------------------------
# Azure Blob Storage

# Create a private container inside the storage account for blob organization
resource "azurerm_storage_container" "container" {
    name                  = "appdata"
    storage_account_id    = azurerm_storage_account.sa.id
    container_access_type = "private"
}

# Upload a local text file as a block blob into the storage container
resource "azurerm_storage_blob" "blob" {
    name                 = "test_blob.txt"
    storage_container_id = azurerm_storage_container.container.id
    type                 = "Block"
    source               = "test_storage.txt"
}

# ------------------------------------------------
# Azure Files

# Create an Azure File Share with a specified quota in GB
resource "azurerm_storage_share" "share" {
    name               = "shared-data"
    storage_account_id = azurerm_storage_account.sa.id
    quota              = 50
}

# Upload a local file into the Azure File Share
resource "azurerm_storage_share_file" "file-shared" {
    name              = "test_storage.txt"
    storage_share_url = azurerm_storage_share.share.url
    source            = "test_storage.txt"
}
