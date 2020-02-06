Meta:
@TEST_CASE_VERSION: V6
@TEST_CASE_NAME: CCF with Monitoring Call
@TEST_CASE_DESCRIPTION: As an operator having set a Conditional Call Forward rule 
I want to establish a Monitoring Call
So I can verify that the call is forwarded according to the rule
@TEST_CASE_PRECONDITION: Mission TWR has a single role assigned called TWR
Settings:
A Conditional Call Forward with:
- matching call destinations: TWR
- forward calls on:                           *out of service: OP1                           *reject: no call forwarding                           *no reply: no call forwarding
- number of rule iterations: 0
OP1 has a role assigned with:
- maximum number of incoming position monitoring calls: 1
- indicate incoming position monitoring calls on HMI: enabled
OP3 has a role assigned with:
- maximum number of outgoing position monitoring calls: 1
OP3 has in its layout a DA key with:
- call to: TWR
- call as: Active Role (Master Role)
None of the operators will have TWR role assigned
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if OP1 has an indication that is monitored
@TEST_CASE_DEVICES_IN_USE: OP1, OP3 
@TEST_CASE_ID: PVCSX-TC-12049
@TEST_CASE_GLOBAL_ID: GID-5173438
@TEST_CASE_API_ID: 17854577

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key                  | source                 | target                 | callType   |
| ROLE3-TWR-MONITORING | <<ROLE3_URI>>          | sip:507721@example.com | MONITORING |

Scenario: 1. OP3 presses function key Monitoring
Meta:
@TEST_STEP_ACTION: OP3 presses function key Monitoring
@TEST_STEP_REACTION: Function key Monitoring is in Monitoring On Going state
@TEST_STEP_REF: [CATS-REF: pfMc]
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key TWR with visible state monitoringOngoingState

Scenario: 2. OP3 presses DA key TWR
Meta:
@TEST_STEP_ACTION: OP3 presses DA key TWR
@TEST_STEP_REACTION: OP3 has DA key TWR in Monitoring Active State
@TEST_STEP_REF: [CATS-REF: 00Rq]
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 3
When HMI OP3 presses DA key TWR
Then HMI OP3 has the DA key TWR with visible state monitoringActiveState

Scenario: 3. OP1 verifies that has a call in monitoring queue container
Meta:
@TEST_STEP_ACTION: OP1 verifies that has a call in monitoring queue container
@TEST_STEP_REACTION: OP1 has a Monitoring call from OP3's master role with label ALL 
@TEST_STEP_REF: [CATS-REF: xH0t]
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has the call queue item ROLE3-TWR-MONITORING in state connected
Then HMI OP1 has the call queue item ROLE3-TWR-MONITORING in state tx_monitored
Then HMI OP1 verifies the call queue item ROLE3-TWR-MONITORING has label type showing ALL
Then HMI OP1 verifies the call queue item ROLE3-TWR-MONITORING has label name showing <<ROLE_3_NAME>>

Scenario: 4. OP3 verifies monitoring list
Meta:
@TEST_STEP_ACTION: OP3 verifies monitoring list
@TEST_STEP_REACTION: OP3 has one item in the list with Monitoring type ALL and Monitored Role TWR
@TEST_STEP_REF: [CATS-REF: aMa7]
When HMI OP3 with layout <<LAYOUT_MISSION3>> opens monitoring list using function key MONITORING menu
Then HMI OP3 verifies that popup monitoring is visible

Scenario: 4.1 OP3 verifies monitoring list entries
Then HMI OP3 verifies that monitoring list contains 1 entries
Then HMI OP3 verifies in the monitoring list that for entry 1 the first column has value ALL
Then HMI OP3 verifies in the monitoring list that for entry 1 the second column has value TWR

Scenario: 4.2 OP3 closes monitoring window
Then HMI OP3 closes monitoring popup

Scenario: 5. OP3 terminates all monitoring calls
Meta:
@TEST_STEP_ACTION: OP3 terminates all monitoring calls
@TEST_STEP_REACTION: OP3 doesn't have anymore Monitoring function key in Monitoring Active state and Op1 has 0 calls in monitoring queue container
@TEST_STEP_REF: [CATS-REF: KkkK]
When HMI OP3 with layout <<LAYOUT_MISSION3>> terminates monitoring calls using function key MONITORING menu
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING

Scenario: 5.1 Monitoring terminated on Op1
Then HMI OP1 verifies that call queue container monitoring is not visible
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - OP3 changes its layout grid tab back
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUIWindows.story,
			  voice_GG/ui/includes/@CleanupStory.story,
			  voice_GG/ui/includes/@CleanupMonitoringCalls.story
Then waiting until the cleanup is done
