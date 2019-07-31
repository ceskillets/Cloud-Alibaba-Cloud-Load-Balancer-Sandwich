# Deploy LB Sandwich on Alicloud using Terraform

Prequisites:
- Create a custom image to launch the PA VM
  - https://docs.paloaltonetworks.com/vm-series/9-0/vm-series-deployment/set-up-the-vm-series-firewall-on-alibaba-cloud/prepare-to-deploy-the-vm-series-firewall-on-alibaba-cloud.html#idd95814fd-ab5f-4a67-a060-e9858975316c
  - Your custom image name must start with "vm-series-9.0.1"  

Description:
- This skillet deploys a LB Sandwich on Alicloud, deploying two VM-Series, two web servers, one external LB and one internal LB.



## Support Policy
The code and templates in the repo are released under an as-is, best effort,
support policy. These scripts should be seen as community supported and
Palo Alto Networks will contribute our expertise as and when possible.
We do not provide technical support or help in using or troubleshooting the
components of the project through our normal support options such as
Palo Alto Networks support teams, or ASC (Authorized Support Centers)
partners and backline support options. The underlying product used
(the VM-Series firewall) by the scripts or templates are still supported,
but the support is only for the product functionality and not for help in
deploying or using the template or script itself. Unless explicitly tagged,
all projects or work posted in our GitHub repository
(at https://github.com/PaloAltoNetworks) or sites other than our official
Downloads page on https://support.paloaltonetworks.com are provided under
the best effort policy.
