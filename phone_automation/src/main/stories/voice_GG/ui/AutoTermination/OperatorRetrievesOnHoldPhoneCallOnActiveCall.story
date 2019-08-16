Narrative:
As an operator having an active phone call and a phone call on hold
I want to retrieve the phone call on hold
So that I can verify that the active phone call is terminated

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
| key            | source         | target                 | callType |
| OP1-OP2        | <<OP1_URI>>    | <<OP2_URI>>            | DA/IDA   |
| OP2-OP1        | <<OP2_URI>>    | <<OP1_URI>>            | DA/IDA   |
| OP1-OP3        | <<OP1_URI>>    | <<OP3_URI>>            | DA/IDA   |
| OP3-OP1        | <<OP3_URI>>    | <<OP1_URI>>            | DA/IDA   |
| SipContact-OP1 | <<SIP_PHONE2>> | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

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

Scenario: Caller puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Verify call state for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state held

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Verify calls state for op1 and op2
Then HMI OP1 has the call queue item SipContact-OP1 in state inc_initiated
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state held

Scenario: Op1 answers the incoming call
Then HMI OP1 accepts the call queue item SipContact-OP1

Scenario: Verify calls state for op1 and op2
Then HMI OP1 has the call queue item SipContact-OP1 in state connected
Then HMI OP1 has the call queue item OP2-OP1 in state hold
Then HMI OP2 has the call queue item OP1-OP2 in state held

Scenario: Op1 retrieves call from hold
Then HMI OP1 retrieves from hold the call queue item OP2-OP1

Scenario: Verify calls state for op1 and op2
		  @REQUIREMENTS:GID-2878006
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state out_ringing

Scenario: Op3 receives the incoming call
Then HMI OP3 has the DA key OP1 in state inc_initiated

Scenario: Verify calls state for op1, op2 and op3
		  @REQUIREMENTS:GID-2878006
Then HMI OP1 has the call queue item OP3-OP1 in state out_ringing
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has the call queue item OP1-OP3 in state inc_initiated
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op1 clears the phone call
Then HMI OP1 terminates the call queue item OP3-OP1
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
