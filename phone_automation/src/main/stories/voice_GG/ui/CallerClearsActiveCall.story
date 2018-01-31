Scenario: Caller establishes an outgoing call
When OP1 presses DA key for OP2
Then OP1 has the DA key for OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then OP2 has the DA key for OP1 in state ringing

Scenario: Callee client answers the incoming call
When OP2 presses DA key for OP2
Then OP1 has the DA key for OP2 in state connected
Then OP2 has the DA key for OP1 in state connected

Scenario: Caller client clears the phone call
When OP1 presses DA key for OP2
Then OP1 has the DA key for OP2 in state terminated
Then OP2 has the DA key for OP1 in state terminated

