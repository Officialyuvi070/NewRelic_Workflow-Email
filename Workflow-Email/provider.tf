terraform {
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
      version = "3.27.3"
    }
  }
}

provider "newrelic" {
  # Configuration options
  account_id = 4210388
  api_key = "NRAK-YMA2XUSAHDNF9TIU4INM6S6S0QI"
  region = "US"
}