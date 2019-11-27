Narrative:
As a called operator having monitoring audio to incoming IA call activated and an incoming one-way IA Call
I want to establish another one-way IA Call towards the calling operator and change mission
So that I can verify that monitoring audio to incoming IA call and duplex IA call works as expected

Scenario: Booking profiles
Given booked profiles:
| profile   | group | host       |
| websocket | hmi   | <<CO3_IP>> |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-1 | <<OPVOICE1_WS.URI>> | 1000             |
| WS_Config-2 | <<OPVOICE2_WS.URI>> | 1000             |
| WS_Config-3 | <<OPVOICE3_WS.URI>> | 1000             |
| WS_Config-4 | <<OPVOICE4_WS.URI>> | 1000             |
| WS_Config-5 | <<OPVOICE5_WS.URI>> | 1000             |
| WS_Config-6 | <<OPVOICE6_WS.URI>> | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| profile-name | websocket-config-name |
| WEBSOCKET 1  | WS_Config-1           |
| WEBSOCKET 1  | WS_Config-2           |
| WEBSOCKET 1  | WS_Config-3           |
| WEBSOCKET 1  | WS_Config-4           |
| WEBSOCKET 1  | WS_Config-5           |
| WEBSOCKET 1  | WS_Config-6           |

Scenario: Create the message buffers for missions
When WS1 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer1
When WS1 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer1
When WS3 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer3
When WS3 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer3

Scenario: First client associates with Op Voice Service
When WS1 associates with Op Voice Service using opId ${OP_VOICE_PARTITION_KEY_1} and appId app1
Then WS1 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer1 and names the availableMissionIds1
Then WS1 receives mission changed indication on message buffer named MissionChangedIndicationBuffer1 and names missionId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Third client associates with Op Voice Service
When WS3 associates with Op Voice Service using opId ${OP_VOICE_PARTITION_KEY_3} and appId app3
Then WS3 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer3 and names the availableMissionIds3
And WS3 receives mission changed indication on message buffer named MissionChangedIndicationBuffer3 and names missionId3
Then WS3 confirms mission change completed for mission missionId3

Scenario: Caller client changes its mission
When WS1 chooses mission with name <<MISSION_1_NAME>> from available missions named availableMissionIds1 and names missionIdToChange1
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1 and roleId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Third client changes its mission
When WS3 chooses mission with name <<MISSION_3_NAME>> from available missions named availableMissionIds3 and names missionIdToChange3
Then WS3 receives mission changed indication on buffer named MissionChangedIndicationBuffer3 equal to missionIdToChange3 and names missionId3 and roleId3
Then WS3 confirms mission change completed for mission missionId3

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS3 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1
When WS3 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS1 opens the message buffer for message type queryFullCallStatusResponse named FullCallStatusResponseBuffer1
When WS3 opens the message buffer for message type queryFullCallStatusResponse named FullCallStatusResponseBuffer2

Scenario: Clients retrieve phone data
When WS1 queries phone data for mission missionId1 in order to call IA - OP3 and names them callSourceCalling and callTargetCalling
When WS3 queries phone data for mission missionId3 in order to call IA - OP1 and names them callSourceCalled and callTargetCalled

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing IA call with source callSourceCalling and target callTargetCalling and names outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 is receiving call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId1 and status connected and audio direction TX_MONITORED

Scenario: Callee client receives the incoming call
When WS3 receives call incoming indication for IA call on message buffer named CallIncomingIndicationBuffer2 with callSourceCalling , callTargetCalling , audio direction RX_MONITORED and monitoring type ALL and names incomingPhoneCallId1

Scenario: Caller client changes its mission
When WS1 chooses mission with name <<MISSION_2_NAME>> from available missions named availableMissionIds1 and names missionIdToChange2
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange2 and names missionId2 and roleId2
Then WS1 confirms mission change completed for mission missionId2

Scenario: Caller does a full call status request
		  @REQUIREMENTS:GID-2841714
When WS1 queries full call status
!-- Fails due to Problem Report PVCSX - 2005
Then WS1 receives full call status on message buffer named FullCallStatusResponseBuffer1 with callSourceCalling , callTargetCalling , IA , TX_MONITORED , connected , ALL and URGENT

Scenario: Callee establishes an outgoing call
When WS3 establishes an outgoing IA call with source callSourceCalled and target callTargetCalled and names outgoingPhoneCallId2
And waiting for 1 seconds
Then WS3 is receiving call status indication on message buffer named CallStatusIndicationBuffer2 with callId outgoingPhoneCallId2 and status connected and audio direction DUPLEX

Scenario: Caller client receives the incoming call
When WS1 receives call incoming indication for IA call on message buffer named CallIncomingIndicationBuffer1 with callSourceCalled , callTargetCalled , audio direction DUPLEX and monitoring type GG and names incomingPhoneCallId2

Scenario: Third client changes its mission
When WS3 chooses mission with name <<MISSION_2_NAME>> from available missions named availableMissionIds3 and names missionIdToChange4
Then WS3 receives mission changed indication on buffer named MissionChangedIndicationBuffer3 equal to missionIdToChange4 and names missionId4 and roleId4
Then WS3 confirms mission change completed for mission missionId4

Scenario: Callee does a full call status request
When WS3 queries full call status
Then WS3 receives full call status on message buffer named FullCallStatusResponseBuffer2 with callSourceCalled , callTargetCalled , IA , DUPLEX , connected , ALL and URGENT

Scenario: Caller cleans up phone call
When WS1 clears the phone call with the callId outgoingPhoneCallId1
And waiting for 1 seconds
Then WS1 is receiving call status indication on message buffer named  CallStatusIndicationBuffer1 with callId incomingPhoneCallId2 and status connected and audio direction RX_MONITORED
Then WS3 is receiving call status indication on message buffer named CallStatusIndicationBuffer2 with callId outgoingPhoneCallId2 and status connected and audio direction TX_MONITORED

Scenario: Caller client changes its mission
When WS1 chooses mission with name <<MISSION_1_NAME>> from available missions named availableMissionIds1 and names missionIdToChange1
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1 and roleId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Third client changes its mission
When WS3 chooses mission with name <<MISSION_3_NAME>> from available missions named availableMissionIds3 and names missionIdToChange3
Then WS3 receives mission changed indication on buffer named MissionChangedIndicationBuffer3 equal to missionIdToChange3 and names missionId3 and roleId3
Then WS3 confirms mission change completed for mission missionId3

Scenario: Caller does a full call status request
When WS1 queries full call status
Then WS1 receives full call status on message buffer named FullCallStatusResponseBuffer1 with callSourceCalling , callTargetCalling , IA , RX_MONITORED , connected , ALL and URGENT

Scenario: Callee does a full call status request
When WS3 queries full call status
Then WS3 receives full call status on message buffer named FullCallStatusResponseBuffer2 with callSourceCalled , callTargetCalled , IA , TX_MONITORED , connected , ALL and URGENT

Scenario: Callee cleans up phone call
When WS3 clears the phone call with the callId outgoingPhoneCallId2
And waiting for 1 seconds

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS3 removes the message buffer named CallStatusIndicationBuffer2
When the named websocket WS1 removes the message buffer named CallIncomingIndicationBuffer1
When the named websocket WS3 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS1 removes the message buffer named FullCallStatusResponseBuffer1
When the named websocket WS3 removes the message buffer named FullCallStatusResponseBuffer2

Scenario: Delete the message buffers for missions
When the named websocket WS1 removes the message buffer named MissionsAvailableIndicationBuffer1
When the named websocket WS1 removes the message buffer named MissionChangedIndicationBuffer1
When the named websocket WS3 removes the message buffer named MissionsAvailableIndicationBuffer3
When the named websocket WS3 removes the message buffer named MissionChangedIndicationBuffer3
