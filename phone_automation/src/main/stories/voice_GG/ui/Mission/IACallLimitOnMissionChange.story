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
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | IA       |
| OP3-OP2 | <<OP3_URI>> | <<OP2_URI>> | IA       |

Scenario: Op1 establishes an outgoing IA call towards Op2
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: Callee Op2 receives incoming IA call from Op1
Then HMI OP2 has the call queue item OP1-OP2 in state connected
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Callee Op2 changes the mission
When HMI OP2 clicks on DISPLAY STATUS label mission
Then HMI OP2 has a list of 3 missions available
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then wait for 5 seconds

Scenario: Verify mission change
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission MAN-NIGHT-TACT

Scenario: Op3 establishes an outgoing IA call towards Op2
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 2
When HMI OP3 presses IA key IA - OP2
Then HMI OP3 has the call queue item OP2-OP3 in state connected
Then HMI OP3 has the IA key IA - OP2 in state connected

Scenario: Callee Op2 receives incoming IA call from Op3
		  @REQUIREMENTS:GID-3236103
Then HMI OP2 click on call queue Elements list
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP2 has in the call queue a number of 2 calls

Scenario: Callee Op2 changes to previous mission
When HMI OP2 clicks on DISPLAY STATUS label mission
Then HMI OP2 has a list of 3 missions available
Then HMI OP2 changes current mission to mission WEST-EXEC
Then HMI OP2 activates mission
Then wait for 5 seconds

Scenario: Verify mission change
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission WEST-EXEC

Scenario: Callee Op2 remains connected in both IA calls
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 has the IA key IA - OP1 in state connected
Then HMI OP2 has the IA key IA - OP3 in state connected
Then HMI OP2 click on call queue Elements list
Then HMI OP2 has in the call queue a number of 2 calls
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected

Scenario: Op1 cleans up the outgoing call
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has in the call queue a number of 0 calls
Then wait for 6 seconds

Scenario: Call is also terminated for callee
Then HMI OP2 has in the active list a number of 1 calls

Scenario: Op3 cleans up the outgoing call
When HMI OP3 presses IA key IA - OP2
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Call is also terminated for callee
Then HMI OP2 has in the active list a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond






