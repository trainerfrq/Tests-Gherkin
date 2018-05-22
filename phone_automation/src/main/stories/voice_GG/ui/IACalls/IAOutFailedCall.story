Narrative:
As an operator
I want to initiate an outgoing IA call towards another operator
So that I can verify that the IA call is automatically accepted by the other operator

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key        | source         | target                 | callType |
| OP1-PHONE2 | <<SIP_PHONE2>> | sip:111111@example.com | IA       |

Scenario: Caller establishes an outgoing IA call
When HMI OP1 presses IA key IA - PHONE2
Then HMI OP1 has the call queue item OP1-PHONE2 in state out_initiating

Scenario: SipContact has incoming call
Then SipContact DialogState is EARLY within 100 ms

Scenario: Wait until timer expires and verify if call is out_failed
When waiting for 6 seconds
Then HMI OP1 has the call queue item OP1-PHONE2 in state out_failed

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - PHONE2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove SipContact
When SipContact is removed
