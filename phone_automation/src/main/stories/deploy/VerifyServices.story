Scenario: Connect to hosts
Given xvp test system
And ssh connection to host dockerhost1
And ssh connection to host dockerhost2
And ssh connection to host dockerhost3
Then verify that the services were started:
| serviceName | virtualMachineName | runningStatus |
| op_voice01  | dockerhost1        | yes           |
| op_voice02  | dockerhost2        | yes           |
| op_voice03  | dockerhost3        | yes           |
