resource "yandex_compute_instance_group" "lamp_ig" {
  name               = var.ig_name
  folder_id          = var.folder_id
  service_account_id = var.ig_service_account_id

  instance_template {
    platform_id = var.vm_platform_id

    resources {
      cores  = var.ig_vm_cores
      memory = var.ig_vm_memory
    }

    boot_disk {
      initialize_params {
        image_id = var.lamp_image_id     
        size     = var.lamp_boot_disk_size
        type     = var.lamp_boot_disk_type
      }
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public.id]  
      nat        = true                           
    }

    metadata = {
      user-data = local.lamp_user_data
    }
  }

  scale_policy {
    fixed_scale {
      size = var.ig_size   # по умолчанию 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = var.ig_max_unavailable
    max_expansion   = var.ig_max_expansion
  }

  health_check {
    interval            = var.ig_health_interval
    timeout             = var.ig_health_timeout
    healthy_threshold   = var.ig_healthy_threshold
    unhealthy_threshold = var.ig_unhealthy_threshold

    http_options {
      port = var.ig_healthcheck_port
      path = var.ig_healthcheck_path
    }
  }

  load_balancer {
    target_group_name = var.ig_target_group_name
  }
}

