provider "azurerm" {
    version = "=2.0.0"
    subscription_id = "0389e496-a9ad-4be0-8404-fa6fa1e18559"
    tenant_id = "eda2122b-8eb0-4ea6-a069-f3b74f8f822c"
    features {}
}

provider "azuread" {
  version = "=0.7.0"
  subscription_id = "0389e496-a9ad-4be0-8404-fa6fa1e18559"
}

terraform {
    backend "remote" {
        organization = "cdunkin"

        workspaces {
            name = "azure_training"
        }
    }
}