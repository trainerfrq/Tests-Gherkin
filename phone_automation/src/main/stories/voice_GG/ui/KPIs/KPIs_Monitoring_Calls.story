Narrative:
As an operator monitoring the KPIs
I want to establish and receive Monitoring calls
So I can verify that the KPIs are modified according to my actions

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Op1 changes mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_TWR_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Op2 changes mission
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: Op3 changes mission
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_SUP-TWR_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Zabbix setup
Given Zabbix client group ZABBIX:
| key  | user            | apiUrl         | password            |
| test | <<ZABBIX_USER>> | <<ZABBIX_URL>> | <<ZABBIX_PASSWORD>> |

Scenario: Interrogate Zabbix for op-voice-service2 instance 1
When Zabbix ZABBIX.test requests items:
| host                         |
| <<OPVOICE_2-1_NAME_ZABBIX>>  | :=> opVoice_2_1_items

Scenario: Interrogate Zabbix for op-voice-service2 instance 2
When Zabbix ZABBIX.test requests items:
| host                         |
| <<OPVOICE_2-2_NAME_ZABBIX>>  | :=> opVoice_2_2_items

Scenario: Get items of active op-voice-service instance
Then get items of active instance amongst ${opVoice_2_1_items} and ${opVoice_2_2_items} :=> active_opVoice_items
Then get opVoice Monitoring Calls KPIs values from zabbix host ${active_opVoice_items} :=> items_values

Scenario: Verifying number of active outgoing Monitoring calls
Then verify that ${items_values}["Number of active outgoing Monitoring Calls"] has the expected value 0

Scenario: Verifying number of active outgoing Monitoring calls
Then verify that ${items_values}["Number of active incoming Monitoring Calls"] has the expected value 0

Scenario: OP2 tries to Monitor APP
When HMI OP2 with layout <<LAYOUT_GND>> presses function key MONITORING
When HMI OP2 presses DA key APP(as GND)
Then HMI OP2 has the DA key APP(as GND) in state out_failed

Scenario: OP2 chooses to Monitor TWR
When HMI OP2 presses DA key TWR(as GND)
Then HMI OP2 has the DA key TWR(as GND) with visible state monitoringActiveState

Scenario: OP2 chooses to Monitor SUP-TWR
When HMI OP2 presses DA key SUP-TWR(as GND)
Then HMI OP2 has the DA key SUP-TWR(as GND) with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
Then HMI OP2 with layout <<LAYOUT_GND>> has the function key MONITORING in monitoringOnGoing state
When HMI OP2 with layout <<LAYOUT_GND>> presses function key MONITORING
Then HMI OP2 with layout <<LAYOUT_GND>> has the function key MONITORING in monitoringActive state

Scenario: Waiting for Zabbix to Update data
Then waiting for 60 seconds

Scenario: Interrogate Zabbix for data
When Zabbix ZABBIX.test requests items:
| hostids                            |
| #{${active_opVoice_items}.get(0).hostid}  | :=> active_opVoice_items_update1

Scenario: Get KPI values
Then get opVoice Monitoring Calls KPIs values from zabbix host ${active_opVoice_items_update1} :=> items_values_update1

Scenario: Verifying number of active outgoing Monitoring calls
Then verify that ${items_values_update1}["Number of active outgoing Monitoring Calls"] has the expected value 2

Scenario: Verifying number of active outgoing Monitoring calls
Then verify that ${items_values_update1}["Number of active incoming Monitoring Calls"] has the expected value 0

Scenario: Verifying KPIs counters value
Then verify that ${items_values_update1}["Number of attempted outgoing Monitoring Calls"] is greater than ${items_values}["Number of attempted outgoing Monitoring Calls"]
Then verify that ${items_values_update1}["Number of accepted incoming Monitoring Calls"] is equal to ${items_values}["Number of accepted incoming Monitoring Calls"]

Scenario: OP1 chooses to Monitor GND
When HMI OP1 with layout <<LAYOUT_TWR>> presses function key MONITORING
When HMI OP1 presses DA key GND(as TWR)
Then HMI OP1 has the DA key GND(as TWR) with visible state monitoringActiveState
When HMI OP1 with layout <<LAYOUT_TWR>> presses function key MONITORING

Scenario: OP3 chooses to Monitor GND
When HMI OP3 with layout <<LAYOUT_SUP-TWR>> presses function key MONITORING
When HMI OP3 presses DA key GND(as SUP-TWR)
Then HMI OP3 has the DA key GND(as SUP-TWR) with visible state monitoringActiveState
When HMI OP3 with layout <<LAYOUT_SUP-TWR>> presses function key MONITORING

Scenario: Waiting for Zabbix to Update data
Then waiting for 60 seconds

Scenario: Interrogate Zabbix for data
When Zabbix ZABBIX.test requests items:
| hostids                            |
| #{${active_opVoice_items}.get(0).hostid}  | :=> active_opVoice_items_update2

Scenario: Get KPI values
Then get opVoice Monitoring Calls KPIs values from zabbix host ${active_opVoice_items_update2} :=> items_values_update2

Scenario: Verifying number of active outgoing Monitoring calls
Then verify that ${items_values_update2}["Number of active outgoing Monitoring Calls"] has the expected value 2

Scenario: Verifying number of active outgoing Monitoring calls
Then verify that ${items_values_update2}["Number of active incoming Monitoring Calls"] has the expected value 2

Scenario: Verifying KPIs counters value
Then verify that ${items_values_update2}["Number of attempted outgoing Monitoring Calls"] is equal to ${items_values_update1}["Number of attempted outgoing Monitoring Calls"]
Then verify that ${items_values_update2}["Number of accepted incoming Monitoring Calls"] is greater than ${items_values_update1}["Number of accepted incoming Monitoring Calls"]

Scenario: OP1 clears the Monitoring call
When HMI OP1 with layout <<LAYOUT_TWR>> presses function key MONITORING
When HMI OP1 presses DA key GND(as TWR)
When HMI OP1 with layout <<LAYOUT_TWR>> presses function key MONITORING

Scenario: OP3 clears the Monitoring call
When HMI OP3 with layout <<LAYOUT_SUP-TWR>> presses function key MONITORING
When HMI OP3 presses DA key GND(as SUP-TWR)
When HMI OP3 with layout <<LAYOUT_TWR>> presses function key MONITORING

Scenario: OP2 clears the Monitoring calls
When HMI OP2 with layout <<LAYOUT_GND>> presses function key MONITORING
When HMI OP2 presses DA key TWR(as GND)
When HMI OP2 presses DA key SUP-TWR(as GND)
When HMI OP2 with layout <<LAYOUT_GND>> presses function key MONITORING

Scenario: OP1 changes mission back
When HMI OP1 with layout <<LAYOUT_TWR>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: OP2 changes mission back
When HMI OP2 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then waiting for 5 seconds

Scenario: OP3 changes mission back
When HMI OP3 with layout <<LAYOUT_SUP-TWR>> presses function key MISSIONS
Then HMI OP3 changes current mission to mission <<MISSION_3_NAME>>
Then HMI OP3 activates mission
Then waiting for 5 seconds

Scenario: Clean-up: Wait for KPIs update after missions change
Then waiting for 60 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story,
			  voice_GG/ui/includes/@CleanupMonitoringCalls.story
Then waiting until the cleanup is done
