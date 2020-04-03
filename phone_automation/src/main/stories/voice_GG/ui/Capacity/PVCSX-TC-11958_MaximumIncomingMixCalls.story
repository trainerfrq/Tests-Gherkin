Meta: @TEST_CASE_VERSION: V5
@TEST_CASE_NAME: MaximumIncomingMixCalls
@TEST_CASE_DESCRIPTION: As an operator having 16 incoming external calls (DA, IA, Position Monitoring calls) I want to verify that all calls are received and take into account the audio resources limitation
@TEST_CASE_PRECONDITION: System is configured to allow the maximum number of calls (16).
System is configured to allow maximum audio resources (16). Op2 active mission has a role configured with maximum allowed number of incoming position monitoring calls, incoming IA calls and incoming DA calls.
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when audio resources limitation is take into account and calls are visible on the operator position, but not 16 calls at once, because one IA call allocates 2 audio resources.
@TEST_CASE_DEVICES_IN_USE: Op2, CATS tool is used to simulate 16 external calls
@TEST_CASE_ID: PVCSX-TC-11958
@TEST_CASE_GLOBAL_ID: GID-5165662
@TEST_CASE_API_ID: 17778245

Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host           | identifier |
| javafx              | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx              | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create endpoint configuration
Given the SIP header configuration named SipConfigIACall:
| context | header-name   | header-value                                                              |
| *       | Subject       | IA call                                                                   |
| *       | Allow         | INVITE, ACK, BYE, CANCEL, INFO, UPDATE, REFER, NOTIFY, SUBSCRIBE, OPTIONS |
| *       | Max-Forwards  | 70                                                                        |
| *       | WG67-Version  | phone.01                                                                  |
| *       | WG67-Version  | phone.add03.02                                                            |
| *       | WG67-CallType | phone.add03.02;ia call                                                    |
| INVITE  | Priority      | urgent                                                                    |

Given named MEP configuration:
| key      | auto-answer | capabilities | named-sip-config |
| IACall-1 | TRUE        | PCMA         | SipConfigIACall  |

Scenario: Create sip phone
Given SipContacts group SipContact1:
| key     | profile | user-entity | sip-uri  |
| Caller1 | VOIP    | 1           | <<SIP1>> |
| Caller2 | VOIP    | 2           | <<SIP2>> |
| Caller3 | VOIP    | 3           | <<SIP3>> |
And phones for SipContact1 are created applying configuration IACall-1

Scenario: Create endpoint configuration
Given the SIP header configuration named SipConfigMonitoring:
| context | header-name   | header-value                                                              |
| *       | Subject       | monitoring                                                                |
| *       | Allow         | INVITE, ACK, BYE, CANCEL, INFO, UPDATE, REFER, NOTIFY, SUBSCRIBE, OPTIONS |
| *       | Max-Forwards  | 70                                                                        |
| *       | WG67-Version  | phone.01                                                                  |
| *       | WG67-Version  | phone.02                                                                  |
| *       | WG67-CallType | phone.02;monitoring                                                       |
| INVITE  | Priority      | non-urgent                                                                |

Given named MEP configuration:
| key              | auto-answer | capabilities | named-sip-config    |
| MonitoringCall-1 | TRUE        | PCMA         | SipConfigMonitoring |

Scenario: Create sip phone
Given SipContacts group SipContact2:
| key     | profile | user-entity | sip-uri  |
| Caller4 | VOIP    | 4           | <<SIP4>> |
| Caller5 | VOIP    | 5           | <<SIP5>> |
| Caller6 | VOIP    | 6           | <<SIP6>> |
| Caller7 | VOIP    | 7           | <<SIP7>> |
| Caller8 | VOIP    | 8           | <<SIP8>> |
And phones for SipContact2 are created applying configuration MonitoringCall-1

Scenario: Create endpoint configuration
Given the SIP header configuration named SipConfigDACall:
| context | header-name   | header-value                                                              |
| *       | Subject       | DA/IDA call                                                               |
| *       | Allow         | INVITE, ACK, BYE, CANCEL, INFO, UPDATE, REFER, NOTIFY, SUBSCRIBE, OPTIONS |
| *       | Max-Forwards  | 70                                                                        |
| *       | WG67-Version  | phone.01                                                                  |
| *       | WG67-Version  | phone.02                                                                  |
| *       | WG67-CallType | phone.02;da/ida call                                                      |
| INVITE  | Priority      | non-urgent                                                                |

Given named MEP configuration:
| key      | auto-answer | capabilities | named-sip-config |
| DACall-1 | TRUE        | PCMA         | SipConfigDACall  |

Scenario: Create sip phone
Given SipContacts group SipContact3:
| key      | profile | user-entity | sip-uri   |
| Caller9  | VOIP    | 9           | <<SIP9>>  |
| Caller10 | VOIP    | 10          | <<SIP10>> |
| Caller11 | VOIP    | 11          | <<SIP11>> |
| Caller12 | VOIP    | 12          | <<SIP12>> |
| Caller13 | VOIP    | 13          | <<SIP13>> |
| Caller14 | VOIP    | 14          | <<SIP14>> |
| Caller15 | VOIP    | 15          | <<SIP15>> |
| Caller16 | VOIP    | 16          | <<SIP16>> |
And phones for SipContact3 are created applying configuration DACall-1

Scenario: Define call queue items
Given the call queue items:
| key                    | source    | target                 | callType   |
| Caller1-OP1-IA         | <<SIP1>>  | <<OPVOICE2_PHONE_URI>> | IA         |
| Caller2-OP1-IA         | <<SIP2>>  | <<OPVOICE2_PHONE_URI>> | IA         |
| Caller3-OP1-IA         | <<SIP3>>  | <<OPVOICE2_PHONE_URI>> | IA         |
| Caller4-OP1-MONITORING | <<SIP4>>  | <<OPVOICE2_PHONE_URI>> | MONITORING |
| Caller5-OP1-MONITORING | <<SIP5>>  | <<OPVOICE2_PHONE_URI>> | MONITORING |
| Caller6-OP1-MONITORING | <<SIP6>>  | <<OPVOICE2_PHONE_URI>> | MONITORING |
| Caller7-OP1-MONITORING | <<SIP7>>  | <<OPVOICE2_PHONE_URI>> | MONITORING |
| Caller8-OP1-MONITORING | <<SIP8>>  | <<OPVOICE2_PHONE_URI>> | MONITORING |
| Caller9-OP1-DA         | <<SIP9>>  | <<OPVOICE2_PHONE_URI>> | DA/IDA     |
| Caller10-OP1-DA        | <<SIP10>> | <<OPVOICE2_PHONE_URI>> | DA/IDA     |
| Caller11-OP1-DA        | <<SIP11>> | <<OPVOICE2_PHONE_URI>> | DA/IDA     |
| Caller12-OP1-DA        | <<SIP12>> | <<OPVOICE2_PHONE_URI>> | DA/IDA     |
| Caller13-OP1-DA        | <<SIP13>> | <<OPVOICE2_PHONE_URI>> | DA/IDA     |
| Caller14-OP1-DA        | <<SIP14>> | <<OPVOICE2_PHONE_URI>> | DA/IDA     |
| Caller15-OP1-DA        | <<SIP15>> | <<OPVOICE2_PHONE_URI>> | DA/IDA     |
| Caller16-OP1-DA        | <<SIP16>> | <<OPVOICE2_PHONE_URI>> | DA/IDA     |

Scenario: Change mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_4_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS 4 section mission the assigned mission <<MISSION_4_NAME>>

Scenario: 1. Have 16 external calls that call Op2. Calls are done in this order: 8 DA incoming calls, 5 incoming position monitoring calls, 3 IA incoming calls
Meta: @TEST_STEP_ACTION: Have 16 external calls that call Op2. Calls are done in this order: 8 DA incoming calls, 5 incoming position monitoring calls, 3 IA incoming calls
@TEST_STEP_REACTION: Op2 receives: 8 DA incoming calls, 5 incoming position monitoring calls, 2 IA incoming calls
@TEST_STEP_REF: [CATS-REF: nXNB]
When SipContact3 calls SIP URI <<OPVOICE2_PHONE_URI>>
When SipContact2 calls SIP URI <<OPVOICE2_PHONE_URI>>
When SipContact1 calls SIP URI <<OPVOICE2_PHONE_URI>>
Then waiting for 5 seconds

Scenario: 1.1 Op2 verifies the number of incoming calls in the queue
Then HMI OP2 has in the collapsed monitoring area a number of 5 calls
Then HMI OP2 has in the waiting list a number of 2 calls
Then HMI OP2 has in the collapsed waiting area a number of 6 calls
Then HMI OP2 has in the collapsed active area a number of 1 calls
Then HMI OP2 has in the active list a number of 1 calls

Scenario: 2. Op2 verfies the state of the calls that are in the call queue
Meta: @TEST_STEP_ACTION: Op2 verfies the state of the calls that are in the call queue
@TEST_STEP_REACTION: DA incoming calls state is initiated, Position monitoring calls state is tx_monitored, IA calls state is rx (half-duplex)
@TEST_STEP_REF: [CATS-REF: ynyB]
Then HMI OP2 click on call queue Elements of monitoring list
Then HMI OP2 has the call queue item Caller4-OP1-MONITORING in state tx_monitored
Then HMI OP2 has the call queue item Caller5-OP1-MONITORING in state tx_monitored
Then HMI OP2 has the call queue item Caller6-OP1-MONITORING in state tx_monitored
Then HMI OP2 has the call queue item Caller7-OP1-MONITORING in state tx_monitored
Then HMI OP2 has the call queue item Caller8-OP1-MONITORING in state tx_monitored

Scenario: 2.1 Op2 verfies the state of the DA incoming calls
Then HMI OP2 click on call queue Elements of waiting list
Then HMI OP2 has the call queue item Caller9-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller10-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller11-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller12-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller13-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller14-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller15-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller16-OP1-DA in state inc_initiated

Scenario: 3. Op2 terminates all calls
Meta: @TEST_STEP_ACTION: Op2 terminates all calls
@TEST_STEP_REACTION: Op2 has 0 calls in the call queue
@TEST_STEP_REF: [CATS-REF: 0WPd]
When VoIP SipContact2 gets terminated

Scenario: 3.1 Incoming IA calls are terminated
When VoIP SipContact1 gets terminated

Scenario: 3.2 Op2 answers and terminates 8 incoming DA calls
Then HMI OP2 answers and terminates a number of 8 calls
Then wait for 2 seconds
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 4. Have 16 external calls that call Op2. Calls are done in this order: 8 DA incoming calls, 3 IA incoming calls, 5 incoming position monitoring calls.

Meta: @TEST_STEP_ACTION: Have 16 external calls that call Op2. Calls are done in this order: 8 DA incoming calls, 3 IA incoming calls, 5 incoming position monitoring calls.
@TEST_STEP_REACTION: Op2 receives: 8 DA incoming calls, 3 IA incoming calls, 2 incoming position monitoring calls
@TEST_STEP_REF: [CATS-REF: VUKH]
When SipContact3 calls SIP URI <<OPVOICE2_PHONE_URI>>
When SipContact1 calls SIP URI <<OPVOICE2_PHONE_URI>>
When SipContact2 calls SIP URI <<OPVOICE2_PHONE_URI>>
Then waiting for 5 seconds

Scenario: 4.1 Op2 verifies the number of incoming calls in the queue
Then HMI OP2 has in the waiting list a number of 2 calls
Then HMI OP2 has in the collapsed waiting area a number of 6 calls
Then HMI OP2 has in the collapsed active area a number of 2 calls
Then HMI OP2 has in the active list a number of 1 calls
Then HMI OP2 has in the collapsed monitoring area a number of 2 calls

Scenario: 5. Op2 verfies the state of the calls that are in the call queue
Meta: @TEST_STEP_ACTION: Op2 verfies the state of the calls that are in the call queue
@TEST_STEP_REACTION: DA incoming calls state is initiated, Position monitoring calls state is tx_monitored, IA calls state is rx (half-duplex)
@TEST_STEP_REF: [CATS-REF: NpSW]
Then HMI OP2 click on call queue Elements of active list
Then HMI OP2 has the IA call queue item Caller1-OP1-IA with audio direction rx
Then HMI OP2 has the IA call queue item Caller2-OP1-IA with audio direction rx
Then HMI OP2 has the IA call queue item Caller3-OP1-IA with audio direction rx

Scenario: 5.1 Op2 verfies the state of the DA incoming calls
Then HMI OP2 click on call queue Elements of waiting list
Then HMI OP2 has the call queue item Caller9-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller10-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller11-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller12-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller13-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller14-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller15-OP1-DA in state inc_initiated
Then HMI OP2 has the call queue item Caller16-OP1-DA in state inc_initiated

Scenario: 6. Op2 terminates all calls
Meta: @TEST_STEP_ACTION: Op2 terminates all calls
@TEST_STEP_REACTION: Op2 has 0 calls in the call queue
@TEST_STEP_REF: [CATS-REF: X66C]
When VoIP SipContact2 gets terminated

Scenario: 6.1 Incoming IA calls are terminated
When VoIP SipContact1 gets terminated

Scenario: 6.2 Op2 answers and terminates 8 incoming DA calls
Then HMI OP2 answers and terminates a number of 8 calls
Then wait for 2 seconds
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 7. Have 16 external calls that call Op2. Calls are done in this order:3 IA incoming calls, 5 incoming position monitoring calls,  8 DA incoming calls.

Meta: @TEST_STEP_ACTION: Have 16 external calls that call Op2. Calls are done in this order:3 IA incoming calls, 5 incoming position monitoring calls,  8 DA incoming calls.
@TEST_STEP_REACTION: Op2 receives: 3 IA incoming calls, 5 incoming position monitoring calls, 6 DA incoming calls.
@TEST_STEP_REF: [CATS-REF: 26Lc]
When SipContact1 calls SIP URI <<OPVOICE2_PHONE_URI>>
When SipContact2 calls SIP URI <<OPVOICE2_PHONE_URI>>
When SipContact3 calls SIP URI <<OPVOICE2_PHONE_URI>>
Then waiting for 5 seconds

Scenario: 7.1 Op2 verifies the number of incoming calls in the queue
Then HMI OP2 has in the waiting list a number of 2 calls
Then HMI OP2 has in the collapsed waiting area a number of 3 calls
Then HMI OP2 has in the collapsed active area a number of 2 calls
Then HMI OP2 has in the active list a number of 1 calls
Then HMI OP2 has in the collapsed monitoring area a number of 5 calls

Scenario: 8. Op2 verfies the state of the calls that are in the call queue
Meta: @TEST_STEP_ACTION: Op2 verfies the state of the calls that are in the call queue
@TEST_STEP_REACTION: DA incoming calls state is initiated, Position monitoring calls state is tx_monitored, IA calls state is rx (half-duplex)
@TEST_STEP_REF: [CATS-REF: NthL]
Then HMI OP2 click on call queue Elements of active list
Then HMI OP2 has the IA call queue item Caller1-OP1-IA with audio direction rx
Then HMI OP2 has the IA call queue item Caller2-OP1-IA with audio direction rx
Then HMI OP2 has the IA call queue item Caller3-OP1-IA with audio direction rx

Scenario: 8.1 Op2 verfies the state of the position monitoring incoming calls
Then HMI OP2 click on call queue Elements of monitoring list
Then HMI OP2 has the call queue item Caller4-OP1-MONITORING in state tx_monitored
Then HMI OP2 has the call queue item Caller5-OP1-MONITORING in state tx_monitored
Then HMI OP2 has the call queue item Caller6-OP1-MONITORING in state tx_monitored
Then HMI OP2 has the call queue item Caller7-OP1-MONITORING in state tx_monitored
Then HMI OP2 has the call queue item Caller8-OP1-MONITORING in state tx_monitored

Scenario: Autogenerated Scenario 9
Meta: @TEST_STEP_ACTION: Op2 terminates all calls
@TEST_STEP_REACTION: Op2 has 0 calls in the call queue
@TEST_STEP_REF: [CATS-REF: vmtu]
When VoIP SipContact2 gets terminated

Scenario: 9.1 Incoming IA calls are terminated
When VoIP SipContact1 gets terminated

Scenario: 9.2 Op2 answers and terminates 5 incoming DA calls
Then HMI OP2 answers and terminates a number of 5 calls
Then wait for 2 seconds
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Change mission
When HMI OP2 with layout <<LAYOUT_MISSION4>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP2 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_2_NAME>>

Scenario: Remove phone
When SipContact1 is removed

Scenario: Remove phone
When SipContact2 is removed

Scenario: Remove phone
When SipContact3 is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
