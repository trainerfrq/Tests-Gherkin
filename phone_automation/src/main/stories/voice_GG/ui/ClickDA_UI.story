Scenario: Booking profiles
Given booked profiles:
| profile | group | host       |
| javafx  | hmi   | <<CO1_IP>> |

Scenario: Caller establishes an outgoing call
When waiting for 3 seconds
When client press DA key with id 700 using the profile javafx hmi
And waiting for 6 seconds
Then DA key with id 700 of the javafx hmi is in state out_trying

Scenario: Caller client clears the phone call
When client press DA key with id 700 using the profile javafx hmi
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId incomingPhoneCallId and terminationDetails normal
Then DA key with id 700 of the javafx hmi is in state terminated

