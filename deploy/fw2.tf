# Launch Instance with Mgmt Interface
resource "alicloud_instance" "instance2" {
  availability_zone = "${data.alicloud_zones.fw-zone.zones.1.id}"
  security_groups = ["${alicloud_security_group.FW-MGMT-SG.id}"]
  instance_type        = "${var.instance-type}"
  system_disk_size     = 60
  system_disk_category = "cloud_efficiency"
  image_id             = "${data.alicloud_images.images_ds.images.0.id}"
  instance_name        = "${var.instance2-name}"
  vswitch_id = "${alicloud_vswitch.FW2-vswitch-mgmt.id}"
  internet_max_bandwidth_out = 5
  private_ip = "${var.FW2-MGMT-IP}"
  host_name = "${var.instance2-name}"
}

# Create Untrust Interface
resource "alicloud_network_interface" "fw2-eni1" {
    name = "${var.instance2-name}-eni1"
    vswitch_id = "${alicloud_vswitch.FW2-vswitch-untrust.id}"
    private_ip = "${var.FW2-UNTRUST-IP}"
    security_groups = ["${alicloud_security_group.FW-DATA-SG.id}"]
}


# Create Trust Interface
resource "alicloud_network_interface" "fw2-eni2" {
    name = "${var.instance2-name}-eni2"
    vswitch_id = "${alicloud_vswitch.FW2-vswitch-trust.id}"
    private_ip = "${var.FW2-TRUST-IP}"
    security_groups = ["${alicloud_security_group.FW-DATA-SG.id}"]
}

# Attach Untrust interface to Instance
resource "alicloud_network_interface_attachment" "fw2-untrust" {
    instance_id = "${alicloud_instance.instance2.id}"
    network_interface_id = "${alicloud_network_interface.fw2-eni1.id}"

    depends_on = ["alicloud_instance.instance2",
                  "alicloud_network_interface.fw2-eni1"]

}

# Attach Trust interface to Instance
resource "alicloud_network_interface_attachment" "fw2-trust" {
    instance_id = "${alicloud_instance.instance2.id}"
    network_interface_id = "${alicloud_network_interface.fw2-eni2.id}"

    depends_on = ["alicloud_instance.instance2",
                  "alicloud_network_interface.fw2-eni2",
                  "alicloud_network_interface_attachment.fw2-untrust"]
}


