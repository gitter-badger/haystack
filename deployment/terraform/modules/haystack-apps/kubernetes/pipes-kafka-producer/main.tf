locals {
  app_name = "pipes-kafka-producer"
}

resource "kubernetes_replication_controller" "haystack-rc" {
  metadata {
    name = "${local.app_name}"
    labels {
      app = "${local.app_name}"
    }
    namespace = "${var.namespace}"
  }
  "spec" {
    replicas = "${var.replicas}"
    template {
      container {
        image = "${var.image}"
        name = "${local.app_name}"
        env {
          name = "HAYSTACK_KAFKA_BROKERS"
          value = "${var.kafka_endpoint}"
        }
        env {
          name = "HAYSTACK_GRAPHITE_HOST"
          value = "${var.graphite_hostname}"
        }
      }
      termination_grace_period_seconds = "${var.termination_grace_period}"

    }

    "selector" {
      app = "${local.app_name}"
    }
  }
}