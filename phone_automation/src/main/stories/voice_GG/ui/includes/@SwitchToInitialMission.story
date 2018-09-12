Scenario: Change mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission 1
Then HMI OP1 press button Activate Mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has the assigned mission MAN-NIGHT-TACT

Scenario: Change to mission
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission 0
Then HMI OP2 press button Activate Mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has the assigned mission WEST-EXEC
