Narrative:
As an operator
I want to press CallForward button and then receiving a DA call
So I can verify that Call Forward button is in the desired state

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

Scenario: Op1 presses Call Forward button
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is visible
Then HMI OP1 verifies that the DA key OP2 has the info label Call Fwd

Scenario: Op1 verifies notification message
Then HMI OP1 has a notification that shows Select Call Forward target

Scenario: Op2 establish an outgoing call to Op1
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state out_ringing

Scenario: Op1 verifies Call Forward button state
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is visible

Scenario: Op1 receives the incoming call
Then HMI OP1 has the call queue item OP2-OP1 in state inc_initiated

Scenario: Verifying call queue sections
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>
Then HMI OP1 has the call queue item OP2-OP1 in the waiting list with name label <<OP2_NAME>>

Scenario: Op1 answers the incoming call
When HMI OP1 presses DA key OP2

Scenario: Verifying call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is visible
Then HMI OP1 verifies that the DA key OP2 has the type label DA

Scenario: Op1 clears the call
When HMI OP1 presses DA key OP2
And waiting for 10 milliseconds
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is visible
Then HMI OP1 verifies that the DA key OP2 has the info label Call Fwd

Scenario: Op1 verifies notification message
Then HMI OP1 has a notification that shows Select Call Forward target

Scenario: Op1 deactivates Call Forward functionality
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> verifies that timerBar for function key CALLFORWARD is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
