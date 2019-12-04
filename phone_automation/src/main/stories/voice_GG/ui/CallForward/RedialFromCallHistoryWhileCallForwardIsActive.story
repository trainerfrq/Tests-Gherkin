Narrative:
As a caller operator having Call Forward active
I want to make an outgoing call from Call History
So I can verify that call can be done while Call Forward is active

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key        | source      | target      | callType |
| OP1-OP2-DA | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1-DA | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |
| OP1-OP2-IA | <<OP1_URI>> | <<OP2_URI>> | IA       |
| OP2-OP1-IA | <<OP2_URI>> | <<OP1_URI>> | IA       |

Scenario: Op1 activates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state

Scenario: Op1 chooses Op2 as call forward target
		  @REQUIREMENTS:GID-2521111
When HMI OP1 presses DA key OP2
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 verifies that call queue info container is visible
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 clears call history list
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 clears Call History list
Then HMI OP1 verifies that call history list contains 0 entries
Then HMI OP1 closes Call History popup window

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the active list a number of 0 calls

Scenario: Op1 redials from CallHistory
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 redials last number from call history
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated

Scenario: Op2 client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1-DA in state connected
Then HMI OP2 has the call queue item OP1-OP2-DA in state connected
Then HMI OP2 verifies that call queue item bar signals call state active

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op1 establishes an outgoing priority call
When HMI OP1 initiates a priority call on DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Op2 client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has in the call queue the item OP1-OP2-DA with priority

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the active list a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 redials from CallHistory
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 redials last number from call history
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Op2 client answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1-DA in state connected
Then HMI OP2 has the call queue item OP1-OP2-DA in state connected
Then HMI OP2 verifies that call queue item bar signals call state priority

Scenario: Op1 client clears the phone call
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 verifies that call queue info container is visible

Scenario: Op1 establishes an outgoing IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the call queue item OP2-OP1-IA in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: Op2 receives incoming IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 has the call queue item OP1-OP2-IA in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 redials from CallHistory
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 redials last number from call history
!-- TODO Disable story until bug QXVP-14263 is fixed
Then HMI OP1 has the call queue item OP2-OP1-IA in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: Op2 receives incoming IA call
Then HMI OP2 has the call queue item OP1-OP2-IA in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
