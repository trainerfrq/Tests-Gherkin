Narrative:
As a caller operator
I want to initiate an outgoing IA call to my own operator position
So I can verify that there is no incoming call on my operator position

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP2-OP2 | <<OP2_URI>> | <<OP2_URI>> | IA       |

Scenario: Caller establishes an outgoing IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP2

Scenario: Verify call is received and call status is failed
		  @REQUIREMENTS:GID-2535698
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the IA key IA - OP2 in state out_failed
Then HMI OP2 has the call queue item OP2-OP2 in state out_failed

Scenario: Caller clears outgoing call
When HMI OP2 presses IA key IA - OP2

Scenario: Call is terminated
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting for 1 millisecond
