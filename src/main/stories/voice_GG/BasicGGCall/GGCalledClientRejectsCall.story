Scenario: Simulate an HMI to initiate and answer a GG Call
		  @REQUIREMENTS:GID-2535689

Scenario: Booking profiles
Given booked profiles:
| profile   | group | host       |
| websocket | hmi   | <<CO1_IP>> |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-1 | <<OPVOICE1_WS.URI>> | 1000             |
| WS_Config-2 | <<OPVOICE2_WS.URI>> | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| key | profile-name | websocket-config-name |
| WS1 | WEBSOCKET 1  | WS_Config-1           |
| WS2 | WEBSOCKET 1  | WS_Config-2           |


Scenario: Create the message buffers
When WS1 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer1
When WS1 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer1
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer2
When WS2 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer2
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client associates with Op Voice Service
When WS1 associates with Op Voice Service using opId op1 and appId app1
Then WS1 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer1 and names the availableMissionIds1
Then WS1 receives mission changed indication on message buffer named MissionChangedIndicationBuffer1 and names missionId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Called client associates with Op Voice Service
When WS2 associates with Op Voice Service using opId op2 and appId app2
Then WS2 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer2 and names the availableMissionIds2
And WS2 receives mission changed indication on message buffer named MissionChangedIndicationBuffer2 and names missionId2
Then WS2 confirms mission change completed for mission missionId2

Scenario: Caller client changes its mission
When WS1 chooses mission with index 0 from available missions named availableMissionIds1 and names missionIdToChange1
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1 and roleId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Called client changes its mission
When WS2 chooses mission with index 0 from available missions named availableMissionIds2 and names missionIdToChange2
Then WS2 receives mission changed indication on buffer named MissionChangedIndicationBuffer2 equal to missionIdToChange2 and names missionId2  and roleId2
Then WS2 confirms mission change completed for mission missionId2

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target callTarget and names outgoingPhoneCallId
And waiting for 3 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_trying

Scenario: Called client receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId
And WS2 confirms incoming phone call with callId incomingPhoneCallId
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Called client rejects the incoming call
When WS2 clears the phone call with the callId incomingPhoneCallId
And waiting for 3 seconds
Then WS2 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and terminationDetails normal
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails busy

Scenario: Cleanup
When WS1 disassociates from Op Voice Service
When WS2 disassociates from Op Voice Service

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named MissionsAvailableIndicationBuffer1
When the named websocket WS1 removes the message buffer named MissionChangedIndicationBuffer1
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named MissionsAvailableIndicationBuffer2
When the named websocket WS2 removes the message buffer named MissionChangedIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection
When WS2 closes websocket client connection
