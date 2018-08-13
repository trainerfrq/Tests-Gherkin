Narrative:
As a callee operator having an incoming call from a SIP contact
I want to have a matching phone book entry for both caller SIP contact and myself
So that I can verify that the call incoming indication contains the contact related information of both the caller and myself

Scenario: Booking profiles
Given booked profiles:
| profile   | group          | host       | identifier |
| websocket | hmi            | <<CO3_IP>> |            |
| voip      | <<systemName>> | <<CO3_IP>> | VOIP       |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-3 | <<OPVOICE3_WS.URI>> | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| key | profile-name | websocket-config-name |
| WS3 | WEBSOCKET 1  | WS_Config-3           |

Scenario: Create the message buffers for missions
When WS3 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer3
When WS3 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer3

Scenario: Caller client associates with Op Voice Service
When WS3 associates with Op Voice Service using opId ${OP_VOICE_PARTITION_KEY_3} and appId app3
Then WS3 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer3 and names the availableMissionIds3
Then WS3 receives mission changed indication on message buffer named MissionChangedIndicationBuffer3 and names missionId3
Then WS3 confirms mission change completed for mission missionId3

Scenario: Caller client changes its mission
When WS3 chooses mission with name EAST-EXEC from available missions named availableMissionIds3 and names missionIdToChange3
Then WS3 receives mission changed indication on buffer named MissionChangedIndicationBuffer3 equal to missionIdToChange3 and names missionId3 and roleId3
Then WS3 confirms mission change completed for mission missionId3

Scenario: Delete the message buffers for missions
When the named websocket WS3 removes the message buffer named MissionsAvailableIndicationBuffer3
When the named websocket WS3 removes the message buffer named MissionChangedIndicationBuffer3

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define phone book entries
Given the following phone book entries:
| key         | uri                    | name     | full-name         | location                                | organization          | notes              | display-addon |
| sourceEntry | <<SIP_PHONE2>>         | Madoline | Madoline Katharyn | 71 Pilgrim Avenue Chevy Chase, MD 20815 | Chinese Metals        | Language - Chinese | Air2Ground    |
| targetEntry | <<OPVOICE3_PHONE_URI>> | Lloyd    | Lloyd Ripley      | 123 6th St. Melbourne, FL 32904         | European Applications | Language - English | Ground2Ground |

Scenario: Create the message buffers
When WS3 opens the message buffer for message type callIncomingIndication named CallIncomingIndicationBuffer3

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE3_PHONE_URI>>

Scenario: Callee client receives the incoming call and confirms it
		  @REQUIREMENTS:GID-2877902
When WS3 receives call incoming indication on message buffer named CallIncomingIndicationBuffer3 with callingParty matching phone book entry sourceEntry
When WS3 receives call incoming indication on message buffer named CallIncomingIndicationBuffer3 with calledParty matching phone book entry targetEntry

Scenario: Sip phone cancels the phone call
When SipContact terminates calls

Scenario: Delete the message buffers
When the named websocket WS3 removes the message buffer named CallIncomingIndicationBuffer3

Scenario: Cleanup
When WS3 disassociates from Op Voice Service

Scenario: Remove sip phone
When SipContact is removed

Scenario: Close Web Socket Client connections
When WS3 closes websocket client connection
