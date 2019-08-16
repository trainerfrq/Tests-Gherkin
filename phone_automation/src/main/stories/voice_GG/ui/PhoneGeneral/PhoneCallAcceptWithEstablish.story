Narrative:
As a called operator having an incoming phone call from a caller operator
I want to initiate a phone call towards the caller operator
So I can verify that the incoming phone call is accepted

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
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Caller establishes an outgoing call
		  @REQUIREMENTS:GID-2510577
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for OP1
Then HMI OP1 has the DA key OP2 in state connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Verify call is connected for OP2
Then HMI OP2 has the DA key OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Callee clears outgoing call
When HMI OP2 presses DA key OP1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
