Meta: @TEST_CASE_VERSION: V5
@TEST_CASE_NAME: MaximumIncomingIACalls
@TEST_CASE_DESCRIPTION: As an operator having 3 incoming IA calls and another operator attempts to do an IA call to my position I want to verify that the operator will not be able to do an IA call to  my position only after one of the IA call is terminated
@TEST_CASE_PRECONDITION: Op1 active mission has a role configured with maximum allowed number of incoming IA calls
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when all 3 IA calls are visible on the operator position and no other IA call can be made to that position, until one of the existing IA calls is terminated
@TEST_CASE_DEVICES_IN_USE:Op1, Op2, CATS tool is used to simulate 3 external IA calls
@TEST_CASE_ID: PVCSX-TC-11891
@TEST_CASE_GLOBAL_ID: GID-5154895
@TEST_CASE_API_ID: 17696536

Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host           | identifier |
| javafx              | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx              | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx              | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create endpoint configuration
Given the SIP header configuration named SipConfig:
| context | header-name   | header-value                                                              |
| *       | Subject       | IA call                                                                   |
| *       | Allow         | INVITE, ACK, BYE, CANCEL, INFO, UPDATE, REFER, NOTIFY, SUBSCRIBE, OPTIONS |
| *       | Max-Forwards  | 70                                                                        |
| *       | WG67-Version  | phone.01                                                                  |
| *       | WG67-Version  | phone.add03.02                                                            |
| *       | WG67-CallType | phone.add03.02;ia call                                                    |
| INVITE  | Priority      | urgent                                                                    |

Given named MEP configuration:
| key      | capabilities | named-sip-config |
| IACall-1 | PCMA         | SipConfig        |

Scenario: Create sip phones
Given SipContacts group SipContact1:
| key     | profile | user-entity | sip-uri  |
| Caller1 | VOIP    | 1           | <<SIP1>> |
| Caller2 | VOIP    | 2           | <<SIP2>> |
And phones for SipContact1 are created applying configuration IACall-1

Given SipContacts group SipContact2:
| key     | profile | user-entity | sip-uri  |
| Caller3 | VOIP    | 3           | <<SIP3>> |
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
Meta: @TEST_STEP_ACTION: Have 3 external IA calls that call Op1
@TEST_STEP_REACTION: Op1 has 3 half-duplex IA calls
@TEST_STEP_REF: [CATS-REF: Aa3M]
When SipContact1 calls SIP URI <<OPVOICE1_PHONE_URI>>
When SipContact2 calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 1.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 2 calls

Scenario: 1.2 Verify call direction
Then HMI OP1 click on call queue Elements of active list
Then HMI OP1 has the IA call queue item Caller1-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item Caller2-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item Caller3-OP1 with audio direction rx_monitored

Scenario: 2. Op2 attempts to do an IA call to Op1
Meta: @TEST_STEP_ACTION: Op2 attempts to do an IA call to Op1
@TEST_STEP_REACTION: Op2 attempt to call fails
@TEST_STEP_REF: [CATS-REF: WMeR]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1

Scenario: 2.1 Op2 has a failed call in the call queue
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the IA key IA - OP1 in state out_failed

Scenario: 2.2 Op2 terminates failed call
When HMI OP2 presses IA key IA - OP1

Scenario: 3. One external IA call is terminated
Meta: @TEST_STEP_ACTION: One external IA call is terminated
@TEST_STEP_REACTION: Op1 has 2 half-duplex IA calls
@TEST_STEP_REF: [CATS-REF: quGx]
When VoIP SipContact2 gets terminated

Scenario: 3.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 1 calls

Scenario: 4. Op2 establishes an IA call to Op1
Meta: @TEST_STEP_ACTION: Op2 establishes an IA call to Op1
@TEST_STEP_REACTION: Op1 has 3 half-duplex IA calls and one call is from Op2
@TEST_STEP_REF: [CATS-REF: 4BrG]
When HMI OP2 presses IA key IA - OP1
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: 4.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 2 calls

Scenario: 5. Op1 answers the IA call
Meta: @TEST_STEP_ACTION: Op1 answers the IA call
@TEST_STEP_REACTION: Op1 and Op2 have an IA duplex call. Op1 has 2 half-duplex IA calls
@TEST_STEP_REF: [CATS-REF: ACZu]
When HMI OP1 presses IA key IA - OP2

Scenario: 5.1 Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction duplex
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction duplex

Scenario: 5.2 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 2 calls

Scenario: 6. Op1 terminates IA call
Meta: @TEST_STEP_ACTION: Op1 terminates IA call
@TEST_STEP_REACTION: IA call changes from a full duplex to a half duplex call
@TEST_STEP_REF: [CATS-REF: wj0J]
When HMI OP1 presses IA key IA - OP2

Scenario: 6.1 Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction tx_monitored

Scenario: 7. Op2 terminates IA call
Meta: @TEST_STEP_ACTION: Op2 terminates IA call
@TEST_STEP_REACTION: IA call is terminated
@TEST_STEP_REF: [CATS-REF: W4kj]
When HMI OP2 presses IA key IA - OP1

Scenario: 7.1 Call is terminated also for both operators
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 1 calls

Scenario: 8. All external IA calls are terminated
Meta: @TEST_STEP_ACTION: All external IA calls are terminated
@TEST_STEP_REACTION: Op1 has 0 calls in the queue
@TEST_STEP_REF: [CATS-REF: cIJ6]
When VoIP SipContact1 gets terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact1 is removed
When SipContact2 is removed

Scenario: Cleanup - always select first tab
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done