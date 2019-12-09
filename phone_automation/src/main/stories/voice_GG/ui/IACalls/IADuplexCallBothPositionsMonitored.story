Narrative:
As an operator having incoming IA call monitoring activated and an incoming IA call
I want to initiate an outgoing IA call towards caller operator that has incoming IA call monitoring activated
So that I can verify that incoming IA can be monitored correctly

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP3 | <<OP1_URI>> | <<OP3_URI>> | IA       |
| OP3-OP1 | <<OP3_URI>> | <<OP1_URI>> | IA       |

Scenario: Caller establishes an outgoing IA call
When HMI OP3 with layout <<LAYOUT_MISSION3>>  selects grid tab 2
When HMI OP3 presses IA key IA - OP1
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP3 has the IA key IA - OP1 in state connected

Scenario: Callee receives incoming IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has the IA key IA - OP3 in state connected

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>
Then HMI OP3 has the call queue item OP1-OP3 in the active list with name label <<OP1_NAME>>

Scenario: Verify call direction
		  @REQUIREMENTS:GID-2841714
Then HMI OP1 has the IA call queue item OP3-OP1 with audio direction rx_monitored
Then HMI OP3 has the IA call queue item OP1-OP3 with audio direction tx_monitored

Scenario: Callee establishes an outgoing IA call, using the IA key
When HMI OP1 presses IA key IA - OP3

Scenario: Verify call direction
Then HMI OP1 has the IA call queue item OP3-OP1 with audio direction duplex
Then HMI OP3 has the IA call queue item OP1-OP3 with audio direction duplex

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>
Then HMI OP3 has the call queue item OP1-OP3 in the active list with name label <<OP1_NAME>>

Scenario: Caller clears IA call
When HMI OP3 presses IA key IA - OP1

Scenario: Verify call direction
		  @REQUIREMENTS:GID-2841714
Then HMI OP1 has the IA call queue item OP3-OP1 with audio direction tx_monitored
Then HMI OP3 has the IA call queue item OP1-OP3 with audio direction rx_monitored

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupCollapsedCallQueue.story,
			  voice_GG/ui/includes/@CleanupUICallQueueByPosition.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story
Then waiting for 1 millisecond
