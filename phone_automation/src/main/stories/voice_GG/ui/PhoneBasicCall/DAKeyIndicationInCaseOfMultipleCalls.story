Narrative:
As an operator
I want to receive multiple calls dedicated to the same DA key
So I can verify that the DA key shall show and handle only the proper one

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: OP1 establishes an outgoing call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing
Then HMI OP2 has the DA key OP1 in state ringing

Scenario: OP3 establishes an outgoing call
When HMI OP3 presses DA key OP2(as OP1)
Then HMI OP3 has the DA key OP2(as OP1) in state out_ringing
Then HMI OP2 has the DA key OP1 in state ringing

Scenario: OP2 answers the Pending Call with the longest pending duration, using the DA key OP1
		  @REQUIREMENTS:GID-4023661
When HMI OP2 presses DA key OP1
Then HMI OP1 has the DA key OP2(as OP1) in state connected
Then HMI OP2 has the DA key OP1 in state connected
Then HMI OP3 has the DA key OP2(as OP1) in state out_ringing

Scenario: OP2 puts on hold the active call, using the DA key OP1
When HMI OP2 puts on hold the active call using DA key OP1
Then HMI OP1 has the DA key OP2(as OP1) in state hold
Then HMI OP2 has the DA key OP1 in state held
Then HMI OP3 has the DA key OP2(as OP1) in state out_ringing

Scenario: OP2 retrieves the call from hold, using the DA key OP1
When HMI OP2 presses DA key OP1
Then HMI OP1 has the DA key OP2(as OP1) in state connected
Then HMI OP2 has the DA key OP1 in state connected
Then HMI OP3 has the DA key OP2(as OP1) in state out_ringing

Scenario: OP2 clears the active call, using the DA key OP1
When HMI OP2 presses DA key OP1

Scenario: DA key shows the incoming call
Then HMI OP2 has the DA key OP1 in state ringing
Then HMI OP3 has the DA key OP2(as OP1) in state out_ringing

Scenario: OP2 answers the incoming call, using the DA key OP1
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state connected
Then HMI OP3 has the DA key OP2(as OP1) in state connected

Scenario: OP2 clears the active call, using the DA key OP1
When HMI OP2 presses DA key OP1

Scenario: Call is terminated for all operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls
