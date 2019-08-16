Narrative:
As an operator initiating and receiving DA calls
I want to clear the calls in different states
So I can verify that the calls are terminated

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Establish outgoing call and terminate quickly
		  @REQUIREMENTS:GID-2510109
When HMI OP1 presses DA key OP2
When HMI OP1 presses DA key OP2
Then waiting for 2 seconds

Scenario: Verify call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Establish outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Terminate call in out_ringing state
		  @REQUIREMENTS:GID-2510109
When HMI OP1 presses DA key OP2
Then waiting for 2 seconds

Scenario: Verify call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Establish outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Callee client accepts call
When HMI OP2 presses DA key OP1

Scenario: Caller puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Verify call is on hold
Then HMI OP1 has the DA key OP2 in state hold
Then HMI OP2 has the DA key OP1 in state held

Scenario: Terminate call in hold state
		  @REQUIREMENTS:GID-2510109
When HMI OP1 declines the call on DA key OP2
Then waiting for 2 seconds

Scenario: Verify call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Establish outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Callee client accepts call
When HMI OP2 presses DA key OP1

Scenario: Callee puts call on hold
When HMI OP2 puts on hold the active call

Scenario: Verify call is on hold
Then HMI OP1 has the DA key OP2 in state held
Then HMI OP2 has the DA key OP1 in state hold

Scenario: Terminate call in held state
		  @REQUIREMENTS:GID-2510109
When HMI OP2 declines the call on DA key OP1
Then waiting for 2 seconds

Scenario: Verify call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
