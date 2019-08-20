Narrative:
As a caller operator having an active phone call with a callee operator
I want to clear the phone call
So I can verify that the phone call is terminated on both sides

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

Scenario: Caller establishes an outgoing call
		  @REQUIREMENTS:GID-2535689
		  @REQUIREMENTS:GID-2535706
		  @REQUIREMENTS:GID-2932449
		  @REQUIREMENTS:GID-2682478
		  @REQUIREMENTS:GID-2505643
		  @REQUIREMENTS:GID-2536683
		  @REQUIREMENTS:GID-2536683
		  @REQUIREMENTS:GID-3366402
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: Callee client receives the incoming call
		  @REQUIREMENTS:GID-2512204
		  @REQUIREMENTS:GID-2505646
		  @REQUIREMENTS:GID-3229739
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Verify call queue section
		  @REQUIREMENTS:GID-3371941
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the waiting list with name label <<OP1_NAME>>

Scenario: Callee client answers the incoming call
		  @REQUIREMENTS:GID-2510577
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Verify call queue section
		  @REQUIREMENTS:GID-3371942
Then HMI OP2 verifies that the call queue item OP1-OP2 was removed from the waiting list
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>

Scenario: Caller client clears the phone call
		  @REQUIREMENTS:GID-2510109
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
