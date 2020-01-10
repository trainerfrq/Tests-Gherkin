Meta:
@TEST_CASE_VERSION: V5
@TEST_CASE_NAME: MaximumOutgoingPositionMonitoringCalls
@TEST_CASE_DESCRIPTION: As an operator having 5 outgoing Position Monitoring calls I want to verify I'm not able to do a 6th Position Monitoring call only after one of the existing monitoring calls is terminated
@TEST_CASE_PRECONDITION: Op1 active mission has a role that allows maximum number of outgoing position monitoring calls
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when all 5 outgoing position monitoring calls are visible on the operator position and no other outgoing position monitoring call can be made to that position, until one of the existing position monitoring calls is terminated
@TEST_CASE_DEVICES_IN_USE: Op1, CATS tool is used to simulate 5 external operator positions
@TEST_CASE_ID: PVCSX-TC-11897
@TEST_CASE_GLOBAL_ID: GID-5157554
@TEST_CASE_API_ID: 17716880

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create endpoint configuration
Given the SIP header configuration named SipConfig:
| context | header-name   | header-value                                                              |
| *       | Subject       | monitoring                                                                |
| *       | Allow         | INVITE, ACK, BYE, CANCEL, INFO, UPDATE, REFER, NOTIFY, SUBSCRIBE, OPTIONS |
| *       | Max-Forwards  | 70                                                                        |
| *       | WG67-Version  | phone.01                                                                  |
| *       | WG67-CallType | monitoring                                                                |
| INVITE  | Priority      | non-urgent                                                                |

Given named MEP configuration:
| key              | auto-answer | capabilities | named-sip-config |
| MonitoringCall-1 | TRUE        | PCMA         | SipConfig        |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key     | profile | user-entity | sip-uri  |
| Caller1 | VOIP    | 1           | <<SIP1>> |
| Caller2 | VOIP    | 2           | <<SIP2>> |
| Caller3 | VOIP    | 3           | <<SIP3>> |
| Caller4 | VOIP    | 4           | <<SIP4>> |
| Caller5 | VOIP    | 5           | <<SIP5>> |
And phones for SipContact are created applying configuration MonitoringCall-1

Scenario: Change mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_4_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_4_NAME>>

Scenario: 1. Op1 establishes 5 outgoing GG monitoring call
Meta:
@TEST_STEP_ACTION: Op1 establishes 5 outgoing GG monitoring call
@TEST_STEP_REACTION: The 5 outgoing monitoring calls are done successfully. DA keys are signalized as having monitoring state active.
@TEST_STEP_REF: [CATS-REF: rwHd]
When HMI OP1 with layout <<LAYOUT_MISSION4>> presses function key MONITORING
When HMI OP1 starts monitoring gg calls for Test_Mayo
Then HMI OP1 has the DA key Test_Mayo with visible state monitoringActiveState
When HMI OP1 starts monitoring gg calls for Test_Alejandra
Then HMI OP1 has the DA key Test_Alejandra with visible state monitoringActiveState
When HMI OP1 starts monitoring gg calls for Test_Hurst
Then HMI OP1 has the DA key Test_Hurst with visible state monitoringActiveState
When HMI OP1 starts monitoring gg calls for Test_Ivy
Then HMI OP1 has the DA key Test_Ivy with visible state monitoringActiveState
When HMI OP1 starts monitoring gg calls for Test_Kristi
Then HMI OP1 has the DA key Test_Kristi with visible state monitoringActiveState

Scenario: 1.1 Op1 stops monitoring ongoing on the function key
When HMI OP1 with layout <<LAYOUT_MISSION4>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION4>> has the function key MONITORING in monitoringActive state

Scenario: 2. Op1 verifies the Position Monitoring function key
Meta:
@TEST_STEP_ACTION: Op1 verifies the Position Monitoring function key
@TEST_STEP_REACTION: Position Monitoring function key signalizes 5 outgoing monitoring calls
@TEST_STEP_REF: [CATS-REF: bxvK]
Then HMI OP1 with layout <<LAYOUT_MISSION4>> has the function key MONITORING label Monitoring: 5

Scenario: 3. Op1 opens the monitoring list
Meta:
@TEST_STEP_ACTION: Op1 opens the monitoring list
@TEST_STEP_REACTION: Monitoring list is open and contains 5 outgoing GG monitoring calls
@TEST_STEP_REF: [CATS-REF: IaBX]
When HMI OP1 with layout <<LAYOUT_MISSION4>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that popup monitoring is visible

Scenario: 3.1 Op1 verifies monitoring list entries
Then HMI OP1 verifies that monitoring list contains 5 entries
Then HMI OP1 verifies in the monitoring list that for entry 1 the second column has value Test_Alejandra
Then HMI OP1 verifies in the monitoring list that for entry 2 the second column has value Test_Hurst
Then HMI OP1 verifies in the monitoring list that for entry 3 the second column has value Test_Kristi
Then HMI OP1 verifies in the monitoring list that for entry 4 the second column has value Test_Ivy
Then HMI OP1 verifies in the monitoring list that for entry 5 the second column has value Test_Mayo

Scenario: 3.2 Op1 closes monitoring popup
Then HMI OP1 closes monitoring popup

Scenario: 4. Op1 attempts to  do an outgoing monitoring call to Op3
Meta:
@TEST_STEP_ACTION: Op1 attempts to  do an outgoing monitoring call to Op3
@TEST_STEP_REACTION: Op1 has a failed call to Op3
@TEST_STEP_REF: [CATS-REF: 0THP]
When HMI OP1 with layout <<LAYOUT_MISSION4>> presses function key MONITORING
When HMI OP1 starts monitoring gg calls for OP3(as Mission4)
Then HMI OP1 has the DA key OP3(as Mission4) with visible state monitoringOngoingState

Scenario: 4.1 Op1 stops monitoring ongoing on the function key
When HMI OP1 with layout <<LAYOUT_MISSION4>> presses function key MONITORING
Then HMI OP1 with layout <<LAYOUT_MISSION4>> has the function key MONITORING in monitoringActive state

Scenario: 4.2 Position Monitoring function key signalizes 5 outgoing monitoring calls
Then HMI OP1 with layout <<LAYOUT_MISSION4>> has the function key MONITORING label Monitoring: 5

Scenario: 5. Op1 terminates one outgoing position monitoring call
Meta:
@TEST_STEP_ACTION: Op1 terminates one outgoing position monitoring call
@TEST_STEP_REACTION: On Op1 position 4 outgoing position monitoring calls are visible
@TEST_STEP_REF: [CATS-REF: iFgC]
When HMI OP1 with layout <<LAYOUT_MISSION4>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that popup monitoring is visible

Scenario: 5.1 Op1 selects entry in the monitoring list
When HMI OP1 selects entry 1 in the monitoring list
Then HMI OP1 verifies that in the monitoring window clearSelected button is enabled

Scenario: 5.2 Op1 terminates monitoring for the selected item
Then HMI OP1 clicks on clearSelected button

Scenario: 5.3 Op1 closes monitoring popup
Then HMI OP1 closes monitoring popup

Scenario: 5.4 Position Monitoring function key signalizes 4 outgoing monitoring calls
Then HMI OP1 with layout <<LAYOUT_MISSION4>> has the function key MONITORING label Monitoring: 4

Scenario: 6. Op1 makes an outgoing monitoring call to Op3
Meta:
@TEST_STEP_ACTION: Op1 makes an outgoing monitoring call to Op3
@TEST_STEP_REACTION: Op1 has a successful outgoing monitoring call to Op3
@TEST_STEP_REF: [CATS-REF: 6B3Q]
When HMI OP1 with layout <<LAYOUT_MISSION4>> presses function key MONITORING
When HMI OP1 starts monitoring gg calls for OP3(as Mission4)
Then HMI OP1 has the DA key OP3(as Mission4) with visible state monitoringActiveState

Scenario: 6.1 Op1 verifies monitoring list entries
When HMI OP1 with layout <<LAYOUT_MISSION4>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that monitoring list contains 5 entries
Then HMI OP1 verifies in the monitoring list that for entry 1 the second column has value Test_Hurst
Then HMI OP1 verifies in the monitoring list that for entry 2 the second column has value Test_Kristi
Then HMI OP1 verifies in the monitoring list that for entry 3 the second column has value <<OP3_NAME>>
Then HMI OP1 verifies in the monitoring list that for entry 4 the second column has value Test_Ivy
Then HMI OP1 verifies in the monitoring list that for entry 5 the second column has value Test_Mayo

Scenario: 7. Op1 terminates the position monitoring call to Op3
Meta:
@TEST_STEP_ACTION: Op1 terminates the position monitoring call to Op3
@TEST_STEP_REACTION: On Op1 position 4 outgoing position monitoring calls are visible
@TEST_STEP_REF: [CATS-REF: wppn]
When HMI OP1 selects entry 3 in the monitoring list
Then HMI OP1 verifies that in the monitoring window clearSelected button is enabled

Scenario: 7.1 Op1 terminates monitoring for the selected item
Then HMI OP1 clicks on clearSelected button

Scenario: 7.2 Op1 verifies monitoring list entries
Then HMI OP1 verifies that monitoring list contains 4 entries

Scenario: 8. Op1 terminates all outgoing position monitoring calls
Meta:
@TEST_STEP_ACTION: Op1 terminates all outgoing position monitoring calls
@TEST_STEP_REACTION: Op1 has 0 calls in the monitoring list
@TEST_STEP_REF: [CATS-REF: jqmC]
Then HMI OP1 clicks on clearAllCalls button

Scenario: 8.1 Op1 verifies monitoring list entries
Then HMI OP1 verifies that monitoring list contains 0 entries

Scenario: 8.2 Op1 closes monitoring popup
Then HMI OP1 closes monitoring popup

Scenario: 8.3 Op1 stops monitoring ongoing on the function key
When HMI OP1 with layout <<LAYOUT_MISSION4>> presses function key MONITORING

Scenario: Remove phone
When SipContact is removed

Scenario: Change mission
When HMI OP1 with layout <<LAYOUT_MISSION4>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
