output "public_image_url" {
  description = "Public URL of the image in Object Storage"
  value       = local.public_image_url
}

output "nlb_ip" {
  description = "External IP address of Network Load Balancer listener"
  value = one([
    for l in yandex_lb_network_load_balancer.nlb.listener :
    one([for a in l.external_address_spec : a.address])
  ])
}

