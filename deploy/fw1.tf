# Launch Instance with Mgmt Interface
resource "alicloud_instance" "instance1" {
  availability_zone = "${data.alicloud_zones.fw-zone.zones.0.id}"
  security_groups = ["${alicloud_security_group.FW-MGMT-SG.id}"]
  instance_type        = "${var.instance-type}"
  system_disk_size     = 60
  system_disk_category = "cloud_efficiency"
  image_id             = "${data.alicloud_images.images_ds.images.0.id}"
  instance_name        = "${var.instance1-name}"
  vswitch_id = "${alicloud_vswitch.FW1-vswitch-mgmt.id}"
  internet_max_bandwidth_out = 5
  private_ip = "${var.FW1-MGMT-IP}"
  host_name = "${var.instance1-name}"
}

# Create Untrust Interface
resource "alicloud_network_interface" "fw1-eni1" {
    name = "${var.instance1-name}-eni1"
    vswitch_id = "${alicloud_vswitch.FW1-vswitch-untrust.id}"
    private_ip = "${var.FW1-UNTRUST-IP}"
    security_groups = ["${alicloud_security_group.FW-DATA-SG.id}"]
}


# Create Trust Interface
resource "alicloud_network_interface" "fw1-eni2" {
    name = "${var.instance1-name}-eni2"
    vswitch_id = "${alicloud_vswitch.FW1-vswitch-trust.id}"
    private_ip = "${var.FW1-TRUST-IP}"
    security_groups = ["${alicloud_security_group.FW-DATA-SG.id}"]
}

# Attach Untrust interface to Instance
resource "alicloud_network_interface_attachment" "fw1-untrust" {
    instance_id = "${alicloud_instance.instance1.id}"
    network_interface_id = "${alicloud_network_interface.fw1-eni1.id}"

    depends_on = ["alicloud_instance.instance1",
                  "alicloud_network_interface.fw1-eni1"]

}

# Attach Trust interface to Instance
resource "alicloud_network_interface_attachment" "fw1-trust" {
    instance_id = "${alicloud_instance.instance1.id}"
    network_interface_id = "${alicloud_network_interface.fw1-eni2.id}"

    depends_on = ["alicloud_instance.instance1",
                  "alicloud_network_interface.fw1-eni2",
                  "alicloud_network_interface_attachment.fw1-untrust"]
}




resource "alicloud_eip" "fw1-eip" {
  name                 = "fw1-eip"
  description          = "Public IP assigned to fw1"
  bandwidth            = "1"
  internet_charge_type = "PayByTraffic"
}


resource "alicloud_eip_association" "eip_asso" {
  allocation_id = "${alicloud_eip.fw1-eip.id}"
  instance_id   = "${alicloud_network_interface.fw1-eni1.id}"
  instance_type = "NetworkInterface"

  depends_on = ["alicloud_eip.fw1-eip",
                "alicloud_network_interface.fw1-eni1"]
}

