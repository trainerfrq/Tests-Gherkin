Narrative:
As a caller operator
I want to establish an outgoing IA call
So I can verify that the caller identity for the incoming call is displayed.

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source                 | target                 | callType |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | IA       |

Scenario: Caller establishes an outgoing IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1

Scenario: Verify call is connected and the caller identity is displayed
		  @REQUIREMENTS:GID-3547601
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>

Scenario: Caller client clears the phone call
When HMI OP2 presses IA key IA - OP1
Then waiting for 1 second

Scenario: Call is terminated for both
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
