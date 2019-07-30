# Deploy Base Config to VM-Series

Description:
- This skillet deploys Base Config to VM-Series. This step is required as bootstrapping of VM-Series on Alicloud is not supported yet. In future, when bootstrapping is supported, this step will not be required.
- As the image used is the base KVM image, the default username/password can be used to log into the VM-Series.
- Please wait at least 5 mins after the VM-Series has been deployed in the previous step to run this step.


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
