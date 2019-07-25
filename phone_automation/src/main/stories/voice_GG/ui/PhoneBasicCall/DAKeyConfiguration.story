Narrative:
As an operator
I want to configurate a DA key
So I can verify that the call is established properly

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key       | source           | target           | callType |
| OP1-OP2-1 | <<OP1_URI>>      | <<OP2_URI>>      | DA/IDA   |
| OP1-OP2-2 | <<MISSION3_URI>> | <<OP2_URI>>      | DA/IDA   |
| OP1-OP2-3 | <<OP1_URI>>      | <<MISSION2_URI>> | DA/IDA   |
| OP2-OP1-3 | <<MISSION2_URI>> | <<OP1_URI>>      | DA/IDA   |

Scenario: Outgoing DA call using as source Physical OP SIP Address
		  @REQUIREMENTS:GID-4123501
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP2 has the call queue item OP1-OP2-1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2-1 in the waiting list with name label <<OP1_NAME>>
When HMI OP1 presses DA key OP2

Scenario: Outgoing DA call using as source another specific SIP address
When HMI OP1 presses DA key OP2(as Mission3)
Then HMI OP1 has the DA key OP2(as Mission3) in state out_ringing
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP2 has the call queue item OP1-OP2-2 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2-2 in the waiting list with name label <<MISSION_3_NAME>>
When HMI OP1 presses DA key OP2(as Mission3)

Scenario: Outgoing DA call using as source the default SIP address
When HMI OP2 presses DA key OP1(as Mission2)
Then HMI OP2 has the DA key OP1(as Mission2) in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2-3 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1-3 in the waiting list with name label <<MISSION_2_NAME>>
Then HMI OP1 has in the waiting list a number of 1 calls
When HMI OP2 presses DA key OP1(as Mission2)

Scenario: Verify call is terminated for both operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
