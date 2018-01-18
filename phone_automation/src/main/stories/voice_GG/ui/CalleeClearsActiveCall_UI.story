Scenario: Booking profiles
Given booked profiles:
| profile   | group | host       |
| javafx    | hmi   | <<CO1_IP>> |
| websocket | hmi   | <<CO1_IP>> |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-1 | <<OPVOICE2_WS.URI>> | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| key | profile-name | websocket-config-name |
| WS1 | WEBSOCKET 1  | WS_Config-1           |

Scenario: Create the message buffers for missions
When WS1 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer1
When WS1 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer1

Scenario: Callee client associates with Op Voice Service
When WS1 associates with Op Voice Service using opId op4 and appId voiceapp
Then WS1 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer1 and names the availableMissionIds1
And WS1 receives mission changed indication on message buffer named MissionChangedIndicationBuffer1 and names missionId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Callee client changes its mission
When WS1 chooses mission with index 1 from available missions named availableMissionIds1 and names missionIdToChange1
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1  and roleId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Delete the message buffers for missions
When the named websocket WS1 removes the message buffer named MissionsAvailableIndicationBuffer1
When the named websocket WS1 removes the message buffer named MissionChangedIndicationBuffer1

Scenario: Create the message buffers for calls
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target callTarget and names outgoingPhoneCallId
And waiting for 3 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Callee client receives the incoming call
Then DA key with id 700 of the javafx hmi is in state ringing

Scenario: Callee client answers the incoming call
When waiting for 6 seconds
When client press DA key with id 700 using the profile javafx hmi
When waiting for 3 seconds
Then DA key with id 700 of the javafx hmi is in state connected
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status connected
Then waiting for 3 seconds

Scenario: Callee client clears the phone call
When client press DA key with id 700 using the profile javafx hmi
Then DA key with id 700 of the javafx hmi is in state terminated
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails normal

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1

Scenario: Cleanup
When WS1 disassociates from Op Voice Service

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection

