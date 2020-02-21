Narrative:
As a caller operator having an active phone call with a callee operator
I want to clear the phone call
So I can verify that the phone call is terminated on both sides

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
| key            | source         | target      | callType |
| OP1-OP2        | <<OP1_URI>>    | <<OP2_URI>> | DA/IDA   |
| OP2-OP1        | <<OP2_URI>>    | <<OP1_URI>> | DA/IDA   |
| OP1-SipContact | <<SIP_PHONE2>> |             | DA/IDA   |

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Callee client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then waiting for 10 seconds

Scenario: Caller client clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls
Then waiting for 5 seconds

Scenario: Caller establishes an outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP1 has the call queue item OP2-OP1 in state inc_initiated

Scenario: Callee client answers the incoming call
When HMI OP1 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then waiting for 10 seconds

Scenario: Caller client clears the phone call
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls
Then waiting for 5 seconds

Scenario: Caller opens phonebook and selects an external SIP
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
When HMI OP1 selects call route selector: none
When HMI OP1 selects phonebook entry number: 8
Then HMI OP1 verifies that phone book text box displays text Madoline

Scenario: Caller hits phonebook call button
When HMI OP1 initiates a call from the phonebook

Scenario: External callee answers the call
When SipContact answers incoming calls
Then HMI OP1 has the call queue item OP1-SipContact in state connected
Then waiting for 10 seconds

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP1-SipContact

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed
Then waiting for 20 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
Then HMI OP1 does a clean up for function key PHONEBOOK if the state is active
Then HMI OP2 does a clean up for function key PHONEBOOK if the state is active

