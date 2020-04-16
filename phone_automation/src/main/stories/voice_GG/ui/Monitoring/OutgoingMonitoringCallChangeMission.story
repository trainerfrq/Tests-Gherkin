Narrative:
As an operator having outgoing position monitoring calls enabled
I want to send monitoring call and change mission
So I can verify that outgoing monitoring call is not affected by this action

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Op1 activates Monitoring
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP1 has the DA key OP3 with visible state monitoringOngoingState

Scenario: Op1 chooses to monitor Op3
		  @REQUIREMENTS:GID-2505728
When HMI OP1 starts monitoring gg calls for OP3
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringActive state

Scenario: Op3 has no visual indication that it is monitored
Then HMI OP3 verifies that call queue container monitoring is not visible

Scenario: Op1 opens monitoring list
When HMI OP1 with layout <<LAYOUT_MISSION1>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that popup monitoring is visible

Scenario: Op1 verifies monitoring list entries
Then HMI OP1 verifies that monitoring list contains 1 entries
Then HMI OP1 verifies in the monitoring list that for entry 1 the first column has value GG
Then HMI OP1 verifies in the monitoring list that for entry 1 the second column has value <<OP3_NAME>>

Scenario: Op1 closes monitoring popup
Then HMI OP1 closes monitoring popup

Scenario: Op1 changes mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op1 has a visible indication that is not monitoring anymore Op3
Then HMI OP1 has the DA key OP3(as Mission2) with not visible state monitoringActiveState

Scenario: Op1 opens monitoring list
When HMI OP1 with layout <<LAYOUT_MISSION2>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that popup monitoring is visible

Scenario: Op1 verifies monitoring list entries
Then HMI OP1 verifies that monitoring list contains 0 entries

Scenario: Op1 closes monitoring popup
Then HMI OP1 closes monitoring popup

Scenario: Op3 has no visual indication that it is monitored
Then HMI OP3 verifies that call queue container monitoring is not visible

Scenario: Op1 changes mission
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op1 has a visible indication that is not monitoring anymore Op3
Then HMI OP1 has the DA key OP3 with not visible state monitoringActiveState

Scenario: Op3 has no visual indication that it is monitored
Then HMI OP3 verifies that call queue container monitoring is not visible

Scenario: Op1 activates Monitoring
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING

Scenario: Op1 chooses to monitor Op3
When HMI OP1 starts monitoring gg calls for OP3
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key MONITORING in monitoringActive state

Scenario: Op1 opens monitoring list
When HMI OP1 with layout <<LAYOUT_MISSION1>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that popup monitoring is visible

Scenario: Op1 verifies monitoring list entries
Then HMI OP1 verifies that monitoring list contains 1 entries
Then HMI OP1 verifies in the monitoring list that for entry 1 the first column has value GG
Then HMI OP1 verifies in the monitoring list that for entry 1 the second column has value <<OP3_NAME>>

Scenario: Op1 terminates all monitoring calls
Then HMI OP1 clicks on clearAllCalls button
Then HMI OP1 verifies that monitoring list contains 0 entries

Scenario: Op1 closes monitoring popup
Then HMI OP1 closes monitoring popup

Scenario: Op1 verifies that it has no visual indication of an incoming monitoring call
Then HMI OP1 verifies that call queue container monitoring is not visible

Scenario: Op1 hasn't a visible indication that it is monitoring Op3
Then HMI OP1 has the DA key OP3 with not visible state monitoringActiveState

Scenario: Op3 has no visual indication that it is monitored
Then HMI OP3 verifies that call queue container monitoring is not visible

Scenario: Verify number of calls in call queue for Op3
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Verify number of calls in call queue for Op1
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done






