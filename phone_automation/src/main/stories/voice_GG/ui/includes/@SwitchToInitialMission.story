Scenario: Change mission
When HMI OP1 presses function key MISSIONS
Then HMI OP1 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission MAN-NIGHT-TACT

Scenario: Change to mission
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission WEST-EXEC
