Meta:
@TEST_CASE_VERSION: V5
@TEST_CASE_NAME: Call Intrusion - Impeding Intrusion Call and Priority Call
@TEST_CASE_DESCRIPTION:
As an operator having an impeding Intrusion Call
I want to receive a Priority Call
So I can verify that the incoming priority call is not conferenced to the existing call
@TEST_CASE_PRECONDITION:
Role1 configured with the following:
- Maximum Number of Incoming Pending Calls: 3
- Call Intrusion allowed: Yes
- On call release during Intrusion warning period: Immediate auto-accept of pending Priority Call
- Call Intrusion warning period (sec): 10
OP1 has an active mission which has Role1 assigned
Phonebook_entry available
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, when incoming Priority Call does not intrude the active G/G Call, neither impeding Intrusion Call.
@TEST_CASE_DEVICES_IN_USE:
OP1:
OP2:
OP3:
Phonebook_entry:
@TEST_CASE_ID: PVCSX-TC-15649
@TEST_CASE_GLOBAL_ID: GID-5638757
@TEST_CASE_API_ID: 20057888

Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host           | identifier |
| javafx              | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx              | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx              | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key            | source         | target                 | callType |
| OP1-OP2        | <<OP1_URI>>    | <<OP2_URI>>            | DA/IDA   |
| OP2-OP1        | <<OP2_URI>>    | <<OP1_URI>>            | DA/IDA   |
| OP1-OP3        | <<OP1_URI>>    | <<OP3_URI>>            | DA/IDA   |
| OP3-OP1        | <<OP3_URI>>    | <<OP1_URI>>            | DA/IDA   |
| SipContact-OP1 | <<SIP_PHONE2>> | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

Scenario: OP1 changes its mission to GND
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 1. Phonebook_entry: Set up an active DA call to OP1
Meta:
@TEST_STEP_ACTION: Phonebook_entry: Set up an active DA call to OP1
@TEST_STEP_REACTION: OP1: Active DA call with Phonebook_entry
@TEST_STEP_REF: [CATS-REF: xdxG]
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: 1.1 Verify calls state for OP1
Then HMI OP1 has the call queue item SipContact-OP1 in state inc_initiated

Scenario: 1.2 OP2 answers the incoming call
Then HMI OP1 accepts the call queue item SipContact-OP1

Scenario: 1.3 Verify calls state for OP1
Then HMI OP1 has the call queue item SipContact-OP1 in state connected
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: 2. OP3: Establish a priority call to OP1
Meta:
@TEST_STEP_ACTION: OP3: Establish a priority call to OP1
@TEST_STEP_REACTION: OP3: Outgoing priority call to OP1 indicated
@TEST_STEP_REF: [CATS-REF: ppqK]
When HMI OP3 initiates a priority call on DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: 2.1 OP1 receives the incoming priority call
Then HMI OP1 has the DA key OP3(as GND) in state inc_ringing
Then HMI OP1 has in the call queue the item OP3-OP1 with priority

Scenario: 2.2 Verify call queue section
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>
Then HMI OP3 has the call queue item OP1-OP3 in the active list with name label <<OP1_NAME>>

Scenario: 3. OP1: Verify Notification Display
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: "Call Intrusion In Progress..." notification in Notification Bar
@TEST_STEP_REF: [CATS-REF: xt6S]
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains on position 0 text Call Intrusion In Progress ...

Scenario: 3.1 Close popup window
Then HMI OP1 closes notification popup

Scenario: 4. OP1: Verify Call Intrusion Timeout bar
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Timeout bar displayed on call queue item from OP3
@TEST_STEP_REF: [CATS-REF: eQDz]
Then HMI OP1 verifies that intrusion Timeout bar is visible on call queue item OP3-OP1
Then HMI OP1 verifies that intrusion Timeout bar is visible on DA Key OP3(as GND)

Scenario: 5. OP2: Establish a priority call to OP1
Meta:
@TEST_STEP_ACTION: OP2: Establish a priority call to OP1
@TEST_STEP_REACTION: OP2: Outgoing priority call to OP1 indicated
@TEST_STEP_REF: [CATS-REF: uaUp]
When HMI OP2 initiates a priority call on DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: 5.1 OP1 receives the incoming priority call
Then HMI OP1 has the DA key OP2(as GND) in state inc_initiated
Then HMI OP1 has in the call queue the item OP2-OP1 with priority

Scenario: 5.2 Verify call queue section
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with name label <<OP2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>

Scenario: 6. OP1: Verify Notification Display
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: "Call Intrusion In Progress..." notification in Notification Bar
@TEST_STEP_REF: [CATS-REF: U2k5]
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains on position 0 text Call Intrusion In Progress ...

Scenario: 6.1 Close popup window
Then HMI OP1 closes notification popup

Scenario: 7. OP1: Verify Call Intrusion Timeout bar
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Timeout bar not displayed on call queue item from OP2
@TEST_STEP_REF: [CATS-REF: uSbT]
Then HMI OP1 verifies that intrusion Timeout bar is not visible on call queue item OP2-OP1
Then HMI OP1 verifies that intrusion Timeout bar is not visible on DA Key OP2(as GND)

Scenario: 8. OP1: Wait until Warning Period expires
Meta:
@TEST_STEP_ACTION: OP1: Wait until Warning Period expires
@TEST_STEP_REACTION: OP1: Active DA call with Phonebook_entry
@TEST_STEP_REF: [CATS-REF: JxxM]
When waiting for 3 seconds
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 1 calls
Then HMI OP1 click on call queue Elements of active list
Then HMI OP1 has the call queue item SipContact-OP1 in state connected

Scenario: 8.1 Verify OP2 call queue list
Then HMI OP2 has the call queue item OP1-OP2 in state out_ringing

Scenario: 8.2 Verify OP3 call queue list
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP3 has in the call queue the item OP1-OP3 with priority

Scenario: 9. OP1: Active Priority call with OP3
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Active Priority call with OP3
@TEST_STEP_REF: [CATS-REF: iwg1]
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>

Scenario: 10. OP1: Waiting Priority call with OP2
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Waiting Priority call with OP2
@TEST_STEP_REF: [CATS-REF: q4u3]
Then HMI OP1 has the call queue item OP2-OP1 in state inc_initiated
Then HMI OP1 has in the call queue the item OP2-OP1 with priority
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with name label <<OP2_NAME>>

Scenario: 11. OP1: Verify Notification Display
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: "Call Intrusion In Progress ..." message in Notification Bar
@TEST_STEP_REF: [CATS-REF: xsC6]
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains on position 0 text Call Intrusion In Progress ...

Scenario: 11.1 Close popup window
Then HMI OP1 closes notification popup

Scenario: 12. Phonebook_entry: Terminate call with OP1
Meta:
@TEST_STEP_ACTION: Phonebook_entry: Terminate call with OP1
@TEST_STEP_REACTION: OP1: Active Priority call with OP3
@TEST_STEP_REF: [CATS-REF: njPL]
When SipContact terminates calls
Then HMI OP1 has in the call queue a number of 2 calls

Scenario: 12.1 Verify OP1 still has an active priority call with OP3
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>

Scenario: 13. OP1: Waiting Priority call with OP2
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Waiting Priority call with OP2
@TEST_STEP_REF: [CATS-REF: tyrT]
Then HMI OP1 has the call queue item OP2-OP1 in state inc_initiated
Then HMI OP1 has in the call queue the item OP2-OP1 with priority
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with name label <<OP2_NAME>>

Scenario: 14. OP2: Terminate call with OP1
Meta:
@TEST_STEP_ACTION: OP2: Terminate call with OP1
@TEST_STEP_REACTION: OP2: No calls in queue
@TEST_STEP_REF: [CATS-REF: 8rBu]
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 15. OP1: No call in queue with OP2
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: No call in queue with OP2
@TEST_STEP_REF: [CATS-REF: 1IbN]
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: 16. OP1: Active priority call with OP3
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Active priority call with OP3
@TEST_STEP_REF: [CATS-REF: PK3W]
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has in the call queue the item OP3-OP1 with priority

Scenario: 17. OP3: Terminate call with OP1
Meta:
@TEST_STEP_ACTION: OP3: Terminate call with OP1
@TEST_STEP_REACTION: OP1: No calls in queue
@TEST_STEP_REF: [CATS-REF: Olqc]
When HMI OP3 presses DA key OP1
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 18. OP3: No calls in queue
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP3: No calls in queue
@TEST_STEP_REF: [CATS-REF: l064]
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Remove phone
When SipContact is removed

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done