terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.25.0"  # Specify the version constraint
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "e6614c15-eaa6-4d28-bb11-8b85609113f2"
}

resource "azurerm_resource_group" "zadanie1_group" {
  name     = "TerraformTraining-A864148"
  location = "West Europe"
}