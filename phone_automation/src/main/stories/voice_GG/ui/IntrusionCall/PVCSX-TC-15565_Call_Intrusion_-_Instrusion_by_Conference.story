Meta:
@TEST_CASE_VERSION: V11
@TEST_CASE_NAME: Call Intrusion - Instrusion by Conference
@TEST_CASE_DESCRIPTION:
As an operator having an active G/G call and Call Intrusion set to "Enabled"
I want to receive an incoming Priority call and wait until "Intrusion Warning Period" has expired
So I can verify that incoming Priority Call is conferenced to the existing call
@TEST_CASE_PRECONDITION:
Role1 configured with the following:
- Maximum Number of Incoming Pending Calls: 2
- Call Intrusion allowed: Yes
- On call release during Intrusion warning period: Immediate auto-accept of pending Priority Call
- Call Intrusion warning period (sec): 10
OP1 has an active mission which has Role1 assigned
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, when a Priority Call intrudes a G/G Call after the "Call Intrusion warning period" elapsed and the Priority Call is conferenced to the existing G/G Call.
@TEST_CASE_DEVICES_IN_USE:
OP1:
OP2:
OP3:
@TEST_CASE_ID: PVCSX-TC-15565
@TEST_CASE_GLOBAL_ID: GID-5563699
@TEST_CASE_API_ID: 19737269

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |
| OP1-OP3 | <<OP1_URI>> | <<OP3_URI>> | DA/IDA   |
| OP3-OP1 | <<OP3_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: OP1 changes its mission to GND
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 1. OP1: Set up an active DA call to OP2
Meta:
@TEST_STEP_ACTION: OP1: Set up an active DA call to OP2
@TEST_STEP_REACTION: OP1: Active DA call with OP2
@TEST_STEP_REF: [CATS-REF: 8pBY]
When HMI OP1 presses DA key OP2(as GND)
Then HMI OP1 has the DA key OP2(as GND) in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: 1.1 OP2 receives the incoming call
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: 1.2 OP2 answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: 1.3 Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 2. OP3: Establish a priority call to OP1
Meta:
@TEST_STEP_ACTION: OP3: Establish a priority call to OP1
@TEST_STEP_REACTION: OP3: Outgoing priority call to OP1 indicated
@TEST_STEP_REF: [CATS-REF: 6uEB]
When HMI OP3 initiates a priority call on DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: 2.1 OP1 receives the incoming priority call
Then HMI OP1 has the DA key OP3(as GND) in state inc_ringing
Then HMI OP1 has in the call queue the item OP3-OP1 with priority

Scenario: 2.2 Verify call queue section
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>
Then HMI OP3 has the call queue item OP1-OP3 in the active list with name label <<OP1_NAME>>

Scenario: 3. Verify Notification Display
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: "Call Intrusion In Progress..." notification in Notification Bar
@TEST_STEP_REF: [CATS-REF: VBBP]
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains on position 0 text Call Intrusion In Progress ...

Scenario: 3.1 Close popup window
Then HMI OP1 closes notification popup

Scenario: 4. Verify intrusion Timeout bar
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Timeout bar displayed on call queue item from OP3
@TEST_STEP_REF: [CATS-REF: wWjv]
Then HMI OP1 verifies that intrusion Timeout bar is visible on call queue item OP3-OP1

Scenario: 5. OP1: Wait until Warning Period expires
Meta:
@TEST_STEP_ACTION: OP1: Wait until Warning Period expires
@TEST_STEP_REACTION: OP1: First active call in queue - DA call with OP2
@TEST_STEP_REF: [CATS-REF: IDzo]
When waiting for 10 seconds
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 1 calls
Then HMI OP1 click on call queue Elements of active list
Then HMI OP1 has the call queue item OP2-OP1 in state connected

Scenario: 6. Verify OP1 call queue list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Second active call in queue - priority call with OP3
@TEST_STEP_REF: [CATS-REF: zhY3]
Then HMI OP1 verifies that intrusion Timeout bar is not visible on call queue item OP3-OP1
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>

Scenario: 7. Verify OP1 Notification Display
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: No message in Notification Bar
@TEST_STEP_REF: [CATS-REF: ErM2]
!-- TODO Adjust the scenario after PVCSX-5907 is resolved
!-- When HMI OP1 opens Notification Display list
!-- Then HMI OP1 verifies that Notification Display list State has 0 items

Scenario: 8. Verify OP2 call queue list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP2: Active DA call with OP1
@TEST_STEP_REF: [CATS-REF: Js8B]
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 9. Verify OP3 call queue list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP3: Active priority call with OP1
@TEST_STEP_REF: [CATS-REF: P85n]
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP3 has in the call queue the item OP1-OP3 with priority

Scenario: 10. OP2: Terminate call with OP1
Meta:
@TEST_STEP_ACTION: OP2: Terminate call with OP1
@TEST_STEP_REACTION: OP2: No calls in queue
@TEST_STEP_REF: [CATS-REF: C6FV]
When HMI OP1 presses DA key OP2(as GND)
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 11. Verify call is terminated also for OP1
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: No call in queue with OP2
@TEST_STEP_REF: [CATS-REF: bk4h]
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: 12. Verify OP1 still has an active priority call with OP3
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Active priority call with OP3
@TEST_STEP_REF: [CATS-REF: 8yaL]
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>

Scenario: 13. OP1: Terminate call with OP3
Meta:
@TEST_STEP_ACTION: OP1: Terminate call with OP3
@TEST_STEP_REACTION: OP1: No calls in queue
@TEST_STEP_REF: [CATS-REF: bS1P]
When HMI OP1 presses DA key OP3(as GND)
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 14. Verify call is terminated also for OP1
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP3: No calls in queue
@TEST_STEP_REF: [CATS-REF: 8M4V]
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 15. OP3: Establish priority call to OP1
Meta:
@TEST_STEP_ACTION: OP3: Establish priority call to OP1
@TEST_STEP_REACTION: OP3: Outgoing Priority call to OP1 indicated
@TEST_STEP_REF: [CATS-REF: pL1A]
When HMI OP3 initiates a priority call on DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing
Then HMI OP3 has the call queue item OP1-OP3 in the active list with name label <<OP1_NAME>>

Scenario: 16. OP1: Receive the priority call
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Priority call from OP3
@TEST_STEP_REF: [CATS-REF: p1OV]
Then HMI OP1 has the DA key OP3(as GND) in state inc_initiated
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>

Scenario: 17. OP1: No call Intrusion Indication
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: No call Intrusion Indication
@TEST_STEP_REF: [CATS-REF: v0ca]
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that Notification Display list State has 0 items

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: 18. OP1: No Timeout bar displayed on call queue item from OP3
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: No Timeout bar displayed on call queue item from OP3
@TEST_STEP_REF: [CATS-REF: kk1T]
Then HMI OP1 verifies that intrusion Timeout bar is not visible on call queue item OP3-OP1

Scenario: 19. OP3: Terminate call with OP1
Meta:
@TEST_STEP_ACTION: OP3: Terminate call with OP1
@TEST_STEP_REACTION: OP3: No calls in queue
@TEST_STEP_REF: [CATS-REF: L3rB]
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 20. Verify call is terminated also for OP1
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: No calls in queue
@TEST_STEP_REF: [CATS-REF: y1qZ]
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done