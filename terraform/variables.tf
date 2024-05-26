variable "zone" {
  type    = string
  default = "ru-central1-d"
}

variable "ubuntu_family" {
  type = string
  default = "ubuntu-2204-lts"
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "vm_platform_id" {
  type = string
  default = "standard-v3"
}

variable "ted_key" {
  description = "SSH public key"
  type        = string
}

variable "vms" {
  type    = list(string)
}

variable "terraform_public_key" {
  default = "~/.ssh/terraform.pub"
}

variable "terraform_private_key" {
  default = "~/.ssh/terraform.pem"
}

variable "terraform_user" {
  default = "terraform"
}