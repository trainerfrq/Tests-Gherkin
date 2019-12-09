Narrative:
As an operator
I want to initiate an outgoing IA call towards a role that is active on 2 positions
So that I can verify that the IA call is automatically accepted by one of the position without a specific priority

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key          | source        | target        | callType |
| OP2-OP1-ROLE | <<ROLE2_URI>> | <<ROLE1_URI>> | IA       |
| OP1-OP2-ROLE | <<ROLE1_URI>> |               | IA       |
| OP1-OP2-1    | <<ROLE1_URI>> | <<ROLE2_URI>> | IA       |

Scenario: Change mission
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Caller establishes an outgoing IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>>  selects grid tab 2
When HMI OP2 presses IA key IA - <<ROLE_1_NAME>>
Then HMI OP2 has the call queue item OP1-OP2-ROLE in state connected
Then HMI OP2 has the IA key IA - <<ROLE_1_NAME>> in state connected

Scenario: Callee receives incoming IA call
When HMI OP3 with layout <<LAYOUT_MISSION1>> selects grid tab 2
Then HMI OP3 has the call queue item OP2-OP1-ROLE in state connected

Scenario: Verify call queue section
Then HMI OP3 has the call queue item OP2-OP1-ROLE in the active list with name label <<ROLE_2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2-ROLE in the active list with name label <<ROLE_1_NAME>>

Scenario: Verify call direction
		  @REQUIREMENTS:GID-2841714
Then HMI OP3 has the IA call queue item OP2-OP1-ROLE with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2-ROLE with audio direction tx_monitored

Scenario: Op1 establish an outgoing IA call to Op2 active role
		  @REQUIREMENTS:GID-2505705
		  @REQUIREMENTS:GID-3371939
When HMI OP1 with layout <<LAYOUT_MISSION1>>  selects grid tab 2
When HMI OP1 presses IA key IA - <<ROLE_2_NAME>>

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1-ROLE with audio direction tx
Then HMI OP2 has the IA call queue item OP1-OP2-1 with audio direction duplex
Then HMI OP3 has the IA call queue item OP2-OP1-ROLE with audio direction rx_monitored

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP2-OP1-ROLE in the active list with name label <<ROLE_2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2-ROLE in the active list with name label <<ROLE_1_NAME>>
Then HMI OP3 has the call queue item OP2-OP1-ROLE in the active list with name label <<ROLE_2_NAME>>

Scenario: Op2 clears IA call
When HMI OP2 presses IA key IA - <<ROLE_1_NAME>>

Scenario: Verify call direction
		  @REQUIREMENTS:GID-2841714
Then HMI OP1 has the IA call queue item OP2-OP1-ROLE with audio direction tx
Then HMI OP2 has the IA call queue item OP1-OP2-ROLE with audio direction rx

Scenario: Call is terminated also for Op3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - <<ROLE_2_NAME>>
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op1
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Caller establishes an outgoing IA call
When HMI OP2 presses IA key IA - <<ROLE_1_NAME>>
Then HMI OP2 has the call queue item OP1-OP2-ROLE in state connected
Then HMI OP2 has the IA key IA - <<ROLE_1_NAME>> in state connected

Scenario: Callee receives incoming IA call
Then HMI OP1 has the call queue item OP2-OP1-ROLE in state connected
Then HMI OP1 has the IA key IA - <<ROLE_2_NAME>> in state connected

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP2-OP1-ROLE in the active list with name label <<ROLE_2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2-ROLE in the active list with name label <<ROLE_1_NAME>>

Scenario: Verify call direction
		  @REQUIREMENTS:GID-2841714
Then HMI OP1 has the IA call queue item OP2-OP1-ROLE with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2-ROLE with audio direction tx_monitored

Scenario: Verify that Op3 does not have a call
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup IA call
When HMI OP2 presses IA key IA - <<ROLE_1_NAME>>
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: Change mission
When HMI OP3 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_3_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
