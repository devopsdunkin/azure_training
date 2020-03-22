resource "azurerm_resource_group" "training_rg1" {
    name                = "training_rg1"
    location            = "Central US"

    tags = {
        environment = "training"
    }
}

resource "azurerm_network_security_group" "training_network_sg" {
    name                = "Training-SG"
    location            = azurerm_resource_group.training_rg1.location
    resource_group_name = azurerm_resource_group.training_rg1.name
}

resource "azurerm_network_ddos_protection_plan" "ddos_plan" {
    name                = "training-ddos-plan"
    location            = azurerm_resource_group.training_rg1.location
    resource_group_name = azurerm_resource_group.training_rg1.name
}

resource "azurerm_virtual_network" "training_network" {
    name                = "training_network"
    location            = azurerm_resource_group.training_rg1.location
    resource_group_name = azurerm_resource_group.training_rg1.name
    address_space       = ["10.0.0.0/16"]

    ddos_protection_plan {
        id              = azurerm_network_ddos_protection_plan.ddos_plan.id
        enable          = true
    }

    subnet {
        name            = "Management"
        address_prefix  = "10.0.1.0/24"
    }

    subnet {
        name            = "Users"
        address_prefix  = "10.0.100.0/24"
        security_group  = azurerm_network_security_group.training_network_sg.id
    }

    tags = {
        environment = "training"
    }
}

resource "azurerm_log_analytics_workspace" "logworkspacetf1" {
  name                = "logworkspacetf1"
  location            = azurerm_resource_group.training_rg1.location
  resource_group_name = azurerm_resource_group.training_rg1.name
  sku                 = "Free"
}

resource "azurerm_app_service_plan" "appserviceplan1" {
  name                = "appserviceplan1"
  location            = azurerm_resource_group.training_rg1.location
  resource_group_name = azurerm_resource_group.training_rg1.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "webappcdunkin2" {
  name                = "webappcdunkin2"
  location            = azurerm_resource_group.training_rg1.location
  resource_group_name = azurerm_resource_group.training_rg1.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan1.id

  tags = {
    environment = "training"
  }
}
