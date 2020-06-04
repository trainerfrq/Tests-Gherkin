Meta:

Narrative:
As a user
I want to perform an action
So that I can achieve a business goal

Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host           | identifier |
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
Then HMI OP1 verifies (via POST request) that the displayed mission is <<MISSION_1_NAME>>

Scenario: Operator2 changes the mission on HMI screen
When HMI OP2 changes (via POST request) current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 verifies (via POST request) that the displayed mission is <<MISSION_2_NAME>>

Scenario: Op1 calls Op2
When HMI OP1 presses (via POST request) DA key <<ROLE_2_NAME>>
Then wait for 2 seconds

Scenario: Op1 verifies call state - outgoing
Then HMI OP1 verify (via POST request) that DA key <<ROLE_2_NAME>> has status OUTGOING_PRIO
Then HMI OP1 verify (via POST request) that call queue has status OUTGOING_PRIO

Scenario: Op2 verifies call state - ringing
Then HMI OP2 verify (via POST request) that DA key <<ROLE_1_NAME>> has status RINGING_PRIO
Then HMI OP2 verify (via POST request) that call queue has status RINGING_PRIO

Scenario: Op2 answers call
When HMI OP2 presses (via POST request) DA key <<ROLE_1_NAME>>
Then wait for 2 seconds

Scenario: Op1 verifies call state - established
Then HMI OP1 verify (via POST request) that call queue has status ESTABLISHED_DUPLEX

Scenario: Op2 verifies call state - established
Then HMI OP2 verify (via POST request) that call queue has status ESTABLISHED_DUPLEX
Then waiting for 2 seconds

Scenario: Op1 terminates call
When HMI OP1 presses (via POST request) DA key <<ROLE_2_NAME>>
Then wait for 2 seconds

Scenario: Op1 verifies call state - terminated
Then HMI OP1 verify (via POST request) that call queue has status TERMINATED

Scenario: Op2 verifies call state - terminated
Then HMI OP2 verify (via POST request) that call queue has status TERMINATED
Then waiting for 2 seconds

Scenario: Op2 calls Op1
When HMI OP2 presses (via POST request) DA key <<ROLE_1_NAME>>
Then wait for 2 seconds

Scenario: Op2 verifies call state - outgoing
Then HMI OP2 verify (via POST request) that DA key <<ROLE_1_NAME>> has status OUTGOING_PRIO
Then HMI OP2 verify (via POST request) that call queue has status OUTGOING_PRIO

Scenario: Op2 verifies call state - ringing
Then HMI OP1 verify (via POST request) that DA key <<ROLE_2_NAME>> has status RINGING_PRIO
Then HMI OP1 verify (via POST request) that call queue has status RINGING_PRIO

Scenario: Op1 answers call
When HMI OP1 presses (via POST request) DA key <<ROLE_2_NAME>>
Then wait for 2 seconds

Scenario: Op1 verifies call state - established
Then HMI OP1 verify (via POST request) that call queue has status ESTABLISHED_DUPLEX

Scenario: Op2 verifies call state - established
Then HMI OP2 verify (via POST request) that call queue has status ESTABLISHED_DUPLEX
Then waiting for 2 seconds

Scenario: Op2 terminates call
When HMI OP2 presses (via POST request) DA key <<ROLE_1_NAME>>
Then wait for 2 seconds

Scenario: Op2 verifies call state - terminated
Then HMI OP2 verify (via POST request) that call queue has status TERMINATED

Scenario: Op1 verifies call state - terminated
Then HMI OP1 verify (via POST request) that call queue has status TERMINATED
Then waiting for 2 seconds

Scenario: Operator does a call to an external callee
When HMI OP1 start (via POST request) a call from phone book to Madoline
Then wait for 2 seconds

Scenario: Op1 verifies call state - outgoing
Then HMI OP1 verify (via POST request) that call queue has status OUTGOING

Scenario: Externals callee answer calls
When SipContact answers incoming calls
Then wait for 2 seconds

Scenario: Op1 verifies call state - established
Then HMI OP1 verify (via POST request) that call queue has status ESTABLISHED
Then waiting for 2 seconds

Scenario: Operator terminates calls
When SipContact terminates calls
Then wait for 2 seconds

Scenario: Op1 verifies call state - terminated
Then HMI OP1 verify (via POST request) that call queue has status TERMINATED

Scenario: Remove SIP Contact
When SipContact is removed
