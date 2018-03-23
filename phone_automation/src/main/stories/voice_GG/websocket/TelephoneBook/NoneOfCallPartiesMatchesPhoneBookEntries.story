Narrative:
As a callee operator having an incoming call from a SIP contact
I want to have no matching phone book entry for neither caller SIP contact or myself
So that I can verify that the call incoming indication contains only the basic information of both the caller and myself

Scenario: Booking profiles
Given booked profiles:
| profile   | group          | host       | identifier |
| websocket | hmi            | <<CO3_IP>> |            |
| voip      | <<systemName>> | <<CO3_IP>> | VOIP       |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-2 | <<OPVOICE2_WS.URI>> | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| key | profile-name | websocket-config-name |
| WS2 | WEBSOCKET 1  | WS_Config-2           |

Scenario: Create the message buffers for missions
When WS2 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer2
When WS2 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer2

Scenario: Caller client associates with Op Voice Service
When WS2 associates with Op Voice Service using opId op04 and appId app2
Then WS2 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer2 and names the availableMissionIds2
Then WS2 receives mission changed indication on message buffer named MissionChangedIndicationBuffer2 and names missionId2
Then WS2 confirms mission change completed for mission missionId2

Scenario: Caller client changes its mission
When WS2 chooses mission with index 0 from available missions named availableMissionIds2 and names missionIdToChange2
Then WS2 receives mission changed indication on buffer named MissionChangedIndicationBuffer2 equal to missionIdToChange2 and names missionId2 and roleId2
Then WS2 confirms mission change completed for mission missionId2

Scenario: Delete the message buffers for missions
When the named websocket WS2 removes the message buffer named MissionsAvailableIndicationBuffer2
When the named websocket WS2 removes the message buffer named MissionChangedIndicationBuffer2

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | anonymous   | <<SIP_PHONE3>> |
And phones for SipContact are created

Scenario: Define call parties
Given the following call parties:
| key             | uri                    | name      | full-name | location | organization | notes | display-addon |
| sourceCallParty | <<SIP_PHONE3>>         | anonymous |           |          |              |       |               |
| targetCallParty | <<OPVOICE2_PHONE_URI>> | 222222    |           |          |              |       |               |

Scenario: Create the message buffers
When WS2 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer2

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE2_PHONE_URI>>

Scenario: Callee client receives the incoming call and confirms it
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with callingParty matching sourceCallParty
When WS2 receives call incoming indication on message buffer named CallIncomingIndicationBuffer2 with calledParty matching targetCallParty

Scenario: Sip phone cancels the phone call
When SipContact terminates calls

Scenario: Delete the message buffers
When the named websocket WS2 removes the message buffer named CallIncomingIndicationBuffer2

Scenario: Cleanup
When WS2 disassociates from Op Voice Service

Scenario: Remove sip phone
When SipContact is removed

Scenario: Close Web Socket Client connections
When WS2 closes websocket client connection
