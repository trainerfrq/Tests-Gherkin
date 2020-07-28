Meta:
@TEST_CASE_VERSION: V1
@TEST_CASE_NAME: Call Intrusion - Impeding Intrusion Call and Priority Call
@TEST_CASE_DESCRIPTION: 
As an operator having an impeding Intrusion Call
I want to receive a priority call
So I can verify that the incoming priority call is not conferenced to the existing call
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: 
@TEST_CASE_DEVICES_IN_USE: 
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

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Verify calls state for OP1
Then HMI OP1 has the call queue item SipContact-OP1 in state inc_initiated

Scenario: OP2 answers the incoming call
Then HMI OP1 accepts the call queue item SipContact-OP1

Scenario: Verify calls state for OP1
Then HMI OP1 has the call queue item SipContact-OP1 in state connected
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: OP3: Establish a priority call to OP1
When HMI OP3 initiates a priority call on DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: OP1 receives the incoming priority call
Then HMI OP1 has the DA key OP3(as GND) in state inc_ringing
Then HMI OP1 has in the call queue the item OP3-OP1 with priority

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>
Then HMI OP3 has the call queue item OP1-OP3 in the active list with name label <<OP1_NAME>>

Scenario: Verify Notification Display
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains on position 0 text Call Intrusion In Progress ...

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Verify intrusion Timeout bar
Then HMI OP1 verifies that intrusion Timeout bar is visible on call queue item OP3-OP1
Then HMI OP1 verifies that intrusion Timeout bar is visible on DA Key OP3(as GND)

Scenario: OP2: Establish a priority call to OP1
When HMI OP2 initiates a priority call on DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: OP1 receives the incoming priority call
Then HMI OP1 has the DA key OP2(as GND) in state inc_initiated
Then HMI OP1 has in the call queue the item OP2-OP1 with priority

Scenario: Verify call queue section
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with name label <<OP2_NAME>>
Then HMI OP2 has the call queue item OP1-OP2 in the active list with name label <<OP1_NAME>>

Scenario: Verify Notification Display
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains on position 0 text Call Intrusion In Progress ...

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Verify intrusion Timeout bar
Then HMI OP1 verifies that intrusion Timeout bar is not visible on call queue item OP2-OP1
Then HMI OP1 verifies that intrusion Timeout bar is not visible on DA Key OP2(as GND)

Scenario: OP1: Wait until Warning Period expires
When waiting for 3 seconds
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 1 calls
Then HMI OP1 click on call queue Elements of active list
Then HMI OP1 has the call queue item SipContact-OP1 in state connected

Scenario: Verify intrusion Timeout bar
Then HMI OP1 verifies that intrusion Timeout bar is not visible on call queue item OP3-OP1
Then HMI OP1 verifies that intrusion Timeout bar is not visible on DA Key OP3(as GND)

Scenario: Verify OP1 call queue list
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>
Then HMI OP1 has the call queue item OP2-OP1 in state inc_initiated
Then HMI OP1 has in the call queue the item OP2-OP1 with priority
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with name label <<OP2_NAME>>

Scenario: Verify OP1 Notification Display
!-- TODO Adjust the scenario after PVCSX-5907 is resolved
!-- When HMI OP1 opens Notification Display list
!-- Then HMI OP1 verifies that Notification Display list State has 0 items

Scenario: Verify OP2 call queue list
Then HMI OP2 has the call queue item OP1-OP2 in state out_ringing

Scenario: Verify OP3 call queue list
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP3 has in the call queue the item OP1-OP3 with priority

Scenario: SipContact clears the phone call
When SipContact terminates calls
Then HMI OP1 has in the call queue a number of 2 calls

Scenario: Verify OP1 still has an active priority call with OP3
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>

Scenario: Verify OP1 still has a priority call with OP2
Then HMI OP1 has the call queue item OP2-OP1 in state inc_initiated
Then HMI OP1 has in the call queue the item OP2-OP1 with priority
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with name label <<OP2_NAME>>

Scenario: OP2: Terminate call with OP1
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Verify call is terminated also for OP1
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item OP3-OP1 in state connected

Scenario: OP3: Terminate call with OP1
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Verify call is terminated also for OP1
Then HMI OP1 has in the call queue a number of 0 calls

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
