Narrative:
As an operator
I want to configure a DA keys with different Source SIP Addresses
So I can verify that the call is established properly

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source           | target                | callType |
| OP1-OP2-1 | <<OP1_URI>>      | <<OP2_URI>>           | DA/IDA   |
| OP1-OP2-2 | <<ROLE1_URI>> | <<OP2_URI>>           | DA/IDA   |
| OP2-Role1 | <<OP2_URI>>      | sip:role1@example.com | DA/IDA   |
| OP1-OP2-3 | <<OP1_URI>>      | <<OP2_URI>>           | IA       |
| OP1-OP2-4 | <<ROLE1_URI>> | <<ROLE2_URI>>      | IA       |
| OP2-ROLE1 | <<OP2_URI>>      | sip:role1@example.com | IA       |

Scenario: Outgoing DA call using as source Physical OP SIP Address
		  @REQUIREMENTS:GID-4123501
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP2 has the call queue item OP1-OP2-1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2-1 in the waiting list with name label <<OP1_NAME>>

Scenario: Caller clears outgoing call
When HMI OP1 presses DA key OP2

Scenario: Outgoing DA call using as source the actual active mission
When HMI OP1 presses DA key OP2(as ActiveMission)
Then HMI OP1 has the DA key OP2(as ActiveMission) in state out_ringing
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP2 has the call queue item OP1-OP2-2 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2-2 in the waiting list with name label <<ROLE_1_NAME>>

Scenario: Caller clears outgoing call
When HMI OP1 presses DA key OP2(as ActiveMission)

Scenario: Outgoing DA call using as source a configured role
When HMI OP2 presses DA key ROLE1
Then HMI OP2 has the DA key ROLE1 in state out_ringing
Then HMI OP1 has the call queue item OP2-Role1 in state inc_initiated
Then HMI OP3 has the call queue item OP2-Role1 in state inc_initiated

Scenario: Caller clears outgoing call
When HMI OP2 presses DA key ROLE1

Scenario: Outgoing IA call using as source Physical OP SIP Address
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the IA key IA - OP2 in state connected
Then HMI OP2 has the call queue item OP1-OP2-3 in state connected
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - OP2

Scenario: Outgoing IA call using as source the actual active mission
When HMI OP1 presses IA key IA - <<ROLE_2_NAME>>
Then HMI OP1 has the IA key IA - <<ROLE_2_NAME>> in state connected
Then HMI OP2 has the call queue item OP1-OP2-4 in state connected
Then HMI OP2 has the IA key <<ROLE_1_NAME>> in state connected

Scenario: Cleanup IA call
When HMI OP1 presses IA key IA - <<ROLE_2_NAME>>

Scenario: Outgoing DA call using as source a configured role
When HMI OP2 presses IA key IA - ROLE1
Then HMI OP2 has the IA key IA - ROLE1 in state connected
Then wait for 2 seconds
Then the call queue item OP2-ROLE1 is connected for only one of the operator positions: HMI OP1, HMI OP3

Scenario: Cleanup IA call
When HMI OP2 presses IA key IA - ROLE1

Scenario: Verify call is terminated for both operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

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
