output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.ubuntu-vm.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.ubuntu-vm.network_interface.0.nat_ip_address
}

# Добавление вм в инвентори файл для ansible
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory.tftpl",
    {
      server_name = yandex_compute_instance.ubuntu-vm.name,
      ip_address = yandex_compute_instance.ubuntu-vm.network_interface.0.nat_ip_address
    }
  )
  filename = "/mnt/d/Learning/OTUS/HL/Ansible/hosts"
}