Narrative:
As an operator part of an active call
I want to transfer the active call to a transfer target operator using an intermediary consultation call
So I can verify that the call was transferred successfully

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
| OP3-OP2        | <<OP3_URI>>    | <<OP2_URI>>            | DA/IDA   |
| OP2-OP3        | <<OP2_URI>>    | <<OP3_URI>>            | DA/IDA   |
| OP1-OP3        | <<OP1_URI>>    | <<OP3_URI>>            | DA/IDA   |
| OP3-OP1        | <<OP3_URI>>    | <<OP1_URI>>            | DA/IDA   |
| SipContact-OP2 | <<SIP_PHONE2>> | <<OPVOICE2_PHONE_URI>> | DA/IDA   |

Scenario: Transferor establishes an outgoing call towards transferee
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Transferee receives incoming call
Then HMI OP1 has the DA key OP2 in state inc_initiated

Scenario: Transferee answers incoming call
When HMI OP1 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Transferor initiates transfer
When HMI OP2 initiates a transfer on the active call

Scenario: Verify call is put on hold
Then HMI OP2 has the call queue item OP1-OP2 in state hold

Scenario: Verify call transfer is initiated
Then HMI OP2 has the call conditional flag set for call queue item OP1-OP2
Then HMI OP2 has the call queue item OP1-OP2 in the hold list with info label XFR Hold

Scenario: Verify call is held for transferee
Then HMI OP1 has the call queue item OP2-OP1 in state held

Scenario: Transferor initiates consultation call
When HMI OP2 presses DA key OP3
Then HMI OP2 has the DA key OP3 in state out_ringing

Scenario: Transfer target receives incoming call
Then HMI OP3 has the DA key OP2 in state inc_initiated

Scenario: Transfer target answers incoming call
When HMI OP3 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Verify initial call is still on hold
Then HMI OP2 has the call queue item OP1-OP2 in state hold
Then HMI OP1 has the call queue item OP2-OP1 in state held

Scenario: Sip phone calls transferor
When SipContact calls SIP URI <<OPVOICE2_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Transferor receives the incoming call and attempts to answer
Then HMI OP2 has the call queue item SipContact-OP2 in state inc_initiated
Then HMI OP2 accepts the call queue item SipContact-OP2
Then HMI OP2 has the call queue item SipContact-OP2 in state inc_initiated

Scenario: Verify answer call is not possible
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that list State contains text Call Transfer in progress
When HMI OP2 selects tab event from notification display popup
Then HMI OP2 verifies that list Event contains on position 0 text Call can not be accepted, TRANSFER mode active
When HMI OP2 selects tab state from notification display popup

Scenario: Close popup window
Then HMI OP2 closes notification popup

Scenario: Transferor finishes transfer
When HMI OP2 presses DA key OP3
And waiting for 1 seconds

Scenario: Verify call was transferred
Then HMI OP2 has in the active list a number of 0 calls
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP3 has the call queue item OP1-OP3 in state connected

Scenario: Transferor answers the incoming SIP call
Then HMI OP2 accepts the call queue item SipContact-OP2
Then HMI OP2 has the call queue item SipContact-OP2 in state connected

Scenario: Sip phone terminates the phone call
When SipContact terminates calls
And waiting for 2 seconds
Then HMI OP2 has in the active list a number of 0 calls

Scenario: Cleanup call
When HMI OP1 presses DA key OP3
And waiting for 1 seconds
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP3 has in the active list a number of 0 calls

Scenario: Remove sip phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting for 1 millisecond
