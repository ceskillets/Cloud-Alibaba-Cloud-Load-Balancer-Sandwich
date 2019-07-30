resource "alicloud_slb" "skillet-int-LB" {
  name = "Skillet-Internal-LB"
  specification = "slb.s1.small"
  internet = false
  vswitch_id = "${alicloud_vswitch.FW2-vswitch-trust.id}"
  instance_charge_type = "PostPaid"

    depends_on = ["alicloud_instance.Server1",
                  "alicloud_instance.Server2"]
}


resource "alicloud_slb_server_group" "server-pool-1" {
    load_balancer_id = "${alicloud_slb.skillet-int-LB.id}"
    name = "server-pool-1"
    servers = [
        {
            server_ids = ["${alicloud_instance.Server1.0.id}", "${alicloud_instance.Server2.0.id}"]
            port = 80
            weight = 100
        }
    ]
}


resource "alicloud_slb_listener" "int-http-listener" {
  load_balancer_id = "${alicloud_slb.skillet-int-LB.id}"
  backend_port = 80
  frontend_port = 80
  protocol = "tcp"
  bandwidth = 5
  health_check = "on"
  health_check_type ="tcp"
  server_group_id = "${alicloud_slb_server_group.server-pool-1.id}"
}


# resource "alicloud_slb_rule" "int-default" {
#    load_balancer_id = "${alicloud_slb.skillet-int-LB.id}"
#    frontend_port = "${alicloud_slb_listener.int-http-listener.frontend_port}"
#    name = "Web-Rule"
#    server_group_id = "${alicloud_slb_server_group.server-pool-1.id}"
# }


