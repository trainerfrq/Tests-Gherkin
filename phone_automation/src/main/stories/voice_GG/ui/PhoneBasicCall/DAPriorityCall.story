Narrative:
As an operator
I want to initiate an outgoing DA priority call towards another operator
So I can check that all the call attributes are set for the call

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

Scenario: Caller establishes an outgoing priority call
		  @REQUIREMENTS:GID-2505647
		  @REQUIREMENTS:GID-2536682
		  @REQUIREMENTS:GID-2505649
When HMI OP1 initiates a priority call on DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming priority call
		  @REQUIREMENTS:GID-2535717
		  @REQUIREMENTS:GID-2505701
		  @REQUIREMENTS:GID-2505702
		  @REQUIREMENTS:GID-3685306
		  @REQUIREMENTS:GID-3229739
		  @REQUIREMENTS:GID-2512204
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has in the call queue the item OP1-OP2 with priority

Scenario: Verify call queue section
		  @REQUIREMENTS:GID-3371936
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the priority list with name label <<OP1_NAME>>

Scenario: Callee client answers the incoming priority call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Verify call queue section
		  @REQUIREMENTS:GID-3371937
Then HMI OP2 verifies that the call queue item OP1-OP2 was removed from the priority list
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<OP2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>

Scenario: Callee terminates call
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
