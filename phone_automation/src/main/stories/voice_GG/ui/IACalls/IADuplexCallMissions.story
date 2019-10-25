Narrative:
As an operator having an incoming simplex IA call
I want to initiate an outgoing IA call towards caller operator
So that I can verify that a duplex IA call is established

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source        | target        | callType |
| OP1-OP2   | <<ROLE1_URI>> | <<ROLE2_URI>> | IA       |
| OP2-OP1   | <<ROLE2_URI>> |               | IA       |
| OP2-OP1-1 | <<ROLE2_URI>> | <<ROLE1_URI>> | IA       |

Scenario: Caller establishes an outgoing IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>>  selects grid tab 2
When HMI OP1 presses IA key IA - <<ROLE_2_NAME>>
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - <<ROLE_2_NAME>> in state connected

Scenario: Callee receives incoming IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - <<ROLE_1_NAME>> in state connected

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP2-OP1 in the active list with name label <<ROLE_2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<ROLE_1_NAME>>

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction tx
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction rx

Scenario: Callee establishes an outgoing IA call, using the IA key
		  @REQUIREMENTS:GID-2505705
		  @REQUIREMENTS:GID-3371939
When HMI OP2 presses IA key IA - <<ROLE_1_NAME>>
Then wait for 2 seconds

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1-1 with audio direction duplex
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction duplex

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP2-OP1-1 in the active list with name label <<ROLE_2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<ROLE_1_NAME>>

Scenario: Caller clears IA call
When HMI OP1 presses IA key IA - <<ROLE_2_NAME>>

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1-1 with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction tx_monitored

Scenario: Cleanup IA call
When HMI OP2 presses IA key IA - <<ROLE_1_NAME>>
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Caller establishes an outgoing IA call
When HMI OP1 presses IA key IA - <<ROLE_2_NAME>>
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - <<ROLE_2_NAME>> in state connected

Scenario: Callee receives incoming IA call
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - <<ROLE_1_NAME>> in state connected

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction tx
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction rx

Scenario: Callee establishes an outgoing IA call, using the call queue item
Then HMI OP2 accepts the call queue item OP1-OP2
And waiting for 1 second

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1-1 with audio direction duplex
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction duplex

Scenario: Callee clears IA call
When HMI OP2 presses IA key IA - <<ROLE_1_NAME>>

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1-1 with audio direction tx
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction rx

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - <<ROLE_2_NAME>>
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
