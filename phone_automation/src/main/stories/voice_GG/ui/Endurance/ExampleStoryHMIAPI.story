Meta:

Narrative:
As a user
I want to perform an action
So that I can achieve a business goal

Scenario: Booking profiles
Given booked profiles:
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define call source and API URI
When define values in story data:
| name    | value            |
| HMI OP1 | <<HMI1_API.URI>> |
| HMI OP2 | <<HMI2_API.URI>> |
| HMI OP3 | <<HMI3_API.URI>> |

Scenario: Operator1 changes the mission on HMI screen
When HMI OP1 changes (via POST request) current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 verifies (via POST request) change mission <<MISSION_1_NAME>> was successfully

Scenario: Operator2 changes the mission on HMI screen
When HMI OP2 changes (via POST request) current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 verifies (via POST request) change mission <<MISSION_2_NAME>> was successfully

Scenario: Steps 1 and 2 described in the Narrative
When HMI OP1 presses (via POST request) DA key <<ROLE_2_NAME>>
Scenario: Steps 1 and 2 described in the Narrative
Then HMI OP1 verify (via POST request) that DA key <<ROLE_2_NAME>> has status OUTGOING
Scenario: Steps 1 and 2 described in the Narrative
Then HMI OP1 verify (via POST request) that call queue has status OUTGOING
Scenario: Steps 1 and 2 described in the Narrative
!-- Then HMI OP2 verify (via POST request) that call queue has status RINGING
Then HMI OP2 verify (via POST request) that DA key <<ROLE_1_NAME>> has status RINGING
Scenario: Steps 1 and 2 described in the Narrative
When HMI OP2 presses (via POST request) DA key <<ROLE_1_NAME>>
Scenario: Steps 1 and 2 described in the Narrative
Then HMI OP1 verify (via POST request) that call queue has status ESTABLISHED
Scenario: Steps 1 and 2 described in the Narrative
Then HMI OP2 verify (via POST request) that call queue has status ESTABLISHED
Then waiting for 10 seconds
When HMI OP1 presses (via POST request) DA key <<ROLE_2_NAME>>
Then HMI OP2 verify (via POST request) that call queue has status TERMINATED
Then HMI OP1 verify (via POST request) that call queue has status TERMINATED
Then waiting for 5 seconds
When HMI OP2 presses (via POST request) DA key <<ROLE_1_NAME>>
Then HMI OP2 verify (via POST request) that DA key <<ROLE_1_NAME>> has status OUTGOING
Then HMI OP2 verify (via POST request) that call queue has status OUTGOING
Then HMI OP1 verify (via POST request) that call queue has status RINGING
When HMI OP1 presses (via POST request) DA key <<ROLE_2_NAME>>
Then HMI OP1 verify (via POST request) that call queue has status ESTABLISHED
Then HMI OP2 verify (via POST request) that call queue has status ESTABLISHED
Then waiting for 10 seconds
When HMI OP2 presses (via POST request) DA key <<ROLE_1_NAME>>
Then HMI OP2 verify (via POST request) that call queue has status TERMINATED
Then HMI OP1 verify (via POST request) that call queue has status TERMINATED
Then waiting for 5 seconds
Scenario: Steps 1 and 2 described in the Narrative
When HMI OP1 start (via POST request) a call from phone book to Madoline
Scenario: Steps 1 and 2 described in the Narrative
Then HMI OP1 verify (via POST request) that call queue has status OUTGOING
When SipContact answers incoming calls
Then HMI OP1 verify (via POST request) that call queue has status ESTABLISHED
Then waiting for 10 seconds
When SipContact terminates calls
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 verify (via POST request) that call queue has status TERMINATED
