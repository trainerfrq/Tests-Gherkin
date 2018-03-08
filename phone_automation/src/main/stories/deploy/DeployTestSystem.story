Scenario: Create a virtual machine and boot it with the deployment ISO image with template. Wait for the deployment to finish and verify that the deploymentServer is accesible via SSH.
Given xvp test system
When booting machine DOC-VST02-10 from ISO image <<boot.iso.url>>
When waiting for 800 seconds
Then ssh connection can be established to DOC-VST02-10 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on DOC-VST02-10 and check output active 0

Scenario: Create DOC-VST02-11 machine with PXE boot enabled and verify that DOC-VST02-11 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine DOC-VST02-11
And waiting for 130 seconds
Then ssh connection can be established to DOC-VST02-11 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on DOC-VST02-11 and check output active 0

Scenario: Create DOC-VST02-12 machine with PXE boot enabled and verify that DOC-VST02-12 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine DOC-VST02-12
And waiting for 130 seconds
Then ssh connection can be established to DOC-VST02-12 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on DOC-VST02-12 and check output active 0

Scenario: Create DOC-VST02-13 machine with PXE boot enabled and verify that DOC-VST02-11 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine DOC-VST02-13
And waiting for 130 seconds
Then ssh connection can be established to DOC-VST02-13 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on DOC-VST02-13 and check output active 0

Scenario: Create CWP-VST02-14 machine with PXE boot enabled and verify that CWP-VST02-14 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine CWP-VST02-14
And waiting for 130 seconds
Then ssh connection can be established to CWP-VST02-14 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on CWP-VST02-14 and check output active 0

Scenario: Create CWP-VST02-15 machine with PXE boot enabled and verify that CWP-VST02-15 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine CWP-VST02-15
And waiting for 60 seconds
Then ssh connection can be established to CWP-VST02-15 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on CWP-VST02-15 and check output active 0

Scenario: Create CWP-VST02-16 machine with PXE boot enabled and verify that CWP-VST02-16 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine CWP-VST02-16
And waiting for 60 seconds
Then ssh connection can be established to CWP-VST02-16 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on CWP-VST02-16 and check output active 0
