resource "alicloud_slb" "skillet-ext-LB" {
  name = "Skillet-External-LB"
  specification = "slb.s1.small"
  internet = true
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
#  master_zone_id = "${data.alicloud_zones.fw-zone.zones.2.id}"
#  slave_zone_id = "${data.alicloud_zones.fw-zone.zones.1.id}"

    depends_on = ["alicloud_network_interface.fw2-eni1",
                  "alicloud_network_interface_attachment.fw2-untrust",
                  "alicloud_network_interface.fw1-eni1",
                  "alicloud_network_interface_attachment.fw1-untrust"]
}


resource "alicloud_slb_server_group" "vm-fw-pool-1" {
    load_balancer_id = "${alicloud_slb.skillet-ext-LB.id}"
    name = "vm-fw-pool-1"
    servers = [
        {
            server_ids = ["${alicloud_network_interface.fw1-eni1.id}", "${alicloud_network_interface.fw2-eni1.id}"]
            port = 80
            weight = 100
            type = "eni"
        }
    ]
}


resource "alicloud_slb_listener" "ext-http-listener" {
  load_balancer_id = "${alicloud_slb.skillet-ext-LB.id}"
  backend_port = 80
  frontend_port = 80
  protocol = "tcp"
  bandwidth = 5
  health_check = "on"
  health_check_type ="tcp"
  server_group_id = "${alicloud_slb_server_group.vm-fw-pool-1.id}"
}


# resource "alicloud_slb_rule" "ext-default" {
#    load_balancer_id = "${alicloud_slb.skillet-ext-LB.id}"
#    frontend_port = "${alicloud_slb_listener.ext-http-listener.frontend_port}"
#    name = "Web-Rule"
#    server_group_id = "${alicloud_slb_server_group.vm-fw-pool-1.id}"
#}

