Scenario: Create additional virtual machines to environment

Scenario: Create CAT-VST02-17 machine with PXE boot enabled and verify that DOC-VST02-11 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine CAT-VST02-17
And waiting for 130 seconds
Then ssh connection can be established to CAT-VST02-17 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on CAT-VST02-17 and check output active 0

Scenario: Create CAT-VST02-18 machine with PXE boot enabled and verify that DOC-VST02-11 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine CAT-VST02-18
And waiting for 130 seconds
Then ssh connection can be established to CAT-VST02-18 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on CAT-VST02-18 and check output active 0
