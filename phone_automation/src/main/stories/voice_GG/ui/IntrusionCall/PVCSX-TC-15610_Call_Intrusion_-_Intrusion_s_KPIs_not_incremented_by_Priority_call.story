Meta:
@TEST_CASE_VERSION: V3
@TEST_CASE_NAME: Call Intrusion - Intrusion's KPIs not incremented by Priority call
@TEST_CASE_DESCRIPTION: 
As an operator having an active call
I want to receive an incoming Priority call
So I can very that Intrusion's related KPIs are not modified by the Priority call
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: 
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-15610
@TEST_CASE_GLOBAL_ID: GID-5612017
@TEST_CASE_API_ID: 19996314

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
| OP3-OP1 | <<OP3_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Zabbix: Open main page
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

Scenario: Zabbix: "Number of applied intrusions for incoming priority calls" KPI is displayed for Op-Voice-Service
Then get items of active instance amongst ${opVoice_1_1_items} and ${opVoice_1_2_items} :=> active_opVoice_items

Scenario: Zabbix: Save the value of "Number of applied intrusions for incoming priority calls"
Then get opVoice Phone KPIs values from zabbix host ${active_opVoice_items} :=> items_values

Scenario: OP1: Set up an active DA call to OP2
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: OP2 receives the incoming call
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: OP2 answers the incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: OP3: Establish a priority call to OP1
When HMI OP3 initiates a priority call on DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: OP1 receives the incoming priority call
Then HMI OP1 has the DA key OP3 in state inc_initiated
Then HMI OP1 has in the call queue the item OP3-OP1 with priority

Scenario: Verify OP1's call queue section
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>

Scenario: Wait for Zabbix update (around 60 seconds)
When waiting for 60 seconds

Scenario: Interrogate Zabbix for data
When Zabbix ZABBIX.test requests items:
| hostids                                   |
| #{${active_opVoice_items}.get(0).hostid}  | :=> active_opVoice_items_update1

Scenario: Get KPI values
Then get opVoice Phone KPIs values from zabbix host ${active_opVoice_items_update1} :=> items_values_update

Scenario: Zabbix: Verify "Number of applied intrusions for incoming priority calls" KPI's value
Then verify that ${items_values_update}["Number of applied intrusions for incoming priority calls"] is equal to ${items_values}["Number of applied intrusions for incoming priority calls"]

Scenario: OP2: Terminate call with OP1
When HMI OP1 presses DA key OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Verify OP1 has no call with OP2
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item OP3-OP1 in state inc_initiated

Scenario: Verify OP1 has an active priority call with OP3
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with name label <<OP3_NAME>>

Scenario: OP3: Terminate call with OP1
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Verify OP1 call queue list
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
