resource "yandex_lb_network_load_balancer" "nlb" {
  name = var.nlb_name

  listener {
    name        = var.nlb_listener_name
    port        = var.nlb_listener_port
    target_port = var.nlb_target_port
    protocol    = var.nlb_protocol

    external_address_spec {
      ip_version = var.nlb_ip_version
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp_ig.load_balancer[0].target_group_id

    healthcheck {
      name = var.nlb_healthcheck_name

      http_options {
        port = var.ig_healthcheck_port
        path = var.ig_healthcheck_path
      }
    }
  }
}

