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
| WS_Config-3 | <<OPVOICE3_WS.URI>> | 1000             |
| WS_Config-4 | <<OPVOICE4_WS.URI>> | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| profile-name | websocket-config-name |
| WEBSOCKET 1  | WS_Config-3           |
| WEBSOCKET 1  | WS_Config-4           |

Scenario: Create the message buffers for missions
When WS1 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer1
When WS1 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer1

Scenario: Caller client associates with Op Voice Service
When WS1 associates with Op Voice Service using opId ${OP_VOICE_PARTITION_KEY_2} and appId app2
Then WS1 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer1 and names the availableMissionIds1
Then WS1 receives mission changed indication on message buffer named MissionChangedIndicationBuffer1 and names missionId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Caller client changes its mission
When WS1 chooses mission with name WEST-EXEC from available missions named availableMissionIds1 and names missionIdToChange1
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1 and roleId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Delete the message buffers for missions
When the named websocket WS1 removes the message buffer named MissionsAvailableIndicationBuffer1
When the named websocket WS1 removes the message buffer named MissionChangedIndicationBuffer1

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | anonymous   | <<SIP_PHONE3>> |
And phones for SipContact are created

Scenario: Define phone book entries
Given the following phone book entries:
| key         | uri                    | name      | full-name | location | organization | notes | display-addon |
| sourceEntry | <<SIP_PHONE3>>         | anonymous |           |          |              |       |               |
| targetEntry | <<OPVOICE2_PHONE_URI>> | 222222    |           |          |              |       |               |

Scenario: Create the message buffers
When WS1 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer1

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE2_PHONE_URI>>

Scenario: Callee client receives the incoming call and confirms it
When WS1 receives call incoming indication on message buffer named CallIncomingIndicationBuffer1 with callingParty matching phone book entry sourceEntry
When WS1 receives call incoming indication on message buffer named CallIncomingIndicationBuffer1 with calledParty matching phone book entry targetEntry

Scenario: Sip phone cancels the phone call
When SipContact terminates calls

Scenario: Delete the message buffers
When the named websocket WS1 removes the message buffer named CallIncomingIndicationBuffer1

Scenario: Cleanup
When WS1 disassociates from Op Voice Service

Scenario: Remove sip phone
When SipContact is removed

Scenario: Close Web Socket Client connections
When WS1 closes websocket client connection
