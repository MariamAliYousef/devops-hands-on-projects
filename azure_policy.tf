
# Create a custom Azure Policy definition to restrict allowed deployment regions
resource "azurerm_policy_definition" "location_policy" {
  name         = "restrict-location-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Restrict Location Policy"
  
  policy_rule = <<POLICY_RULE
  {
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedLocations')]"
      }
    },
    "then": {
      "effect": "Deny"
    }
  }
  POLICY_RULE
  parameters = <<PARAMETERS
  {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "displayName": "Allowed Locations",
        "description": "The list of allowed locations"
      }
    }
  }
  PARAMETERS
}

# Assign the custom location restriction policy to the target resource group with specified parameters
resource "azurerm_resource_group_policy_assignment" "rg_policy_assign" {
  name                 = "assign-location-policy"
  resource_group_id    = azurerm_resource_group.rg.id
  policy_definition_id = azurerm_policy_definition.location_policy.id

  parameters = jsonencode({
    "allowedLocations" = {
      "value" = ["East US", "East US 2"]
    }
  })
}

