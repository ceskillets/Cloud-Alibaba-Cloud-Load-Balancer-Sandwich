import requests
import xml.etree.ElementTree as ET
import argparse
import urllib3
import subprocess
import sys

def install(package):
    subprocess.call([sys.executable, "-m", "pip", "install", package])

install('python_terraform')

try:
    from python_terraform import Terraform
except ImportError:
    install('python_terraform')
    from python_terraform import Terraform


urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

working_dir = "../deploy"

tf = Terraform(working_dir=working_dir)
outputs = tf.output()
fw1_mgmt = outputs['fw1_public_ip']['value']
fw2_mgmt = outputs['fw2_public_ip']['value']

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--password", help="Example Password", type=str)
args = parser.parse_args()

username = "admin"
password = args.password


# Get API Key
url = "https://%s/api/?type=keygen&user=%s&password=%s" % (fw1_mgmt, username, password)
response = requests.get(url, verify=False)
fw1_api_key = ET.XML(response.content)[0][0].text

url = "https://%s/api/?type=keygen&user=%s&password=%s" % (fw2_mgmt, username, password)
response = requests.get(url, verify=False)
fw2_api_key = ET.XML(response.content)[0][0].text


# Upload base config
url = "https://%s/api/?type=import&category=configuration&key=%s" % (fw1_mgmt, fw1_api_key)
config_file = {'file': open('fw1-cfg.xml', 'rb')}
response = requests.post(url, files=config_file, verify=False)
#print response.text


url = "https://%s/api/?type=import&category=configuration&key=%s" % (fw2_mgmt, fw2_api_key)
config_file = {'file': open('fw2-cfg.xml', 'rb')}
response = requests.post(url, files=config_file, verify=False)
#print response.text


# Load the config
url = "https://%s/api/?type=op&cmd=<load><config><from>fw1-cfg.xml</from></config></load>&key=%s" % (fw1_mgmt, fw1_api_key)
response = requests.get(url, verify=False)
#print response.text

url = "https://%s/api/?type=op&cmd=<load><config><from>fw2-cfg.xml</from></config></load>&key=%s" % (fw2_mgmt, fw2_api_key)
response = requests.get(url, verify=False)
#print response.text


# Commit config
url = " https://%s/api/?key=%s&type=commit&cmd=<commit></commit>" % (fw1_mgmt, fw1_api_key)
response = requests.get(url, verify=False)
#print response.text

url = " https://%s/api/?key=%s&type=commit&cmd=<commit></commit>" % (fw2_mgmt, fw2_api_key)
response = requests.get(url, verify=False)
#print response.text


print("Base config has been uploaded to the VM-Series. Please use new password for Step 3")