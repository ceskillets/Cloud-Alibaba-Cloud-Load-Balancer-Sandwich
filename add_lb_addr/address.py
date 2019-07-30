import requests
import xml.etree.ElementTree as ET
from python_terraform import Terraform
import argparse
import urllib3


urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

working_dir = "../deploy"

tf = Terraform(working_dir=working_dir)
outputs = tf.output()
fw1_public_ip = outputs['fw1_public_ip']['value']
fw2_public_ip = outputs['fw2_public_ip']['value']
int_lb_ip = outputs['int_lb_ip']['value']
ext_lb_public_ip = outputs['ext_lb_public_ip']['value']

fw1_mgmt = fw1_public_ip
fw2_mgmt = fw2_public_ip


parser = argparse.ArgumentParser()
parser.add_argument("-p", "--password", help="Example Password", type=str)
args = parser.parse_args()

username = "admin"
password = args.password



url = "https://%s/api/?type=keygen&user=%s&password=%s" % (fw1_mgmt, username, password)
response = requests.get(url, verify=False)
fw1_api_key = ET.XML(response.content)[0][0].text

url = "https://%s/api/?type=keygen&user=%s&password=%s" % (fw2_mgmt, username, password)
response = requests.get(url, verify=False)
fw2_api_key = ET.XML(response.content)[0][0].text


# FW1
url = "https://%s/api/?key=%s&type=config&action=set&xpath=/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/address&element=<entry name='Int-LB'><ip-netmask>%s</ip-netmask></entry>" % (fw1_mgmt, fw1_api_key, int_lb_ip)
response = requests.get(url, verify=False)
#print response.text

url = "https://%s/api/?key=%s&type=commit&cmd=<commit></commit>" % (fw1_mgmt, fw1_api_key)
response = requests.get(url, verify=False)
#print response.text


# FW2
url = "https://%s/api/?key=%s&type=config&action=set&xpath=/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/address&element=<entry name='Int-LB'><ip-netmask>%s</ip-netmask></entry>" % (fw2_mgmt, fw2_api_key, int_lb_ip)
response = requests.get(url, verify=False)

url = "https://%s/api/?key=%s&type=commit&cmd=<commit></commit>" % (fw2_mgmt, fw2_api_key)
response = requests.get(url, verify=False)



# Print External LB IP Address and FW MGMT IP addresses
url = "You can access the web service using http://%s\n" % (ext_lb_public_ip)
print(url)

url = "You can access FW1 using https://%s\n" % (fw1_public_ip)
print(url)

url = "You can access FW2 using https://%s\n" % (fw2_public_ip)
print(url)

print("Please redo Step 1 and choose the Destroy option to tear down the environment\n")

