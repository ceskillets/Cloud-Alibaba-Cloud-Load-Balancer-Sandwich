

provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.fw-region}"
}


data "alicloud_images" "images_ds" {
  owners = "self"
  name_regex = "^vm-series-9.0.1"
}


# Get Ubuntu image info
data "alicloud_images" "ubuntu_image" {
  name_regex  = "^ubuntu_16_04_64"
  owners      = "system"
}


data "alicloud_zones" "fw-zone" {
  available_instance_type = "${var.instance-type}"
  available_disk_category = "cloud_efficiency"
}


resource "random_id" "randomId" {
  byte_length = 8
}