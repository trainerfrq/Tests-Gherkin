Narrative:
As an operator having an active IA full duplex call
I want to accept another phone call
So that I can verify that the first outgoing IA call is terminated

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | IA       |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | IA       |
| OP3-OP2 | <<OP3_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | DA/IDA   |

Scenario: Caller establishes an outgoing IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: Callee receives incoming IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Callee also initiate a IA call, transforming the existing IA half duplex call in a full duplex
When HMI OP2 presses IA key IA - OP1

Scenario: Verify calls state on all operators
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction duplex
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction duplex
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Op3 establishes an outgoing call towards op2
When HMI OP3 presses DA key OP2
Then HMI OP3 has the DA key OP2 in state out_ringing

Scenario: Op2 receives the incoming call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
Then HMI OP2 has the DA key OP3 in state inc_initiated

Scenario: Op2 answers the incoming call
Then HMI OP2 accepts the call queue item OP3-OP2

Scenario: Verify calls state for all operators
		  @REQUIREMENTS:GID-2878006
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 click on call queue Elements list
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction rx
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction tx
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 2 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Caller clears IA call
When HMI OP1 presses IA key IA - OP2

Scenario: Verify calls state for all operators
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: Op3 clears DA call
When HMI OP3 presses DA key OP2

Scenario: Verify call state for both operators
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
