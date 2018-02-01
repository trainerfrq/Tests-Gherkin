Scenario: Booking profiles
Given booked profiles:
| profile | group | host       | identifier |
| javafx  | hmi   | <<CO1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CO2_IP>> | HMI OP2    |

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key for OP2
Then HMI OP1 has the DA key for OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key for OP1 in state ringing

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key for OP2
Then HMI OP1 has the DA key for OP2 in state connected
Then HMI OP2 has the DA key for OP1 in state connected

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key for OP2
Then HMI OP1 has the DA key for OP2 in state terminated
Then HMI OP2 has the DA key for OP1 in state terminated

