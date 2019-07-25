Narrative:
As an operator having an active phone call
I want to accept another phone call
So that I can verify that the first phone call is terminated

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
| key            | source         | target                 | callType |
| OP1-OP2        | <<OP1_URI>>    | <<OP2_URI>>            | DA/IDA   |
| OP2-OP1        | <<OP2_URI>>    | <<OP1_URI>>            | DA/IDA   |
| SipContact-OP2 | <<SIP_PHONE2>> | <<OPVOICE2_PHONE_URI>> | DA/IDA   |

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE2_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Verify calls state for op1 and op2
Then HMI OP2 has the call queue item SipContact-OP2 in state inc_initiated
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op2 answers the incoming call
Then HMI OP2 accepts the call queue item SipContact-OP2

Scenario: Verify calls state for op1 and op2
		  @REQUIREMENTS:GID-2878006
Then HMI OP2 has the call queue item SipContact-OP2 in state connected
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Callee client clears the phone call
Then HMI OP2 terminates the call queue item SipContact-OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed
