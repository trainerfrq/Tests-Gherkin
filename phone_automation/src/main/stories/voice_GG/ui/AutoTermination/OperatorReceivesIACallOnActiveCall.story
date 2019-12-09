Narrative:
As an operator having an active phone call
I receive a half duplex IA phone call
So that I can verify that the first phone call is not terminated

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | IA       |
| OP3-OP2 | <<OP3_URI>> | <<OP2_URI>> | IA       |

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

Scenario: Op3 establishes an outgoing IA call towards Op2
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 2
When HMI OP3 presses IA key IA - OP2

Scenario: Verify call state for all operators
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 click on call queue Elements list
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has in the active list a number of 1 calls
Then HMI OP2 has in the collapsed area a number of 1 calls

Scenario: Op3 terminates IA call
When HMI OP3 presses IA key IA - OP2

Scenario: Verify call state for all operators
Then HMI OP1 has in the call queue a number of 1 calls
And wait for 1 seconds
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op2 terminates call
Then HMI OP2 terminates the call queue item OP1-OP2

Scenario: Verify call state for all operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting for 1 millisecond
