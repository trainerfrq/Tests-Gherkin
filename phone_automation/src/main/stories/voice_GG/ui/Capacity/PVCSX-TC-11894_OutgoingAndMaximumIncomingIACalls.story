Meta: @TEST_CASE_VERSION: V4
	  @TEST_CASE_NAME: OutgoingAndMaximumIncomingIACalls
	  @TEST_CASE_DESCRIPTION: As an operator having and outgoing IA call I want to verify that I can receive 3 incoming IA calls
	  @TEST_CASE_PRECONDITION: The test is passed when all 3 IA calls are visible on the operator position and the outgoing call is still connected
	  @TEST_CASE_PASS_FAIL_CRITERIA:
	  @TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 3 external IA calls
	  @TEST_CASE_ID: PVCSX-TC-11894
	  @TEST_CASE_GLOBAL_ID: GID-5155642
	  @TEST_CASE_API_ID: 17704058

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

Scenario: 1. Op1 establishes an IA call to Op2
Meta: @TEST_STEP_ACTION: Op1 establishes an IA call to Op2
@TEST_STEP_REACTION: Op1 and Op2 have a half-duplex IA call connected
@TEST_STEP_REF: [CATS-REF: NSXW]
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 1.1 Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction tx
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction rx

Scenario: 2. Have 3 external IA calls that call Op1
Meta: @TEST_STEP_ACTION: Have 3 external IA calls that call Op1
@TEST_STEP_REACTION: Op1 has 3 incoming half-duplex IA calls connected and and outgoing IA call
@TEST_STEP_REF: [CATS-REF: qeaY]
When SipContact1 calls SIP URI <<OPVOICE1_PHONE_URI>>
When SipContact2 calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 2.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 3 calls

Scenario: 2.2 Verify call direction
Then HMI OP1 click on call queue Elements of active list
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction tx
Then HMI OP1 has the IA call queue item Caller1-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item Caller2-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item Caller3-OP1 with audio direction rx_monitored

Scenario: 3. Op3 attempts to do an IA call to Op1
Meta: @TEST_STEP_ACTION: Op3 attempts to do an IA call to Op1
@TEST_STEP_REACTION: Op3 attempt to call fails
@TEST_STEP_REF: [CATS-REF: kFJQ]
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 2
When HMI OP3 presses IA key IA - OP1

Scenario: 3.1 Op3 has a failed call in the call queue
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has the IA key IA - OP1 in state out_failed

Scenario: 3.2 Op3 terminates failed call
When HMI OP3 presses IA key IA - OP1

Scenario: 4. Op2 changes half-duplex IA call to Op1 to full-duplex
Meta: @TEST_STEP_ACTION: Op2 changes half-duplex IA call to Op1 to full-duplex
@TEST_STEP_REACTION: Op1 and Op2 have a full-duplex IA call connected. Op1 has 3 incoming half-duplex IA calls
@TEST_STEP_REF: [CATS-REF: vIkV]
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1

Scenario: 4.1 Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction duplex
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction duplex
Then HMI OP1 has the IA call queue item Caller1-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item Caller2-OP1 with audio direction rx_monitored
Then HMI OP1 has the IA call queue item Caller3-OP1 with audio direction rx_monitored

Scenario: 5. One external IA call is terminated
Meta: @TEST_STEP_ACTION: One external IA call is terminated
@TEST_STEP_REACTION: Op1 has 2 incoming half-duplex IA calls connected and and outgoing IA call
@TEST_STEP_REF: [CATS-REF: hYJv]
When VoIP SipContact2 gets terminated

Scenario: 5.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 2 calls

Scenario: 6. Op3 attempts to do an IA call to Op1
Meta: @TEST_STEP_ACTION: Op3 attempts to do an IA call to Op1
@TEST_STEP_REACTION: Op3 attempt to call fails
@TEST_STEP_REF: [CATS-REF: aprE]
When HMI OP3 presses IA key IA - OP1

Scenario: 6.1 Op3 has a failed call in the call queue
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has the IA key IA - OP1 in state out_failed

Scenario: 6.2 Op3 terminates failed call
When HMI OP3 presses IA key IA - OP1

Scenario: 7. All external IA calls are terminated
Meta: @TEST_STEP_ACTION: All external IA calls are terminated
@TEST_STEP_REACTION: Op1 has one full-duplex IA call
@TEST_STEP_REF: [CATS-REF: VwyE]
When VoIP SipContact1 gets terminated

Scenario: 7.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 7.2 Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction duplex
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction duplex

Scenario: 8. Op1 terminates IA call
Meta: @TEST_STEP_ACTION: Op1 terminates IA call
@TEST_STEP_REACTION: Op1 has one half-duplex IA call
@TEST_STEP_REF: [CATS-REF: p6KJ]
When HMI OP1 presses IA key IA - OP2

Scenario: 8.1 Verify call direction
Then HMI OP1 has the IA call queue item OP2-OP1 with audio direction rx_monitored
Then HMI OP2 has the IA call queue item OP1-OP2 with audio direction tx_monitored

Scenario: 9. Op2 terminates IA call
Meta: @TEST_STEP_ACTION: Op2 terminates IA call
@TEST_STEP_REACTION: Op1 has 1 call in the queue
@TEST_STEP_REF: [CATS-REF: daJD]
When HMI OP2 presses IA key IA - OP1
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact1 is removed
When SipContact2 is removed

Scenario: Cleanup - always select first tab
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
