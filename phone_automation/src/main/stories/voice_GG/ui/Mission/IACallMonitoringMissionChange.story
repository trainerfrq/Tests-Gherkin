Narrative:
As a caller operator having an active IA call with a callee operator
I want to change mission
So I can verify that the IA call is not affected by this action

Meta: @AfterStory: ../includes/@SwitchToInitialMission.story

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

Scenario: Caller establishes an outgoing IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Callee receives incoming IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: Verify call direction
		  @REQUIREMENTS:GID-2841714
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction tx_monitored

Scenario: Change mission for HMI OP1
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission WEST-EXEC
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify call state for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction tx_monitored

Scenario: Change mission for HMI OP2
		  @REQUIREMENTS: GID-3005111
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission MAN-NIGHT-TACT
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify call state for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction tx_monitored

Scenario: Cleanup IA call
Then HMI OP2 terminates the call queue item OP1-OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION1>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond