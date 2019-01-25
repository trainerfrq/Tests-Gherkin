Narrative:
As an operator
I want to initiate a SIP call towards a role assigned to all operators
So I can check that the outgoing call is initiated correctly

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key       | source                      | target                      | callType |
| SIP-allOp | <<SIP_PHONE2>>              | <<ALL_PHONES>>              | DA/IDA   |

Scenario: SIP group call is initiated to all operators
		  @REQUIREMENTS:GID-2897826
		  @REQUIREMENTS:GID-3030985
When SipContact calls SIP URI <<ALL_PHONES>>
Then waiting for 2 seconds
Then HMI OP1 has the call queue item SIP-allOp in the waiting list with name label Madoline
!-- TODO: uncomment after installing new CATS version
!-- Then HMI OP2 has the call queue item SIP-allOp in the waiting list with label Madoline
!-- Then HMI OP3 has the call queue item SIP-allOp in the waiting list with label Madoline

Scenario: Operator terminates the SIP Call
When SipContact terminates calls

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed
