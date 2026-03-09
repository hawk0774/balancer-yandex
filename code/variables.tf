############
# Provider #
############
variable "cloud_id" {
  type        = string
  default     = ""
}

variable "folder_id" {
  type        = string
  default     = ""
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}
variable "network_name" {
  type    = string
  default = "vpc-15-1"
}

variable "public_cidr" {
  type    = string
  default = "192.168.10.0/24"
}

variable "ig_service_account_id" {
  type        = string
  description = "Service account ID for instance group"
  default     = ""
}

#########################
# Object Storage bucket #
#########################

variable "bucket_name" {
  type        = string
  default     = "yastrebov-09-03-2026"
}

variable "image_path" {
  type        = string
  default     = "./goyda.jpg"
}

variable "image_object_key" {
  type        = string
  description = "Object key (file name) in the bucket"
  default     = "goyda.jpg"
}

#############################
# Instance Group (LAMP VMs)  #
##############################

variable "vm_platform_id" {
  type        = string
  description = "Platform ID for LAMP VMs"
  default     = "standard-v3"
}

variable "ig_name" {
  type        = string
  description = "Instance Group name"
  default     = "lamp-ig"
}

variable "ig_size" {
  type        = number
  description = "Fixed size of Instance Group"
  default     = 3
}

variable "lamp_image_id" {
  type        = string
  description = "Image id for LAMP template"
  default     = "fd827b91d99psvq5fjit"
}

variable "ig_vm_cores" {
  type        = number
  description = "Number of vCPUs per LAMP VM"
  default     = 2
}

variable "ig_vm_memory" {
  type        = number
  description = "RAM (GB) per LAMP VM"
  default     = 2
}


variable "ig_healthcheck_port" {
  type        = number
  description = "HTTP health check port for Instance Group"
  default     = 80
}

variable "ig_healthcheck_path" {
  type        = string
  description = "HTTP health check path for Instance Group"
  default     = "/"
}

variable "ig_health_interval" {
  type        = number
  description = "Instance Group health check interval (seconds)"
  default     = 5
}

variable "ig_health_timeout" {
  type        = number
  description = "Instance Group health check timeout (seconds)"
  default     = 3
}

variable "ig_healthy_threshold" {
  type        = number
  description = "Number of successful checks to mark instance healthy"
  default     = 2
}

variable "ig_unhealthy_threshold" {
  type        = number
  description = "Number of failed checks to mark instance unhealthy"
  default     = 2
}

variable "ig_target_group_name" {
  type        = string
  description = "Target group name created by Instance Group for NLB"
  default     = "lamp-ig-tg"
}


locals {
  lamp_user_data = <<-CLOUDINIT
  #cloud-config
  write_files:
    - path: /var/www/html/index.html
      permissions: "0644"
      content: |
        <html>
          <body>
            <h1>LAMP from Instance Group</h1>
            <p><a href="${local.public_image_url}">Open image</a></p>
            <img src="${local.public_image_url}" style="max-width:600px"/>
          </body>
        </html>
  runcmd:
    - systemctl enable apache2 || true
    - systemctl restart apache2 || systemctl restart httpd || true
  CLOUDINIT
}



variable "lamp_boot_disk_size" {
  type        = number
  description = "Boot disk size for LAMP instances (GB)"
  default     = 10
}

variable "lamp_boot_disk_type" {
  type        = string
  description = "Boot disk type for LAMP instances"
  default     = "network-hdd"
}

variable "ig_max_unavailable" {
  type        = number
  description = "Max unavailable instances during deployment"
  default     = 1
}

variable "ig_max_expansion" {
  type        = number
  description = "Max expansion of instances during deployment"
  default     = 0
}


########################
# Network Load Balancer#
########################

variable "nlb_name" {
  type        = string
  description = "Network Load Balancer name"
  default     = "lamp-nlb"
}

variable "nlb_listener_name" {
  type        = string
  description = "NLB listener name"
  default     = "http"
}

variable "nlb_listener_port" {
  type        = number
  description = "External port of NLB listener"
  default     = 80
}

variable "nlb_target_port" {
  type        = number
  description = "Target port on backend instances"
  default     = 80
}

variable "nlb_protocol" {
  type        = string
  description = "Protocol for NLB listener"
  default     = "tcp"
}

variable "nlb_ip_version" {
  type        = string
  description = "IP version for external address of NLB listener"
  default     = "ipv4"
}

variable "nlb_healthcheck_name" {
  type        = string
  description = "Name of NLB healthcheck"
  default     = "http-check"
}

