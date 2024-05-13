# Получение image_id
data "yandex_compute_image" "ubuntu" {
  family = var.ubuntu_family
}

# Создание сети
resource "yandex_vpc_network" "otus-network" {
  name = "otus-network"
}

# Создание подсети
resource "yandex_vpc_subnet" "otus-subnet-1" {
  name           = "otus-subnet-1"
  network_id     = yandex_vpc_network.otus-network.id
  v4_cidr_blocks = ["192.168.40.0/24"]
  
  depends_on = [
    yandex_vpc_network.otus-network
  ]
}

# Создание ВМ
resource "yandex_compute_instance" "ubuntu-vm" {
  name = "ubuntu-vm"
  platform_id = var.vm_platform_id
  allow_stopping_for_update = true
 
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = 60
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.otus-subnet-1.id
    nat       = true
  }

  resources {
    core_fraction = 20
    cores = 2
    memory = 2
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }

  lifecycle {
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
  
  depends_on = [
    yandex_vpc_subnet.otus-subnet-1
  ]
}