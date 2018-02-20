locals {
  app_name = "pipes-kafka-producer"
  count = "${var.enabled?1:0}"
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
          value = "${var.kafka_hostname}"
        }
        env {
          name = "HAYSTACK_GRAPHITE_HOST"
          value = "${var.graphite_hostname}"
        }
        env {
          name = "HAYSTACK_GRAPHITE_PORT"
          value = "${var.graphite_port}"
        }
        resources {
          limits {
            memory = "1500Mi"
          }
          requests {
            cpu = "500m"
            memory = "1500Mi"
          }
        }
      }
      termination_grace_period_seconds = "${var.termination_grace_period}"
      node_selector = "${var.node_selecter_label}"
    }

    "selector" {
      app = "${local.app_name}"
    }
  }
  count = "${local.count}"
}