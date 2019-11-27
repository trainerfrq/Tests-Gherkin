Meta:
@TEST_CASE_VERSION: V5
@TEST_CASE_NAME: MaximumOutgoingCalls
@TEST_CASE_DESCRIPTION: As an operator having 16 incoming external calls I want to answer calls, do recalls from call history, do role calls, do conference call So I can verify that the operator can't have more then 1 active call
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: 
@TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 16 external calls
@TEST_CASE_ID: PVCSX-TC-11666
@TEST_CASE_GLOBAL_ID: GID-5114234
@TEST_CASE_API_ID: 17094569

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key      | profile | user-entity | sip-uri   |
| Caller1  | VOIP    | 1           | <<SIP1>>  |
| Caller2  | VOIP    | 2           | <<SIP2>>  |
| Caller3  | VOIP    | 3           | <<SIP3>>  |
| Caller4  | VOIP    | 4           | <<SIP4>>  |
| Caller5  | VOIP    | 5           | <<SIP5>>  |
| Caller6  | VOIP    | 6           | <<SIP6>>  |
| Caller7  | VOIP    | 7           | <<SIP7>>  |
| Caller8  | VOIP    | 8           | <<SIP8>>  |
| Caller9  | VOIP    | 9           | <<SIP9>>  |
| Caller10 | VOIP    | 10          | <<SIP10>> |
| Caller11 | VOIP    | 11          | <<SIP11>> |
| Caller12 | VOIP    | 12          | <<SIP12>> |
| Caller13 | VOIP    | 13          | <<SIP13>> |
| Caller14 | VOIP    | 14          | <<SIP14>> |
| Caller15 | VOIP    | 15          | <<SIP15>> |
| Caller16 | VOIP    | 16          | <<SIP16>> |

Given phones for SipContact are created

Scenario: 1. Op1 clears Call History list
Meta:
@TEST_STEP_ACTION: Op1 clears Call History list
@TEST_STEP_REACTION: Op1 has 0 entries in the Call History list
@TEST_STEP_REF: [CATS-REF: NPk2]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 clears Call History list
Then HMI OP1 verifies that call history list contains 0 entries

Scenario: 1.1 Op1 closes Call History window
Then HMI OP1 closes Call History popup window

Scenario: 2. Have 16 external calls that call Op1
Meta:
@TEST_STEP_ACTION: Have 16 external calls that call Op1
@TEST_STEP_REACTION: Op1 has 16 incoming calls
@TEST_STEP_REF: [CATS-REF: birS]
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 2.1 Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: 3. Op1 answers all 16 calls
Meta:
@TEST_STEP_ACTION: Op1 answers all 16 calls
@TEST_STEP_REACTION: Only 1 active call is visible, all the time
@TEST_STEP_REF: [CATS-REF: Mq6q]
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 3.1 Op1 terminates the active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: 4. Op1 opens Call History list and verifies the number of calls in the list
Meta:
@TEST_STEP_ACTION: Op1 opens Call History list and verifies the number of calls in the list
@TEST_STEP_REACTION: There are 16 calls in the Call history list
@TEST_STEP_REF: [CATS-REF: ieiW]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 verifies that call history list contains 16 entries

Scenario: 5. Op1 does a recall for 16 calls in the Call History
Meta:
@TEST_STEP_ACTION: Op1 does a recall for 16 calls in the Call History
@TEST_STEP_REACTION: Only 1 active call is visible, all the time
@TEST_STEP_REF: [CATS-REF: zMN9]
When HMI OP1 selects call history list entry number: 0

Scenario: 5.1 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.2 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 selects call history list entry number: 1

Scenario: 5.3 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.4 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 selects call history list entry number: 3

Scenario: 5.5 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.6 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 selects call history list entry number: 5

Scenario: 5.7 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.8 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 1 time(s)
When HMI OP1 selects call history list entry number: 1

Scenario: 5.9 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.10 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 1 time(s)
When HMI OP1 selects call history list entry number: 3

Scenario: 5.11 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.12 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 1 time(s)
When HMI OP1 selects call history list entry number: 5

Scenario: 5.13 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.14 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 2 time(s)
When HMI OP1 selects call history list entry number: 1

Scenario: 5.15 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.16 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 2 time(s)
When HMI OP1 selects call history list entry number: 3

Scenario: 5.17 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.18 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 2 time(s)
When HMI OP1 selects call history list entry number: 5

Scenario: 5.19 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.20 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 3 time(s)
When HMI OP1 selects call history list entry number: 1

Scenario: 5.21 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.22 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 3 time(s)
When HMI OP1 selects call history list entry number: 3

Scenario: 5.23 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.24 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 3 time(s)
When HMI OP1 selects call history list entry number: 5

Scenario: 5.25 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.26 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 4 time(s)
When HMI OP1 selects call history list entry number: 3

Scenario: 5.27 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.28 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 4 time(s)
When HMI OP1 selects call history list entry number: 5

Scenario: 5.29 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 5.30 Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 5 time(s)
When HMI OP1 selects call history list entry number: 4

Scenario: 5.31 Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 6. While having 1 active call, Op1 receives a role call
Meta:
@TEST_STEP_ACTION: While having 1 active call, Op1 receives a role call
@TEST_STEP_REACTION: Op1 has 1 active call and 1 waiting call
@TEST_STEP_REF: [CATS-REF: XkKP]
When HMI OP2 presses DA key ROLE1-ALIAS(as ROLE2)
Then HMI OP2 has the DA key ROLE1-ALIAS(as ROLE2) in state out_ringing

Scenario: 6.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 1 calls

Scenario: 7. Op1 answers role call
Meta:
@TEST_STEP_ACTION: Op1 answers role call
@TEST_STEP_REACTION: Op1 has 1 active call
@TEST_STEP_REF: [CATS-REF: cGA9]
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: 7.1 Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: 8. Op1 opens Call History list and verifies the number of calls in the list
Meta:
@TEST_STEP_ACTION: Op1 opens Call History list and verifies the number of calls in the list
@TEST_STEP_REACTION: There are 32 calls in the Call history list
@TEST_STEP_REF: [CATS-REF: WNVB]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 verifies that call history list contains 33 entries

Scenario: 8.1 Op1 closes call history
Then HMI OP1 closes Call History popup window

Scenario: 9. Op1 calls another role
Meta:
@TEST_STEP_ACTION: Op1 calls another role
@TEST_STEP_REACTION: Active call is ended automatically and Op1 has 1 outgoing call 
@TEST_STEP_REF: [CATS-REF: l0bm]
When HMI OP1 presses DA key ROLE2

Scenario: 9.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: 10. Op2 answers role call
Meta:
@TEST_STEP_ACTION: Op2 answers role call
@TEST_STEP_REACTION: Op1 has 1 active call
@TEST_STEP_REF: [CATS-REF: WuJY]
When HMI OP2 presses DA key ROLE1

Scenario: 10.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls

Scenario: 11. Op1 starts a conference using the existing active call
Meta:
@TEST_STEP_ACTION: Op1 starts a conference using the existing active call
@TEST_STEP_REACTION: Op1 has 1 active call
@TEST_STEP_REF: [CATS-REF: o0Em]
When HMI OP1 starts a conference using an existing active call

Scenario: 11.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: 12. Op3 calls Op1
Meta:
@TEST_STEP_ACTION: Op3 calls Op1
@TEST_STEP_REACTION: Op1 has 1 active call and 1 incoming call
@TEST_STEP_REF: [CATS-REF: Ctah]
When HMI OP3 presses DA key OP1

Scenario: 12.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 1 calls

Scenario: 13. Op1 answers Op3 call
Meta:
@TEST_STEP_ACTION: Op1 answers Op3 call
@TEST_STEP_REACTION: Op1 has 1 active call
@TEST_STEP_REF: [CATS-REF: WWfU]
When HMI OP1 presses DA key OP3

Scenario: 13.1 Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: 14. Op1 terminates call
Meta:
@TEST_STEP_ACTION: Op1 terminates call
@TEST_STEP_REACTION: Op1, Op2 and Op3 have no calls in the call queue
@TEST_STEP_REF: [CATS-REF: tzkf]
When HMI OP1 presses DA key OP3

Scenario: 14.1 Verify call queue for all operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 15. Op1 opens Call History list and verifies the number of calls in the list
Meta:
@TEST_STEP_ACTION: Op1 opens Call History list and verifies the number of calls in the list
@TEST_STEP_REACTION: There are 35 calls in the Call history list
@TEST_STEP_REF: [CATS-REF: owNE]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 verifies that call history list contains 37 entries

Scenario: 15.1 Op1 closes call history
Then HMI OP1 closes Call History popup window

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueueCapacityTests.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond


