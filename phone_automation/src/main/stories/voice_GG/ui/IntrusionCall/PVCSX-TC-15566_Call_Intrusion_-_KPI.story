Meta:
@TEST_CASE_VERSION: V9
@TEST_CASE_NAME: Call Intrusion - KPI
@TEST_CASE_DESCRIPTION:
As an operator having an active call
I want to receive an incoming intrusion Priority call
So I can very that Intrusion's related KPIs are modified according to the actions, after intrusion takes place
@TEST_CASE_PRECONDITION:
Role1 configured with the following:
- Maximum Number of Incoming Pending Calls: 2
- Call Intrusion allowed: Yes
- On call release during Intrusion warning period: Immediate auto-accept of pending Priority Call
- Call Intrusion warning period (sec): 10
OP1 has an active mission which has Role1 assigned
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, when a Priority Call intrudes a G/G Call and the related KPIs are modified according to the actions
@TEST_CASE_DEVICES_IN_USE:
OP1:
OP2:
OP3:
Zabbix:
@TEST_CASE_ID: PVCSX-TC-15566
@TEST_CASE_GLOBAL_ID: GID-5563872
@TEST_CASE_API_ID: 19738222

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |

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

Scenario: 1. Zabbix: Open main page
Meta:
@TEST_STEP_ACTION: Zabbix: Open main page
@TEST_STEP_REACTION: Zabbix: Main page is open
@TEST_STEP_REF: [CATS-REF: ZnlG]
Given Zabbix client group ZABBIX:
| key  | user            | apiUrl         | password            |
| test | <<ZABBIX_USER>> | <<ZABBIX_URL>> | <<ZABBIX_PASSWORD>> |

Scenario: Interrogate Zabbix for op-voice-service instance 1
When Zabbix ZABBIX.test requests items:
| host                             |
| <<OPVOICE_1-1_NAME_ZABBIX>>  | :=> opVoice_1_1_items

Scenario: Interrogate Zabbix for op-voice-service instance 2
When Zabbix ZABBIX.test requests items:
| host                         |
| <<OPVOICE_1-2_NAME_ZABBIX>>  | :=> opVoice_1_2_items

Scenario: 2. Zabbix: "Number of applied intrusions for incoming priority calls" KPI is displayed for Op-Voice-Service
Meta:
@TEST_STEP_ACTION: Zabbix: "Number of applied intrusions for incoming priority calls" KPI is displayed for Op-Voice-Service
@TEST_STEP_REACTION: Zabbix: "Number of applied intrusions for incoming priority calls" is displayed
@TEST_STEP_REF: [CATS-REF: mu1T]
Then get items of active instance amongst ${opVoice_1_1_items} and ${opVoice_1_2_items} :=> active_opVoice_items

Scenario: 3. Zabbix: Save the value of "Number of applied intrusions for incoming priority calls"
Meta:
@TEST_STEP_ACTION: Zabbix: Inspect current value of "Number of applied intrusions for incoming priority calls"
@TEST_STEP_REACTION: Zabbix: "Number of applied intrusions for incoming priority calls" value is saved
@TEST_STEP_REF: [CATS-REF: m2lb]
Then get opVoice Phone KPIs values from zabbix host ${active_opVoice_items} :=> items_values

Scenario: 4. OP1: Set up an active DA call to OP2
Meta:
@TEST_STEP_ACTION: OP1: Set up an active DA call to OP2
@TEST_STEP_REACTION: OP1: Active DA call with OP2
@TEST_STEP_REF: [CATS-REF: zWBJ]
When HMI OP1 presses DA key OP2(as GND)
Then HMI OP1 has the DA key OP2(as GND) in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: 4.1 OP2 receives the incoming call
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: 4.2 OP2 answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: 4.3 Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 5. OP3: Establish a priority call to OP1
Meta:
@TEST_STEP_ACTION: OP3: Establish a priority call to OP1
@TEST_STEP_REACTION: OP3: Outgoing priority call to OP1 indicated
@TEST_STEP_REF: [CATS-REF: sDGz]
When HMI OP3 initiates a priority call on DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: 5.1 OP1 receives the incoming priority call
Then HMI OP1 has the DA key OP3(as GND) in state inc_ringing
Then HMI OP1 has in the call queue the item OP3-OP1 with priority

Scenario: 5.2 Verify call queue section
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>
Then HMI OP3 has the call queue item OP1-OP3 in the active list with name label <<OP1_NAME>>

Scenario: 6. Verify intrusion Timeout bar is displayed on call queue item
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Timeout bar displayed on call queue item from OP3
@TEST_STEP_REF: [CATS-REF: pxfC]
Then HMI OP1 verifies that intrusion Timeout bar is visible on call queue item OP3-OP1

Scenario: 7. OP1: Wait until Warning Period expires
Meta:
@TEST_STEP_ACTION: OP1: Wait until Warning Period expires
@TEST_STEP_REACTION: OP1: First active call in queue - DA call with OP2
@TEST_STEP_REF: [CATS-REF: zitC]
When waiting for 10 seconds
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 click on call queue Elements of active list
Then HMI OP1 has the call queue item OP2-OP1 in state connected

Scenario: 8. Verify OP1 call queue list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Second active call in queue - priority call with OP3
@TEST_STEP_REF: [CATS-REF: nbtk]
Then HMI OP1 verifies that intrusion Timeout bar is not visible on call queue item OP3-OP1
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>

Scenario: 9. Verify OP2 call queue list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP2: Active DA call with OP1
@TEST_STEP_REF: [CATS-REF: FxPI]
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 10. Verify OP3 call queue list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP3: Active priority call with OP1
@TEST_STEP_REF: [CATS-REF: uPtM]
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP3 has in the call queue the item OP1-OP3 with priority

Scenario: 11. Wait for Zabbix update (around 60 seconds)
Meta:
@TEST_STEP_ACTION: Wait for Zabbix update (around 60 seconds)
@TEST_STEP_REACTION: Zabbix is refreshed with updated values
@TEST_STEP_REF: [CATS-REF: r7R1]
When waiting for 60 seconds

Scenario: 11.1 Interrogate Zabbix for data
When Zabbix ZABBIX.test requests items:
| hostids                                   |
| #{${active_opVoice_items}.get(0).hostid}  | :=> active_opVoice_items_update1

Scenario: 11.2 Get KPI values
Then get opVoice Phone KPIs values from zabbix host ${active_opVoice_items_update1} :=> items_values_update

Scenario: 12. Zabbix: Verify "Number of applied intrusions for incoming priority calls" KPI's value
Meta:
@TEST_STEP_ACTION: Zabbix: Verify "Number of applied intrusions for incoming priority calls" KPI's value
@TEST_STEP_REACTION: Zabbix: "Number of applied intrusions for incoming priority calls" new value is greater than previously saved value by 1
@TEST_STEP_REF: [CATS-REF: zTQq]
Then verify that ${items_values_update}["Number of applied intrusions for incoming priority calls"] is greater than ${items_values}["Number of applied intrusions for incoming priority calls"]

Scenario: 13. OP2: Terminate call with OP1
Meta:
@TEST_STEP_ACTION: OP2: Terminate call with OP1
@TEST_STEP_REACTION: OP2: No calls in queue
@TEST_STEP_REF: [CATS-REF: OQ7x]
When HMI OP1 presses DA key OP2(as GND)
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 14. Verify OP1 has no call with OP2
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: No call in queue with OP2
@TEST_STEP_REF: [CATS-REF: zpRD]
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item OP3-OP1 in state connected

Scenario: 15. Verify OP1 has an active priority call with OP3
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1: Active priority call with OP3
@TEST_STEP_REF: [CATS-REF: lu9g]
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the active list with name label <<OP3_NAME>>

Scenario: 16. OP1: Terminate call with OP3
Meta:
@TEST_STEP_ACTION: OP1: Terminate call with OP3
@TEST_STEP_REACTION: OP1: No calls in queue
@TEST_STEP_REF: [CATS-REF: IOvk]
When HMI OP1 presses DA key OP3(as GND)
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 17. Verify OP3 call queue list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP3: No calls in queue
@TEST_STEP_REF: [CATS-REF: AmLS]
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Cleanup - OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
