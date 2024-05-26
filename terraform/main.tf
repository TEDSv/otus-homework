#########################
### Networks
#########################
# Создание сети
resource "yandex_vpc_network" "local-network" {
  name = "local-network"
}

# Создание подсети
resource "yandex_vpc_subnet" "local-subnet-1" {

  name           = "local-subnet-1"
  network_id     = yandex_vpc_network.local-network.id
  v4_cidr_blocks = ["192.168.40.0/24"]
  
  depends_on = [
    yandex_vpc_network.local-network
  ]
}


#########################
### Security groups
#########################
resource yandex_vpc_security_group sg_allow_outgoing {

  name        = "Security group for allow outgoing traffic"
  network_id  = "${yandex_vpc_network.local-network.id}"

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource yandex_vpc_security_group sg_allow_ssh {

  name        = "Security group for allow ssh"
  network_id  = "${yandex_vpc_network.local-network.id}"

  ingress {
    description    = "Allow SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource yandex_vpc_security_group sg_allow_http {

  name        = "Security group for allow http/https"
  network_id  = "${yandex_vpc_network.local-network.id}"

  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource yandex_vpc_security_group sg_postgre {

  name        = "Security group for allow 5432"
  network_id  = "${yandex_vpc_network.local-network.id}"

  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = 5432
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


#########################
### Virtual machines
#########################
# Получение image_id
data "yandex_compute_image" "ubuntu" {
  family = var.ubuntu_family
}

# Создание ВМ
resource "yandex_compute_instance" "ubuntu_vm" {

  for_each = toset(var.vms)
  name = each.key
  platform_id = var.vm_platform_id
  
  # Разрешаем ребут виртуалки для изменений
  allow_stopping_for_update = true
 
  # загрузочный диск
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = each.key == "postgres-01" ? 40 : 20
    }
  }

  # сеть
  network_interface {
    subnet_id = yandex_vpc_subnet.local-subnet-1.id
    # nat = true
    nat = each.key == "nginx" ? true : false
    security_group_ids = [
      yandex_vpc_security_group.sg_allow_outgoing.id,
      yandex_vpc_security_group.sg_allow_ssh.id,
      # each.key  != "postgres-01" ? yandex_vpc_security_group.sg_allow_http.id : "",
      each.key  == "postgres-01" ? yandex_vpc_security_group.sg_postgre.id : yandex_vpc_security_group.sg_allow_http.id,
    ]
  }

  # мощности
  resources {
    core_fraction = 20
    cores = 2
    memory = 1
  }

  # закидываем юзера и ssh ключ
  metadata = {
    ssh-keys = "ted:${var.ted_key}"
  }

  # какие изменения игнорировать: imdage_id и размер диска
  lifecycle {
    ignore_changes = [
        boot_disk[0].initialize_params[0].image_id,
        boot_disk[0].initialize_params[0].size,
    ]
  }
  
  # создается когда уже есть подсеть
  depends_on = [
    yandex_vpc_subnet.local-subnet-1
  ]
}