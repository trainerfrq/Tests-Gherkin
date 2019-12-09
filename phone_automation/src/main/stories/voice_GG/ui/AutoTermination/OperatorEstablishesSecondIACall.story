Narrative:
As an operator who initiated an IA call
I want to initiate a second IA call towards another operator
So that I can verify that the first IA call is terminated and the second one is set up

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
| OP3-OP2 | <<OP3_URI>> | <<OP2_URI>> | IA       |
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | IA       |

Scenario: Caller establishes an outgoing IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Callee receives incoming IA call
Then HMI OP1 has the call queue item OP2-OP1 in state connected

Scenario: Caller establishes an outgoing IA call
When HMI OP2 presses IA key IA - OP3
And waiting for 1 second
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP2 has the IA key IA - OP3 in state connected

Scenario: Callee receives incoming IA call
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: First IA call is terminated
		  @REQUIREMENTS:GID-2878005
		  @REQUIREMENTS:GID-2878006
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP2 has in the active list a number of 1 calls

Scenario: Cleanup IA call
When HMI OP2 presses IA key IA - OP3
And waiting for 1 second

Scenario: Verify call is ended
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP2 has in the active list a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
