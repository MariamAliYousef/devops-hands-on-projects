# Create a security-enabled Azure AD group for the DevOps team
resource "azuread_group" "devops_team" {
    display_name     = "DevOps Engineers"
    security_enabled = true
}

# Create a new Azure AD user account with a mandatory password change on first login
resource "azuread_user" "new_user" {
    user_principal_name   = "devops_eng1@domain.com"
    display_name          = "devops_eng1"
    mail_nickname         = "devops_eng1"
    password              = "P@ssw0rd@123"
    force_password_change = true
}

# Assign the user as a member of the DevOps team security group
resource "azuread_group_member" "mem1" {
    group_object_id  = azuread_group.devops_team.object_id
    member_object_id = azuread_user.new_user.object_id
}

# Retrieve details and ID of the primary Azure subscription
data "azurerm_subscription" "primary" {
}

# Assign the 'Contributor' RBAC role to the new user scoped at the subscription level
resource "azurerm_role_assignment" "contributor" {
    scope                = data.azurerm_subscription.primary.id
    role_definition_name = "Contributor"
    principal_id         = azuread_user.new_user.object_id
  
}


