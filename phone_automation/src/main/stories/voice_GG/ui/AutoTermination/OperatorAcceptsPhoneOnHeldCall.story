Narrative:
As an operator having a phone call held by the other party
I want to accept another phone call
So that I can verify that the first phone call is terminated

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
| SipContact-OP1 | <<SIP_PHONE2>>         | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

Scenario: Op2 establishes an outgoing call towards op1
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Op1 receives incoming call
Then HMI OP1 has the DA key OP2(as OP1) in state ringing

Scenario: Op1 answers incoming call
When HMI OP1 presses DA key OP2(as OP1)

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Verify call state for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state held

Scenario: Op3 establishes an outgoing call towards op1
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP3 has the DA key OP1(as OP3) in state out_ringing

Scenario: Op1 receives the incoming call
Then HMI OP1 has the DA key OP3(as OP1) in state ringing

Scenario: Op1 answers incoming call
When HMI OP1 presses DA key OP3(as OP1)

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected

Scenario: Caller puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Verify call state for all operators
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP1 has the call queue item OP3-OP1 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state held
Then HMI OP3 has the call queue item OP1-OP3 in state held

Scenario: Sip phone calls op1
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Verify calls state for op1
Then HMI OP1 has the call queue item SipContact-OP1 in state ringing
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP1 has the call queue item OP3-OP1 in state hold

Scenario: Op1 answers the incoming call
Then HMI OP1 accepts the call queue item SipContact-OP1

Scenario: Verify calls state for op1
Then HMI OP1 has the call queue item SipContact-OP1 in state connected
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP1 has the call queue item OP3-OP1 in state hold
Then HMI OP1 has in the call queue a number of 3 calls

Scenario: Op2 establishes an outgoing call towards op3
When HMI OP2 presses DA key OP3
Then HMI OP2 has the DA key OP3 in state out_ringing

Scenario: Verify call state for all operators
		  @REQUIREMENTS:GID-2878006
Then HMI OP1 has the call queue item SipContact-OP1 in state connected
Then HMI OP1 has the call queue item OP3-OP1 in state hold
Then HMI OP2 has the call queue item OP3-OP2 in state out_ringing
Then HMI OP3 has the call queue item OP1-OP3 in state held
Then HMI OP3 has the call queue item OP2-OP3 in state ringing
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 2 calls

Scenario: Op3 answers the incoming call
Then HMI OP3 accepts the call queue item OP2-OP3

Scenario: Verify call state for all operators
		  @REQUIREMENTS:GID-2878006
Then HMI OP1 has the call queue item SipContact-OP1 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op2 terminates call
Then HMI OP2 terminates the call queue item OP3-OP2

Scenario: Sip phone clears calls
When SipContact terminates calls

Scenario: Verify call state for all operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

