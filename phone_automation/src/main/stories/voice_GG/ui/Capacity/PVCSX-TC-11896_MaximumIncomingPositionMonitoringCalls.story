Meta: @TEST_CASE_VERSION: V9
	  @TEST_CASE_NAME: MaximumIncomingPositionMonitoringCalls
	  @TEST_CASE_DESCRIPTION: As an operator having 5 incoming Position Monitoring calls and another operator attempts to do a Position Monitoring call to my position I want to verify that the operator will not be able to do Position Monitoring to  my position only after one of the monitoring calls is terminated
	  @TEST_CASE_PRECONDITION: Op1 active mission has a role that has the maximum allowed number of incoming position monitoring calls
	  @TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when all 5 incoming position monitoring calls are visible on the operator position and no other incoming position monitoring call can be made to that position, until one of the existing position monitoring calls is terminated
	  @TEST_CASE_DEVICES_IN_USE: Op1, Op3, CATS tool is used to simulate 5 external position monitoring calls
	  @TEST_CASE_ID: PVCSX-TC-11896
	  @TEST_CASE_GLOBAL_ID: GID-5156986
	  @TEST_CASE_API_ID: 17715979

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
| *       | WG67-Version  | phone.02                                                                  |
| *       | WG67-CallType | phone.02;monitoring                                                       |
| INVITE  | Priority      | non-urgent                                                                |

Given named MEP configuration:
| key              | auto-answer | capabilities | named-sip-config |
| MonitoringCall-1 | TRUE        | PCMA         | SipConfig        |

Scenario: Create sip phone
Given SipContacts group SipContact1:
| key     | profile | user-entity | sip-uri  |
| Caller1 | VOIP    | 1           | <<SIP1>> |
And phones for SipContact1 are created applying configuration MonitoringCall-1

Given SipContacts group SipContact2:
| key     | profile | user-entity | sip-uri  |
| Caller2 | VOIP    | 2           | <<SIP2>> |
| Caller3 | VOIP    | 3           | <<SIP3>> |
| Caller4 | VOIP    | 4           | <<SIP4>> |
| Caller5 | VOIP    | 5           | <<SIP5>> |
And phones for SipContact2 are created applying configuration MonitoringCall-1

Scenario: Define call queue items
Given the call queue items:
| key                    | source      | target                 | callType   |
| Caller1-OP1-MONITORING | <<SIP1>>    | <<OPVOICE1_PHONE_URI>> | MONITORING |
| Caller2-OP1-MONITORING | <<SIP2>>    | <<OPVOICE1_PHONE_URI>> | MONITORING |
| Caller3-OP1-MONITORING | <<SIP3>>    | <<OPVOICE1_PHONE_URI>> | MONITORING |
| Caller4-OP1-MONITORING | <<SIP4>>    | <<OPVOICE1_PHONE_URI>> | MONITORING |
| Caller5-OP1-MONITORING | <<SIP5>>    | <<OPVOICE1_PHONE_URI>> | MONITORING |
| OP3-OP1-MONITORING     | <<OP3_URI>> | <<OP1_URI>>            | MONITORING |

Scenario: Change mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_4_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_4_NAME>>

Scenario: 1. Have 5 external incoming position monitoring calls that call Op1
Meta: @TEST_STEP_ACTION: Have 5 external incoming position monitoring calls that call Op1
@TEST_STEP_REACTION: Op1 receives 5 position monitoring calls
@TEST_STEP_REF: [CATS-REF: sXx8]
When SipContact1 calls SIP URI <<OPVOICE1_PHONE_URI>>
When SipContact2 calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 1.1 Op1 has the visual indication that it is monitored
Then HMI OP1 verifies that call queue container monitoring is visible
Then HMI OP1 has in the collapsed monitoring area a number of 5 calls

Scenario: 2. Op1 opens the collapsed list of calls and verifies calls
Meta: @TEST_STEP_ACTION: Op1 opens the collapsed list of calls and verifies calls
@TEST_STEP_REACTION: Calls list is open and details regarding the calls are visible
@TEST_STEP_REF: [CATS-REF: 5cnU]
Then HMI OP1 click on call queue Elements of monitoring list
Then HMI OP1 has the call queue item Caller1-OP1-MONITORING in state tx_monitored
Then HMI OP1 has the call queue item Caller2-OP1-MONITORING in state tx_monitored
Then HMI OP1 has the call queue item Caller3-OP1-MONITORING in state tx_monitored
Then HMI OP1 has the call queue item Caller4-OP1-MONITORING in state tx_monitored
Then HMI OP1 has the call queue item Caller5-OP1-MONITORING in state tx_monitored

Scenario: 3. Op3 attempts to do a position monitoring call to Op1
Meta: @TEST_STEP_ACTION: Op3 attempts to do a position monitoring call to Op1
@TEST_STEP_REACTION: Op3 attempt to call Op1 fails
@TEST_STEP_REF: [CATS-REF: ThIk]
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key OP1 with visible state monitoringOngoingState

Scenario: 3.1 Op3 chooses to monitor Op1
When HMI OP3 presses DA key OP1
And waiting for 1 second
Then HMI OP3 verifies that the DA key OP1 has the info label busy

Scenario: 3.2 Op3 stops monitoring ongoing on the function key
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING

Scenario: 3.3 Op3 terminates failed call
When HMI OP3 presses DA key OP1

Scenario: 4. One incoming position monitoring call is terminated
Meta: @TEST_STEP_ACTION: One incoming position monitoring call is terminated
@TEST_STEP_REACTION: On Op1 position 4 incoming position monitoring calls are visible
@TEST_STEP_REF: [CATS-REF: y0c8]
When VoIP SipContact1 gets terminated

Scenario: 4.1 Op1 has 4 incoming position monitoring calls are visible
Then HMI OP1 has in the collapsed monitoring area a number of 4 calls

Scenario: 5. Op3 establishes a position monitoring call to Op1
Meta: @TEST_STEP_ACTION: Op3 establishes a position monitoring call to Op1
@TEST_STEP_REACTION: Op1 receives a position monitoring call from Op3. Op1 has 5 incoming position monitoring calls
@TEST_STEP_REF: [CATS-REF: Vwhh]
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MONITORING
Then HMI OP3 with layout <<LAYOUT_MISSION3>> has the function key MONITORING in monitoringOnGoing state
Then HMI OP3 has the DA key OP1 with visible state monitoringOngoingState

Scenario: 5.1 Op3 chooses to monitor Op1
When HMI OP3 presses DA key OP1
And waiting for 1 second

Scenario: 5.2 Op1 has 5 incoming position monitoring calls are visible
Then HMI OP1 has in the collapsed monitoring area a number of 5 calls
Then HMI OP1 has the call queue item Caller2-OP1-MONITORING in state tx_monitored
Then HMI OP1 has the call queue item Caller3-OP1-MONITORING in state tx_monitored
Then HMI OP1 has the call queue item Caller4-OP1-MONITORING in state tx_monitored
Then HMI OP1 has the call queue item Caller5-OP1-MONITORING in state tx_monitored
Then HMI OP1 has the call queue item OP3-OP1-MONITORING in state tx_monitored

Scenario: 6. Op3 terminates incoming position monitoring call
Meta: @TEST_STEP_ACTION: Op3 terminates incoming position monitoring call
@TEST_STEP_REACTION: On Op1 position 4 outgoing position monitoring calls are visible
@TEST_STEP_REF: [CATS-REF: Hv8g]
When HMI OP3 with layout <<LAYOUT_MISSION3>> terminates monitoring calls using function key MONITORING menu

Scenario: 6.1 Op1 has 4 incoming position monitoring calls are visible
Then HMI OP1 has in the collapsed monitoring area a number of 4 calls

Scenario: 7. All incoming position monitoring calls are terminated
Meta: @TEST_STEP_ACTION: All incoming position monitoring calls are terminated
@TEST_STEP_REACTION: Op1 has 0 calls in the queue
@TEST_STEP_REF: [CATS-REF: BbNd]
When VoIP SipContact2 gets terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact1 is removed
When SipContact2 is removed

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