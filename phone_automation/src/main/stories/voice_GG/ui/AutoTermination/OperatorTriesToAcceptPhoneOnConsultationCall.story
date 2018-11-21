Narrative:
As an operator part of an ongoing transfer with consultation
I want to answer an incoming call while having consultation call connected
So I can verify that the incoming call cannot be answered(or accepted), and the consultation call is not auto-terminated

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
| key            | source                 | target                 | callType |
| OP1-OP2        | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1        | sip:222222@example.com | sip:111111@example.com | DA/IDA   |
| OP3-OP2        | sip:op3@example.com    | sip:222222@example.com | DA/IDA   |
| OP2-OP3        | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |
| OP1-OP3        | sip:111111@example.com | sip:op3@example.com    | DA/IDA   |
| OP3-OP1        | sip:op3@example.com    | sip:111111@example.com | DA/IDA   |
| SipContact-OP2 | <<SIP_PHONE2>>         | <<OPVOICE2_PHONE_URI>> | DA/IDA   |

Scenario: Transferor establishes an outgoing call towards transferee
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Transferee receives incoming call
Then HMI OP1 has the DA key OP2(as OP1) in state inc_initiated

Scenario: Transferee answers incoming call
When HMI OP1 presses DA key OP2(as OP1)

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Transferor initiates transfer
When HMI OP2 initiates a transfer on the active call

Scenario: Verify call is put on hold
Then HMI OP2 has the call queue item OP1-OP2 in state hold

Scenario: Verify call transfer is initiated
Then HMI OP2 has the call conditional flag set for call queue item OP1-OP2
Then HMI OP2 is in transfer state

Scenario: Verify call is held for transferee
Then HMI OP1 has the call queue item OP2-OP1 in state held

Scenario: Transferor initiates consultation call
When HMI OP2 presses DA key OP3
Then HMI OP2 has the DA key OP3 in state out_ringing

Scenario: Transfer target receives incoming call
Then HMI OP3 has the DA key OP2(as OP3) in state inc_initiated

Scenario: Transfer target answers incoming call
When HMI OP3 presses DA key OP2(as OP3)

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Verify initial call is still on hold
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP1 has the call queue item OP2-OP1 in state held

Scenario: Sip phone calls transferor
When SipContact calls SIP URI <<OPVOICE2_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Verify calls state for all operators
Then HMI OP1 has the call queue item OP2-OP1 in state held
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP2 has the call queue item SipContact-OP2 in state inc_initiated
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: Verify notification label is displayed correctly for transferor
Then HMI OP2 has a notification that shows  Call Transfer in progress

Scenario: Transferor tries to answers the incoming call
Then HMI OP2 accepts the call queue item SipContact-OP2

Scenario: Verify notification label is displayed correctly for transferor
Then HMI OP2 has a notification that shows  Call can not be accepted, TRANSFER mode active

Scenario: Verify calls state for all operators
Then HMI OP1 has the call queue item OP2-OP1 in state held
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP2 has the call queue item SipContact-OP2 in state inc_initiated
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: Transfer target rejects transfer
Then HMI OP3 terminates the call queue item OP2-OP3

Scenario: Verify calls state for all operators
Then HMI OP1 has the call queue item OP2-OP1 in state held
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP2 has the call queue item SipContact-OP2 in state inc_initiated
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op2 retrieves call from hold
Then HMI OP2 retrieves from hold the call queue item OP1-OP2

Scenario: Verify calls state for all operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the call queue item SipContact-OP2 in state inc_initiated
Then HMI OP2 has in the call queue a number of 2 calls

Scenario: Op2 answers the incoming call
Then HMI OP2 accepts the call queue item SipContact-OP2

Scenario: Verify calls state for all operators
		  @REQUIREMENTS:GID-2878006
Then HMI OP2 has the call queue item SipContact-OP2 in state connected
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Op2 clears call
Then HMI OP2 terminates the call queue item SipContact-OP2

Scenario: Remove phone
When SipContact is removed


