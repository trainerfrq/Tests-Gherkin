Scenario: Booking profiles
Given booked profiles:
| profile | group | host       | identifier |
| javafx  | hmi   | <<CO1_IP>> | HMI01      |

Scenario: Caller establishes an outgoing call
When waiting for 3 seconds
When client press DA key with id 700 using the profile HMI01
And waiting for 6 seconds
Then DA key with id 700 of the HMI01 is in state out_ringing

Scenario: Caller client clears the phone call
When client press DA key with id 700 using the profile HMI01
Then DA key with id 700 of the HMI01 is in state terminated

