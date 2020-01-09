Meta:
@TEST_CASE_VERSION: V5
@TEST_CASE_NAME: MaximumIncomingIACallsandChangeMission
@TEST_CASE_DESCRIPTION: As an operator having 3 incoming external IA calls I want to change mission So I can verify that the incoming calls are not affected by the mission active role settings
@TEST_CASE_PRECONDITION: Test starts with Op1 having mission MISSION_1_NAME MISSION_1_NAME has an active role that allows 3 incoming IA calls MISSION_2_NAME has an active role that allows 1 incoming IA call
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when the call limit is applied after changing mission
@TEST_CASE_DEVICES_IN_USE:  
CATS tool is used to simulate 3 external AA calls
@TEST_CASE_ID: PVCSX-TC-11892
@TEST_CASE_GLOBAL_ID: GID-5154906
@TEST_CASE_API_ID: 17697570

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
| *       | Subject       | IA call                                                                   |
| *       | Allow         | INVITE, ACK, BYE, CANCEL, INFO, UPDATE, REFER, NOTIFY, SUBSCRIBE, OPTIONS |
| *       | Max-Forwards  | 70                                                                        |
| *       | WG67-Version  | phone.01                                                                  |
| *       | WG67-CallType | ia call                                                                   |
| INVITE  | Priority      | urgent                                                                    |

Given named MEP configuration:
| key      | capabilities | named-sip-config |
| IACall-1 | PCMA         | SipConfig        |

Scenario: Create sip phones
Given SipContacts group SipContact1:
| key      | profile | user-entity | sip-uri   |
| Caller1  | VOIP    | 1           | <<SIP1>>  |
| Caller2  | VOIP    | 2           | <<SIP2>>  |
And phones for SipContact1 are created applying configuration IACall-1

Given SipContacts group SipContact2:
| key      | profile | user-entity | sip-uri   |
| Caller3  | VOIP    | 3           | <<SIP3>>  |
And phones for SipContact2 are created applying configuration IACall-1

Scenario: Define call queue items
Given the call queue items:
| key         | source      | target                 | callType |
| OP1-OP2     | <<OP1_URI>> | <<OP2_URI>>            | IA       |
| OP2-OP1     | <<OP2_URI>> | <<OP1_URI>>            | IA       |
| Caller1-OP1 | <<SIP1>>    | <<OPVOICE1_PHONE_URI>> | IA       |
| Caller2-OP1 | <<SIP2>>    | <<OPVOICE1_PHONE_URI>> | IA       |
| Caller3-OP1 | <<SIP3>>    | <<OPVOICE1_PHONE_URI>> | IA       |

Scenario: 1. Have 3 external IA calls that call Op1
Meta:
@TEST_STEP_ACTION: Have 3 external IA calls that call Op1
@TEST_STEP_REACTION: Op1 has 3 half-duplex IA calls
@TEST_STEP_REF: [CATS-REF: ejyL]
When SipContact1 calls SIP URI <<OPVOICE1_PHONE_URI>>
When SipContact2 calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 1.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 2 calls

Scenario: 1.2 Verify call direction
Then HMI OP1 click on call queue Elements list
Then HMI OP1 has the IA call queue item Caller1-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item Caller2-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item Caller3-OP1 with audio direction rx_monitored

Scenario: 2. Op1 changes mission to MISSION_2_NAME
Meta:
@TEST_STEP_ACTION: Op1 changes mission to MISSION_2_NAME
@TEST_STEP_REACTION: Op1 active mission is MISSION_2_NAME
@TEST_STEP_REF: [CATS-REF: cq3z]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 2.1 Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: 3. Op1 verifies the number of incoming calls in the queue
Meta:
@TEST_STEP_ACTION: Op1 verifies the number of incoming calls in the queue
@TEST_STEP_REACTION: Op1 has 3 half-duplex IA calls
@TEST_STEP_REF: [CATS-REF: 5nNX]
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 2 calls

Scenario: 3.1 Verify call direction
Then HMI OP1 click on call queue Elements list
Then HMI OP1 has the IA call queue item Caller1-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item Caller2-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item Caller3-OP1 with audio direction rx_monitored

Scenario: 4. 2 external IA calls are terminated
Meta:
@TEST_STEP_ACTION: 2 external IA calls are terminated
@TEST_STEP_REACTION: Op1 has 1 half-duplex IA calls
@TEST_STEP_REF: [CATS-REF: S5Qx]
When VoIP SipContact1 gets terminated

Scenario: 4.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 4.2 Verify call direction
Then HMI OP1 has the IA call queue item Caller3-OP1 with audio direction rx_monitored

Scenario: 5. Op3 attempts to do an IA call to Op1
Meta:
@TEST_STEP_ACTION: Op3 attempts to do an IA call to Op1
@TEST_STEP_REACTION: Op3 attempt to call fails
@TEST_STEP_REF: [CATS-REF: bI7P]
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 2
When HMI OP3 presses IA key IA - OP1

Scenario: 5.1 Op3 has a failed call in the call queue
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has the IA key IA - OP1 in state out_failed

Scenario: 5.2 Op3 terminates failed call
When HMI OP3 presses IA key IA - OP1

Scenario: 6. Op1 changes mission to MISSION_1_NAME
Meta:
@TEST_STEP_ACTION: Op1 changes mission to MISSION_1_NAME
@TEST_STEP_REACTION: Op1 active mission is MISSION_1_NAME. Op1 has 1 half-duplex IA calls
@TEST_STEP_REF: [CATS-REF: lkYl]
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 6.1 Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: 6.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 6.3 Verify call direction
Then HMI OP1 has the IA call queue item Caller3-OP1 with audio direction rx_monitored

Scenario: 7. Op2 establishes an IA call to Op1
Meta:
@TEST_STEP_ACTION: Op2 establishes an IA call to Op1
@TEST_STEP_REACTION: Op1 has 2 half-duplex IA calls
@TEST_STEP_REF: [CATS-REF: SOKX]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1

Scenario: 7.1 Op1 verifies that it has a new IA call from Op2
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
Then HMI OP1 click on call queue Elements list
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: 7.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 1 calls

Scenario: 7.3 Verify call direction
Then HMI OP1 click on call queue Elements list
Then HMI OP1 has the IA call queue item Caller3-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction tx_monitored

Scenario: 8. IA external call is terminated
Meta:
@TEST_STEP_ACTION: IA external call is terminated
@TEST_STEP_REACTION: Op1 has 1 call in the queue
@TEST_STEP_REF: [CATS-REF: bNNh]
When VoIP SipContact2 gets terminated
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 7.3 Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction tx_monitored

Scenario: 9. Op2 terminates IA call
Meta:
@TEST_STEP_ACTION: Op2 terminates IA call
@TEST_STEP_REACTION: Op1 has 0 calls in the queue
@TEST_STEP_REF: [CATS-REF: FVWg]
When HMI OP2 presses IA key IA - OP1
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact1 is removed
When SipContact2 is removed

Scenario: Cleanup - always select first tab
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1