Scenario: Create a virtual machine and boot it with the deployment ISO image with template. Wait for the deployment to finish and verify that the deploymentServer is accesible via SSH.
Given xvp test system
When booting machine deploymentServer from ISO image <<boot.iso.url>>
When waiting for 30 seconds
Then ssh connection can be established to deploymentServer within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on deploymentServer and check output active 0

Scenario: Create dockerhost1 machine with PXE boot enabled and verify that dockerhost1 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine dockerhost1
And waiting for 60 seconds
Then ssh connection can be established to dockerhost1 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on dockerhost1 and check output active 0

Scenario: Create dockerhost2 machine with PXE boot enabled and verify that dockerhost2 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine dockerhost2
And waiting for 60 seconds
Then ssh connection can be established to dockerhost2 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on dockerhost2 and check output active 0

Scenario: Create dockerhost3 machine with PXE boot enabled and verify that dockerhost2 is accessible via SSH after the deployment has completed
Given xvp test system
When rebooting the machine dockerhost3
And waiting for 60 seconds
Then ssh connection can be established to dockerhost3 within 13 minutes
And verify start xvp deployment agent process finished with command systemctl is-active xvp-deployment-agent; echo $? on dockerhost3 and check output active 0

