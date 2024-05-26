output "vm_internal_ip_address" {
  value = [for instance in yandex_compute_instance.ubuntu_vm : instance.network_interface.0.ip_address]
}


output "vm_ip_address" {
  value = [for instance in yandex_compute_instance.ubuntu_vm : instance.network_interface.0.nat_ip_address]
}


# Добавление вм в инвентори файл для ansible
resource "local_file" "inventory" {
  content = templatefile("inventory.tmpl", { content = tomap({
    for instance in yandex_compute_instance.ubuntu_vm:
      instance.name => instance.network_interface.0.ip_address
    })
  })
  filename = format("%s/%s", abspath(path.root), "../ansible/inventory.yaml")
}

