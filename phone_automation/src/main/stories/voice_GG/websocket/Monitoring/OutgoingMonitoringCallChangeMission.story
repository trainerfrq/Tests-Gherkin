Narrative:
As an operator having outgoing position monitoring calls enabled
I want to send monitoring call and change mission
So I can verify that outgoing monitoring call is not affected by this action

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

Scenario: Op1 associates with Op Voice Service
When WS1 associates with Op Voice Service using opId ${OP_VOICE_PARTITION_KEY_1} and appId app1
Then WS1 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer1 and names the availableMissionIds1
Then WS1 receives mission changed indication on message buffer named MissionChangedIndicationBuffer1 and names missionId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Op3 associates with Op Voice Service
When WS3 associates with Op Voice Service using opId ${OP_VOICE_PARTITION_KEY_3} and appId app3
Then WS3 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer3 and names the availableMissionIds3
And WS3 receives mission changed indication on message buffer named MissionChangedIndicationBuffer3 and names missionId3
Then WS3 confirms mission change completed for mission missionId3

Scenario: Op1 changes its mission
When WS1 chooses mission with name <<MISSION_1_NAME>> from available missions named availableMissionIds1 and names missionIdToChange1
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1 and roleId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Op3 changes its mission
When WS3 chooses mission with name <<MISSION_3_NAME>> from available missions named availableMissionIds3 and names missionIdToChange3
Then WS3 receives mission changed indication on buffer named MissionChangedIndicationBuffer3 equal to missionIdToChange3 and names missionId3 and roleId3
Then WS3 confirms mission change completed for mission missionId3

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS1 opens the message buffer for message type queryFullCallStatusResponse named FullCallStatusResponseBuffer1

When WS3 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer3
When WS3 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer3
When WS3 opens the message buffer for message type queryFullCallStatusResponse named FullCallStatusResponseBuffer3

Scenario: Op1 retrieves phone data
When WS1 queries phone data for mission missionId1 in order to call OP3 and names them monitoringCallSource1 and monitoringCallTarget1

Scenario: Op1 establishes an outgoing monitoring call to Op3
		  @REQUIREMENTS:GID-2505728
When WS1 establishes an outgoing monitoring call with source monitoringCallSource1 , target monitoringCallTarget1 and monitoring type GG and names outgoingMonitoringCallId1
And waiting for 1 second
Then WS1 is receiving call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingMonitoringCallId1 and status connected and audio direction RX_MONITORED

Scenario: Op3 does not receive the incoming monitoring call
When WS3 does not receive call incoming indication for monitoring call on message buffer named CallIncomingIndicationBuffer3

Scenario: Op1 does a full call status request
When WS1 queries full call status
Then WS1 receives full call status on message buffer named FullCallStatusResponseBuffer1 with monitoringCallSource1 , monitoringCallTarget1 , MONITORING , RX_MONITORED , connected , GG and NON-URGENT

Scenario: Op3 does a full call status request
When WS3 queries full call status
Then WS3 receives full call status on message buffer named FullCallStatusResponseBuffer3 with call status empty

Scenario: Op1 changes its mission to a mission that has incoming and outgoing monitoring disabled
When WS1 chooses mission with name <<MISSION_2_NAME>> from available missions named availableMissionIds1 and names missionIdToChange2
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange2 and names missionId2 and roleId2
Then WS1 confirms mission change completed for mission missionId2

Scenario: Op1 does a full call status request
When WS1 queries full call status
Then WS1 receives full call status on message buffer named FullCallStatusResponseBuffer1 with monitoringCallSource1 , monitoringCallTarget1 , MONITORING , RX_MONITORED , connected , GG and NON-URGENT

Scenario: Op3 does a full call status request
When WS3 queries full call status
Then WS3 receives full call status on message buffer named FullCallStatusResponseBuffer3 with call status empty

Scenario: Op1 changes its mission back
When WS1 chooses mission with name <<MISSION_1_NAME>> from available missions named availableMissionIds1 and names missionIdToChange4
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange4 and names missionId4 and roleId4
Then WS1 confirms mission change completed for mission missionId4

Scenario: Op1 does a full call status request
When WS1 queries full call status
Then WS1 receives full call status on message buffer named FullCallStatusResponseBuffer1 with monitoringCallSource1 , monitoringCallTarget1 , MONITORING , RX_MONITORED , connected , GG and NON-URGENT

Scenario: Op3 does a full call status request
When WS3 queries full call status
Then WS3 receives full call status on message buffer named FullCallStatusResponseBuffer3 with call status empty

Scenario: Op1 cleans up phone call
When WS1 clears the phone call with the callId outgoingMonitoringCallId1
And waiting for 1 second
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingMonitoringCallId1 and terminationDetails normal

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallIncomingIndicationBuffer1
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS1 removes the message buffer named FullCallStatusResponseBuffer1
When the named websocket WS3 removes the message buffer named CallIncomingIndicationBuffer3
When the named websocket WS3 removes the message buffer named CallStatusIndicationBuffer3
When the named websocket WS3 removes the message buffer named FullCallStatusResponseBuffer3

Scenario: Delete the message buffers for missions
When the named websocket WS1 removes the message buffer named MissionsAvailableIndicationBuffer1
When the named websocket WS1 removes the message buffer named MissionChangedIndicationBuffer1
When the named websocket WS3 removes the message buffer named MissionsAvailableIndicationBuffer3
When the named websocket WS3 removes the message buffer named MissionChangedIndicationBuffer3

Scenario: Cleanup
When WS1 disassociates from Op Voice Service
When WS2 disassociates from Op Voice Service
When WS3 disassociates from Op Voice Service

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection
When WS2 closes websocket client connection
When WS3 closes websocket client connection
