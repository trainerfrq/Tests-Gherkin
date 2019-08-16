Narrative:
As an operator part of an active call
I want to transfer the active call to a transfer target operator without using an intermediary consultation call
So I can verify that the call was transferred successfully

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
| OP3-OP2 | <<OP3_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | DA/IDA   |
| OP1-OP3 | <<OP1_URI>> | <<OP3_URI>> | DA/IDA   |
| OP3-OP1 | <<OP3_URI>> | <<OP1_URI>> | DA/IDA   |

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
When HMI OP1 initiates a transfer on the active call

Scenario: Verify call is put on hold
Then HMI OP1 has the call queue item OP2-OP1 in state hold

Scenario: Verify call transfer is initiated
Then HMI OP1 has the call conditional flag set for call queue item OP2-OP1
Then HMI OP1 has the call queue item OP2-OP1 in the hold list with info label XFR Hold

Scenario: Verify call is held for transferee
Then HMI OP2 has the call queue item OP1-OP2 in state held

Scenario: Transferor initiates consultation call
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state out_ringing

Scenario: Transfer target receives incoming call
Then HMI OP3 has the DA key OP1 in state inc_initiated

Scenario: Transferor finishes transfer
		  @REQUIREMENTS:GID-2510076
		  @REQUIREMENTS:GID-2510078
When HMI OP1 presses DA key OP3

Scenario: Verify call was transferred
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has the call queue item OP3-OP2 in state out_ringing
Then HMI OP3 has the call queue item OP2-OP3 in state inc_initiated

Scenario: Transfer target answers incoming call
When HMI OP3 presses DA key OP2
And waiting for 1 seconds

Scenario: Verify call is connected for both operators
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: Cleanup call
When HMI OP2 presses DA key OP3
And waiting for 1 seconds
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond


