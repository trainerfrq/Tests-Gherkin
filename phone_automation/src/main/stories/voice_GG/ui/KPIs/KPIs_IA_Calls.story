Narrative:
As an operator monitoring the KPIs
I want to establish and receive IA calls
So I can verify that the KPIs are modified according to my actions

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | IA       |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | IA       |
| OP1-OP3 | <<OP1_URI>> | <<OP3_URI>> | IA       |
| OP3-OP1 | <<OP3_URI>> | <<OP1_URI>> | IA       |

Scenario: Zabbix setup
Given Zabbix client group ZABBIX:
| key  | user            | apiUrl         | password            |
| test | <<ZABBIX_USER>> | <<ZABBIX_URL>> | <<ZABBIX_PASSWORD>> |

Scenario: Interrogate Zabbix for op-voice-service1 instance 1
When Zabbix ZABBIX.test requests items:
| host                         |
| <<OPVOICE_1-1_NAME_ZABBIX>>  | :=> opVoice_1_1_items

Scenario: Interrogate Zabbix for op-voice-service1 instance 2
When Zabbix ZABBIX.test requests items:
| host                         |
| <<OPVOICE_1-2_NAME_ZABBIX>>  | :=> opVoice_1_2_items

Scenario: Get items of active op-voice-service instance
Then get items of active instance amongst ${opVoice_1_1_items} and ${opVoice_1_2_items} :=> active_opVoice_items
Then get opVoice IA Calls KPIs values from zabbix host ${active_opVoice_items} :=> items_values

Scenario: Check number of active outgoing IA Calls
Then verify that ${items_values}["Number of active outgoing IA Calls"] has the expected value 0
Scenario: Check number of active incoming IA Calls
Then verify that ${items_values}["Number of active incoming IA Calls"] has the expected value 0

Scenario: OP1 establishes an outgoing IA call to OP3
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP3
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has the IA key IA - OP3 in state connected

Scenario: OP1 establishes an outgoing IA call to OP2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: Waiting for Zabbix to Update data
Then waiting for 60 seconds

Scenario: Interrogate Zabbix for data
When Zabbix ZABBIX.test requests items:
| hostids                                   |
| #{${active_opVoice_items}.get(0).hostid}  | :=> active_opVoice_items_update1

Scenario: Get KPI values
Then get opVoice IA Calls KPIs values from zabbix host ${active_opVoice_items_update1} :=> items_values_update1

Scenario: Check number of active outgoing IA Calls
Then verify that ${items_values_update1}["Number of active outgoing IA Calls"] has the expected value 1

Scenario: Check number of active incoming IA Calls
Then verify that ${items_values_update1}["Number of active incoming IA Calls"] has the expected value 0

Scenario: Verifying KPIs counters values are incremented
Then verify that ${items_values_update1}["Number of outgoing IA Calls"] is greater than ${items_values}["Number of outgoing IA Calls"]
Then verify that ${items_values_update1}["Number of accepted incoming IA Calls"] is equal to ${items_values}["Number of accepted incoming IA Calls"]

Scenario: OP2 establishes an outgoing IA call to OP1, using the IA key
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected

Scenario: OP3 establishes an outgoing IA call to OP1, using the IA key
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 2
When HMI OP3 presses IA key IA - OP1
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP3 has the IA key IA - OP1 in state connected

Scenario: Waiting for Zabbix to Update data
Then waiting for 60 seconds

Scenario: Interrogate Zabbix for data
When Zabbix ZABBIX.test requests items:
| hostids                            |
| #{${active_opVoice_items}.get(0).hostid}  | :=> active_opVoice_items_update2

Scenario: Get KPI values
Then get opVoice IA Calls KPIs values from zabbix host ${active_opVoice_items_update2} :=> items_values_update2

Scenario: Check number of active outgoing IA Calls
Then verify that ${items_values_update2}["Number of active outgoing IA Calls"] has the expected value 1

Scenario: Check number of active incoming IA Calls
Then verify that ${items_values_update2}["Number of active incoming IA Calls"] has the expected value 2

Scenario: Verifying KPIs counters value
Then verify that ${items_values_update2}["Number of outgoing IA Calls"] is equal to ${items_values_update1}["Number of outgoing IA Calls"]
Then verify that ${items_values_update2}["Number of accepted incoming IA Calls"] is greater than ${items_values_update1}["Number of accepted incoming IA Calls"]

Scenario: Caller clears IA call
When HMI OP1 presses IA key IA - OP2

Scenario: OP2 clears IA call
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: OP3 clears IA call
When HMI OP3 presses IA key IA - OP1
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP3 with layout <<LAYOUT_MISSION3>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
