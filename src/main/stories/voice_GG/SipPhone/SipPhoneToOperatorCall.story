Scenario: Simulate an HMI to initiate and answer a GG Call
		  @REQUIREMENTS:GID-2535689

Scenario: Booking profiles
Given booked profiles:
| profile   | group | host       | identifier |
| websocket | hmi   | <<CO1_IP>> |            |
| voip      | opv   | <<CO1_IP>> | VOIP       |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-1 | <<OPVOICE1_WS.URI>> | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| key | profile-name | websocket-config-name |
| WS1 | WEBSOCKET 1  | WS_Config-1           |

Scenario: Create the message buffers
When WS1 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer1
When WS1 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer1
When WS1 opens the message buffer for message type callStatusIndication named CallStatusIndicationBuffer1
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1

Scenario: Caller client associates with Op Voice Service
When WS1 associates with Op Voice Service using opId op1 and appId app1
Then WS1 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer1 and names the availableMissionIds1
Then WS1 receives mission changed indication on message buffer named MissionChangedIndicationBuffer1 and names missionId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Caller client changes its mission
When WS1 chooses mission with index 0 from available missions named availableMissionIds1 and names missionIdToChange1
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1 and roleId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri                       |
| SipContact | VOIP    | cats        | sip:cats@<<PHONE_ROUTING_IP>> |
And phones for SipContact are created

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>

Scenario: Define call source and target
When define values in story data:
| name         | value      |
| calledSource | sip:cats   |
| calledTarget | sip:111111 |

Scenario: Called client receives the incoming call and confirms it
When WS1 receives call incoming indication on message buffer named CallIncomingIndicationBuffer1 with calledSource and calledTarget and names incomingPhoneCallId
And WS1 confirms incoming phone call with callId incomingPhoneCallId
Then SipContact DialogState is EARLY within 100 ms

Scenario: Called client answers the incoming call
When WS1 answers the incoming phone call with the callId incomingPhoneCallId
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId incomingPhoneCallId and status connected
Then SipContact DialogState is CONFIRMED within 100 ms

Scenario: Sip phone terminates the phone call
When SipContact terminates calls
And waiting for 3 seconds
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId incomingPhoneCallId and terminationDetails normal

Scenario: Cleanup
When WS1 disassociates from Op Voice Service

Scenario: Remove sip phone
When SipContact is removed

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named MissionsAvailableIndicationBuffer1
When the named websocket WS1 removes the message buffer named MissionChangedIndicationBuffer1
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1
When the named websocket WS1 removes the message buffer named CallIncomingIndicationBuffer1

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection
