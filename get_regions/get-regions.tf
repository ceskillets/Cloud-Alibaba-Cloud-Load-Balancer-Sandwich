
# Configure the Alicloud Provider
provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}


data "alicloud_regions" "regions_ds" {
}

output "regions_id" {
  value = ["${data.alicloud_regions.regions_ds.regions}"]
}