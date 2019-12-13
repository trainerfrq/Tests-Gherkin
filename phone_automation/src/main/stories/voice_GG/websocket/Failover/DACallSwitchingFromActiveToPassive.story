Narrative:
As a callee operator using a redundant Op Voice service
I want to make a phone call
So I can verify that the phone call is always made even when op voice instances are restarted

Meta: @AfterStory: ../includes/@StoreMetrics.story

Scenario: Booking profiles
Given booked profiles:
| profile   | group | host       |
| websocket | hmi   | <<CO3_IP>> |

Scenario: Open Web Socket Client connections
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-1 | <<OPVOICE1_WS.URI>> | 1000             |
| WS_Config-2 | <<OPVOICE3_WS.URI>> | 1000             |
| WS_Config-3 | <<OPVOICE2_WS.URI>> | 1000             |
| WS_Config-4 | <<OPVOICE4_WS.URI>> | 1000             |

Scenario: Open Web Socket Client connections
		  @REQUIREMENTS:GID-4461959
When a timer named failoverTimerWS1 is started
Given it is known what op voice instances are Active, the websocket configuration is applied:
| key | profile-name | websocket-config-name |
| WS1 | WEBSOCKET 1  | WS_Config-1           |
Then a timer named failoverTimerWS1 is stopped

When a timer named failoverTimerWS2 is started
Given it is known what op voice instances are Active, the websocket configuration is applied:
| key | profile-name | websocket-config-name |
| WS2 | WEBSOCKET 1  | WS_Config-2           |
Then a timer named failoverTimerWS2 is stopped

Scenario: Create the message buffers for missions
When WS1 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer1
When WS1 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer1
When WS2 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer2
When WS2 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer2

Scenario: Caller client associates with Op Voice Service
When WS1 associates with Op Voice Service using opId ${OP_VOICE_PARTITION_KEY_1} and appId app1
Then WS1 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer1 and names the availableMissionIds1
Then WS1 receives mission changed indication on message buffer named MissionChangedIndicationBuffer1 and names missionId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Callee client associates with Op Voice Service
When WS2 associates with Op Voice Service using opId ${OP_VOICE_PARTITION_KEY_2} and appId app2
Then WS2 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer2 and names the availableMissionIds2
And WS2 receives mission changed indication on message buffer named MissionChangedIndicationBuffer2 and names missionId2
Then WS2 confirms mission change completed for mission missionId2

Scenario: Caller client changes its mission
When WS1 chooses mission with name <<MISSION_1_NAME>> from available missions named availableMissionIds1 and names missionIdToChange1
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1 and roleId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Callee client changes its mission
When WS2 chooses mission with name <<MISSION_2_NAME>> from available missions named availableMissionIds2 and names missionIdToChange2
Then WS2 receives mission changed indication on buffer named MissionChangedIndicationBuffer2 equal to missionIdToChange2 and names missionId2  and roleId2
Then WS2 confirms mission change completed for mission missionId2

Scenario: Delete the message buffers for missions
When the named websocket WS1 removes the message buffer named MissionsAvailableIndicationBuffer1
When the named websocket WS1 removes the message buffer named MissionChangedIndicationBuffer1
When the named websocket WS2 removes the message buffer named MissionsAvailableIndicationBuffer2
When the named websocket WS2 removes the message buffer named MissionChangedIndicationBuffer2

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS2 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS1 queries phone data for mission missionId1 in order to call OP2 and names them callSource and callTarget

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target callTarget and names outgoingPhoneCallId
And waiting for 6 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_trying

Scenario: Callee client receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId
And WS2 confirms incoming phone call with callId incomingPhoneCallId
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Callee client answers the incoming call
When WS2 answers the incoming phone call with the callId incomingPhoneCallId
Then WS2 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and status connected
And WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status connected

Scenario: Callee client clears the phone call
When WS2 clears the phone call with the callId incomingPhoneCallId
And waiting for 3 seconds
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails normal
Then WS2 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and terminationDetails normal

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS2 removes the message buffer named CallStatusIndicationBuffer2

Scenario: Wait until passive op voice instances are started properly
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
When waiting for 70 seconds
Given that connection can be open (although instances are Passive) using websocket configuration:
| key | profile-name | websocket-config-name |
| WS3 | WEBSOCKET 1  | WS_Config-3           |
| WS4 | WEBSOCKET 1  | WS_Config-4           |

Scenario: Open Web Socket Client connections
		  @REQUIREMENTS:GID-4034511
		  @REQUIREMENTS:GID-4435108
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost1.story
When a timer named failoverTimerWS3 is started
Given it is known what op voice instances are Active, the websocket configuration is applied:
| key | profile-name | websocket-config-name |
| WS3 | WEBSOCKET 1  | WS_Config-3           |
Then a timer named failoverTimerWS3 is stopped

When a timer named failoverTimerWS4 is started
Given it is known what op voice instances are Active, the websocket configuration is applied:
| key | profile-name | websocket-config-name |
| WS4 | WEBSOCKET 1  | WS_Config-4           |
Then a timer named failoverTimerWS4 is stopped

Scenario: Create the message buffers for missions
When WS3 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer1
When WS3 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer1
When WS4 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer2
When WS4 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer2

Scenario: Caller client associates with Op Voice Service
When WS3 associates with Op Voice Service using opId ${OP_VOICE_PARTITION_KEY_1} and appId app1
Then WS3 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer1 and names the availableMissionIds1
Then WS3 receives mission changed indication on message buffer named MissionChangedIndicationBuffer1 and names missionId1
Then WS3 confirms mission change completed for mission missionId1

Scenario: Callee client associates with Op Voice Service
When WS4 associates with Op Voice Service using opId ${OP_VOICE_PARTITION_KEY_2} and appId app2
Then WS4 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer2 and names the availableMissionIds2
And WS4 receives mission changed indication on message buffer named MissionChangedIndicationBuffer2 and names missionId2
Then WS4 confirms mission change completed for mission missionId2

Scenario: Caller client changes its mission
When WS3 chooses mission with name <<MISSION_1_NAME>> from available missions named availableMissionIds1 and names missionIdToChange1
Then WS3 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1 and roleId1
Then WS3 confirms mission change completed for mission missionId1

Scenario: Callee client changes its mission
When WS4 chooses mission with name <<MISSION_2_NAME>> from available missions named availableMissionIds2 and names missionIdToChange2
Then WS4 receives mission changed indication on buffer named MissionChangedIndicationBuffer2 equal to missionIdToChange2 and names missionId2  and roleId2
Then WS4 confirms mission change completed for mission missionId2

Scenario: Delete the message buffers for missions
When the named websocket WS3 removes the message buffer named MissionsAvailableIndicationBuffer1
When the named websocket WS3 removes the message buffer named MissionChangedIndicationBuffer1
When the named websocket WS3 removes the message buffer named MissionsAvailableIndicationBuffer2
When the named websocket WS4 removes the message buffer named MissionChangedIndicationBuffer2

Scenario: Create the message buffers
When WS3 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS4 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2
When WS4 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer2

Scenario: Caller client retrieves phone data
When WS3 loads phone data for mission missionId1 and names callSource and callTarget from the entry number 3

Scenario: Caller establishes an outgoing call
When WS3 establishes an outgoing phone call using source callSource ang target callTarget and names outgoingPhoneCallId
And waiting for 6 seconds
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_trying

Scenario: Callee client receives the incoming call and confirms it
When WS4 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callSource and callTarget and names incomingPhoneCallId
And WS4 confirms incoming phone call with callId incomingPhoneCallId
Then WS3 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Callee client answers the incoming call
When WS4 answers the incoming phone call with the callId incomingPhoneCallId
Then WS4 receives call status indication on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and status connected
And WS3 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status connected

Scenario: Callee client clears the phone call
		  @REQUIREMENTS:GID-2510109
When WS4 clears the phone call with the callId incomingPhoneCallId
And waiting for 3 seconds
Then WS3 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails normal
Then WS4 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer2 with callId incomingPhoneCallId and terminationDetails normal

Scenario: Delete the message buffers
When the named websocket WS3 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS4 removes the message buffer named CallIncomingIndicationBuffer2
When the named websocket WS4 removes the message buffer named CallStatusIndicationBuffer2

Scenario: Wait until passive op voice instances are started properly
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost1.story
When waiting for 70 seconds
Given that connection can be open (although instances are Passive) using websocket configuration:
| key | profile-name | websocket-config-name |
| WS1 | WEBSOCKET 1  | WS_Config-1           |
| WS2 | WEBSOCKET 1  | WS_Config-2           |

Scenario: Cleanup
When WS3 disassociates from Op Voice Service
When WS4 disassociates from Op Voice Service

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection
When WS2 closes websocket client connection
When WS3 closes websocket client connection
When WS4 closes websocket client connection
