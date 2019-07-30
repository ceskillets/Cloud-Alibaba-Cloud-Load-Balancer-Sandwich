
resource "alicloud_vpc" "fw_vpc" {
  name        = "${var.fw-vpc}-${random_id.randomId.hex}"
  cidr_block  = "${var.fw-vpc-cidr}"
  description = "VPC for VM-Series on Alicloud"
}

resource "alicloud_vswitch" "FW1-vswitch-mgmt" {
  name              = "FW1-VSwitch-MGMT"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.fw1-vswitch-mgmt-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.0.id}"
  description       = "MGMT VSwitch for FW1-VM"
}

resource "alicloud_vswitch" "FW1-vswitch-untrust" {
  name              = "FW1-VSwitch-UNTRUST"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.fw1-vswitch-untrust-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.0.id}"
  description       = "Untrust VSwitch for FW1-VM"
}

resource "alicloud_vswitch" "FW1-vswitch-trust" {
  name              = "FW1-VSwitch-TRUST"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.fw1-vswitch-trust-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.0.id}"
  description       = "Trust VSwitch for FW1-VM"
}


resource "alicloud_vswitch" "FW2-vswitch-mgmt" {
  name              = "FW2-VSwitch-MGMT"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.fw2-vswitch-mgmt-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.1.id}"
  description       = "MGMT VSwitch for FW2-VM"
}

resource "alicloud_vswitch" "FW2-vswitch-untrust" {
  name              = "FW2-VSwitch-UNTRUST"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.fw2-vswitch-untrust-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.1.id}"
  description       = "Untrust VSwitch for FW2-VM"
}

resource "alicloud_vswitch" "FW2-vswitch-trust" {
  name              = "FW2-VSwitch-TRUST"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.fw2-vswitch-trust-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.1.id}"
  description       = "Trust VSwitch for FW2-VM"
}


resource "alicloud_vswitch" "Server1-vswitch" {
  name              = "Server1-VSwitch"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.server1-vswitch-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.0.id}"
  description       = "VSwitch for Server1"
}


resource "alicloud_vswitch" "Server2-vswitch" {
  name              = "Server2-VSwitch"
  vpc_id            = "${alicloud_vpc.fw_vpc.id}"
  cidr_block        = "${var.server2-vswitch-cidr}"
  availability_zone = "${data.alicloud_zones.fw-zone.zones.1.id}"
  description       = "VSwitch for Server2"
}


#resource "alicloud_eip" "FW-EIP" {
#  name                 = "FW-EIP"
#  description          = "Public IP assigned to FW"
#  bandwidth            = "1"
#  internet_charge_type = "PayByTraffic"
#}

resource "alicloud_security_group" "FW-MGMT-SG" {
  name        = "FW-MGMT-Security-Group"
  vpc_id      = "${alicloud_vpc.fw_vpc.id}"
  description = "Security Group for FW MGMT"
}

resource "alicloud_security_group_rule" "allow_icmp" {
  type              = "ingress"
  ip_protocol       = "icmp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = "${alicloud_security_group.FW-MGMT-SG.id}"
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_security_group_rule" "allow_https" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "443/443"
  priority          = 1
  security_group_id = "${alicloud_security_group.FW-MGMT-SG.id}"
  cidr_ip           = "0.0.0.0/0"
}


resource "alicloud_security_group_rule" "allow_ssh" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.FW-MGMT-SG.id}"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group" "FW-DATA-SG" {
  name        = "FW-DATA-Security-Group"
  vpc_id      = "${alicloud_vpc.fw_vpc.id}"
  description = "Security Group for FW DATA"
}

resource "alicloud_security_group_rule" "allow_all" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = "${alicloud_security_group.FW-DATA-SG.id}"
  cidr_ip           = "0.0.0.0/0"
}



resource "alicloud_route_entry" "default" {
  route_table_id        = "${alicloud_vpc.fw_vpc.route_table_id}"
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "NetworkInterface"
  nexthop_id            = "${alicloud_network_interface.fw1-eni2.id}"

    depends_on = ["alicloud_network_interface.fw1-eni1",
                  "alicloud_network_interface_attachment.fw1-trust"]
}


