resource "alicloud_instance" "Server1" {
  image_id              = "${data.alicloud_images.ubuntu_image.images.0.id}"
  instance_type         = "${var.linux_instance_type}"
  system_disk_size      = 40
  system_disk_category  = "cloud_efficiency"
  security_groups       = ["${alicloud_security_group.FW-DATA-SG.id}"]
  instance_name         = "Server1"
  vswitch_id            = "${alicloud_vswitch.Server1-vswitch.id}"
  private_ip            = "${var.Server1-IP}"
  host_name             = "${var.Server1-Name}"
#  key_name              = "${var.Server-key}"
  password              = "${var.linux_password}"
  description           = "Server1"
  security_enhancement_strategy = "Active"

  internet_max_bandwidth_out = 0
  instance_charge_type  = "PostPaid"

user_data = <<EOF
#!/bin/bash -ex
sudo apt-get update
sudo apt-get install -y apache2
sudo rm -f /var/www/html/index.html
sudo echo "Test Server 1" > /var/www/html/index.html
sudo echo "done"
EOF

}



resource "alicloud_instance" "Server2" {
  image_id              = "${data.alicloud_images.ubuntu_image.images.0.id}"
  instance_type         = "${var.linux_instance_type}"
  system_disk_size      = 40
  system_disk_category  = "cloud_efficiency"
  security_groups       = ["${alicloud_security_group.FW-DATA-SG.id}"]
  instance_name         = "Server2"
  vswitch_id            = "${alicloud_vswitch.Server2-vswitch.id}"
  private_ip            = "${var.Server2-IP}"
  host_name             = "${var.Server2-Name}"
#  key_name              = "${var.Server-key}"
  password              = "${var.linux_password}"
  description           = "Server2"
  security_enhancement_strategy = "Active"

  internet_max_bandwidth_out = 0
  instance_charge_type  = "PostPaid"

user_data = <<EOF
#!/bin/bash -ex
sudo apt-get update
sudo apt-get install -y apache2
sudo rm -f /var/www/html/index.html
sudo echo "Test Server 2" > /var/www/html/index.html
sudo echo "done"
EOF

}


