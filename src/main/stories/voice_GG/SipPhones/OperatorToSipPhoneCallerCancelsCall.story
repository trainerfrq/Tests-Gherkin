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

Scenario: Caller client associates with Op Voice Service
When WS1 associates with Op Voice Service using opId op1 and appId app1
Then WS1 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer1 and names the availableMissionIds1
Then WS1 receives mission changed indication on message buffer named MissionChangedIndicationBuffer1 and names missionId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Caller client changes its mission
When WS1 chooses mission with index 0 from available missions named availableMissionIds1 and names missionIdToChange1
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1 and roleId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Caller client retrieves phone data
When WS1 loads phone data for role roleId1 and names callSource and callTarget

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri                       |
| SipContact | VOIP    | cats        | sip:cats@<<PHONE_ROUTING_IP>> |
And phones for SipContact are created

Scenario: Define call target
When define values in story data:
| name         | value                         |
| calledTarget | sip:cats@<<PHONE_ROUTING_IP>> |

Scenario: Caller establishes an outgoing call
When WS1 establishes an outgoing phone call using source callSource ang target calledTarget and names outgoingPhoneCallId
And waiting for 3 seconds
Then WS1 receives call status indication on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and status out_ringing

Scenario: Caller client clears the incoming call
When WS1 clears the phone call with the callId outgoingPhoneCallId
And waiting for 6 seconds
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails normal
Then SipContact DialogState is TERMINATED within 100 ms

Scenario: Caller client clears the phone call
When WS1 clears the phone call with the callId incomingPhoneCallId
And waiting for 3 seconds
Then WS1 receives call status indication with terminated status on message buffer named CallStatusIndicationBuffer1 with callId outgoingPhoneCallId and terminationDetails normal
Then SipContact DialogState is TERMINATED within 100 ms

Scenario: Cleanup
When WS1 disassociates from Op Voice Service

Scenario: Remove sip phone
When SipContact is removed

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named MissionsAvailableIndicationBuffer1
When the named websocket WS1 removes the message buffer named MissionChangedIndicationBuffer1
When the named websocket WS1 removes the message buffer named CallStatusIndicationBuffer1

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection
