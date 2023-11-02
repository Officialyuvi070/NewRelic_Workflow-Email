// Workflow Concept

// First Create Policy.
resource "newrelic_alert_policy" "workflow-policy" {
  name = var.name
  incident_preference = var.incident_preference
}

// Second create the aler condition and attach with that policy which i created
resource "newrelic_nrql_alert_condition" "workflow-condition" {
  policy_id      = newrelic_alert_policy.workflow-policy.id
  name           = var.name_condition
  type           = var.type
  enabled        = var.enabled
  description    = var.description

  nrql {
    query = "SELECT average(host.cpuPercent) AS 'CPU used %' FROM Metric WHERE `entityGuid` = 'NDIxMDM4OHxJTkZSQXxOQXw2MDQyNjMwMTQ2ODg0MjU3OTYx'"
  }
  warning {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// Third Create the notification destination
resource "newrelic_notification_destination" "workflow-destination" {
  name = var.name_destination
  type = var.destination_type
  property {
    key = "email"
    value = "arorayuvi256@gmail.com"
  }
}

// Forth Create the notification channel and attach that id of destination with this channel
resource "newrelic_notification_channel" "workflow-channel" {
  name = var.name_channel
  type = var.channel_type
  destination_id = newrelic_notification_destination.workflow-destination.id
  product = "IINT" // Please note the product used!

  property {
    key = "email"
    value = "arorayuvi256@gmail.com"
  }
}

// fifth step or Final step to create the workflow and attach that id of channel with this workflow
resource "newrelic_workflow" "main_workflow" {
  name                  = var.name_workflow
  muting_rules_handling = var.muting_rules_handling

  issues_filter {
    name = "filter-name"
    type = "FILTER"
    predicate {
      attribute = "labels.policyIds"
      operator = "EXACTLY_MATCHES"
      values = [ newrelic_alert_policy.workflow-policy.id ]
    }
 }
 destination {
    channel_id = newrelic_notification_channel.workflow-channel.id
  }
}
