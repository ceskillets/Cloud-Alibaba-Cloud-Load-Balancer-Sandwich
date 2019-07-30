output "fw1_public_ip" {
  value = "${alicloud_instance.instance1.public_ip}"
}


output "fw2_public_ip" {
  value = "${alicloud_instance.instance2.public_ip}"
}


output "ext_lb_public_ip" {
  value = "${alicloud_slb.skillet-ext-LB.address}"
}


output "int_lb_ip" {
  value = "${alicloud_slb.skillet-int-LB.address}"
}
