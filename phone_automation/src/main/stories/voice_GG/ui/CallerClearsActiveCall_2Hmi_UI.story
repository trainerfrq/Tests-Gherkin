Scenario: Booking profiles
Given booked profiles:
| profile | group | host       | identifier |
| javafx  | hmi   | <<CO1_IP>> | HMI01      |
| javafx  | hmi   | <<CO2_IP>> | HMI02      |

Scenario: Caller establishes an outgoing call
When waiting for 3 seconds
When client press DA key with id 700 using the profile HMI01
And waiting for 6 seconds
Then DA key with id 700 of the HMI01 is in state out_ringing

Scenario: Callee client receives the incoming call
Then DA key with id 702 of the HMI02 is in state ringing

Scenario: Callee client answers the incoming call
When waiting for 6 seconds
When client press DA key with id 702 using the profile HMI02
When waiting for 3 seconds
Then DA key with id 702 of the HMI02 is in state connected
Then DA key with id 700 of the HMI01 is in state connected

Scenario: Caller client clears the phone call
When waiting for 6 seconds
When client press DA key with id 700 using the profile HMI01
Then DA key with id 700 of the HMI01 is in state terminated
Then DA key with id 702 of the HMI02 is in state terminated

