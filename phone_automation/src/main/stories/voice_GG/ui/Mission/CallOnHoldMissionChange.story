Narrative:
As a callee operator having multiple calls on hold on my side
I want to do several change mission actions
So I can verify that calls are not affected by these actions

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key            | source                 | target                 | callType |
| OP1-OP2        | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1        | sip:222222@example.com | sip:111111@example.com | DA/IDA   |
| OP3-OP2        | sip:op3@example.com    | sip:222222@example.com | DA/IDA   |
| OP2-OP3        | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |
| SipContact-OP2 | <<SIP_PHONE2>>         | <<OPVOICE2_PHONE_URI>> | DA/IDA   |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE2_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Callee client receives the incoming priority call
Then HMI OP2 has the call queue item SipContact-OP2 in state ringing
Then HMI OP2 accepts the call queue item SipContact-OP2
Then HMI OP2 has the call queue item SipContact-OP2 in state connected

Scenario: Callee puts call on hold
When HMI OP2 puts on hold the active call
Then HMI OP2 has the call queue item SipContact-OP2 in state hold

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP1 in state ringing
Then HMI OP2 has the call queue item OP1-OP2 in state ringing

Scenario: Change mission for HMI OP2
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify call state
		   @REQUIREMENTS: GID-3005111
Then HMI OP2 has the call queue item SipContact-OP2 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state ringing

Scenario: Callee client answers the incoming call
Then HMI OP2 accepts the call queue item OP1-OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Callee puts call on hold
When HMI OP2 puts on hold the active call
Then HMI OP2 has the call queue item OP1-OP2 in state hold

Scenario: Change mission for HMI OP2
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify call state
		  @REQUIREMENTS: GID-3005111
Then HMI OP2 has the call queue item SipContact-OP2 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state hold

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP2(as OP3)
Then HMI OP3 has the DA key OP2(as OP3) in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP3 in state ringing
Then HMI OP2 has the call queue item OP3-OP2 in state ringing

Scenario: Callee client answers the incoming call
Then HMI OP2 accepts the call queue item OP3-OP2

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Callee tries to put the call on hold, but it can't because of the configurated limit of 1 call
When HMI OP2 puts on hold the active call
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Change mission for HMI OP2
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify call state
		   @REQUIREMENTS: GID-3005111
Then HMI OP2 has the call queue item SipContact-OP2 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Callee tries again to put the call on hold, this time succesfully
When HMI OP2 puts on hold the active call
Then HMI OP2 has the call queue item OP3-OP2 in state hold

Scenario: Change mission for HMI OP2
When HMI OP2 presses function key MISSIONS
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify call state
		   @REQUIREMENTS: GID-3005111
Then HMI OP2 has the call queue item SipContact-OP2 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP2 has the call queue item OP3-OP2 in state hold

Scenario: Callee retrieves call from hold
Then HMI OP2 retrieves from hold the call queue item OP3-OP2

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Caller clears outgoing call
When HMI OP3 presses DA key OP2(as OP3)

Scenario: Callee retrieves call from hold
Then HMI OP2 retrieves from hold the call queue item OP1-OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller clears outgoing call
When HMI OP1 presses DA key OP2(as OP1)

Scenario: Callee retrieves call from hold
Then HMI OP2 retrieves from hold the call queue item SipContact-OP2
Then HMI OP2 has the call queue item SipContact-OP2 in state connected
Then HMI OP2 terminates the call queue item SipContact-OP2

Scenario: Verify all cals were cleared
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed
