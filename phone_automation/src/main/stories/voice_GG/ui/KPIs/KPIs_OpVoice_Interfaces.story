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

Scenario: SSH connections
Given SSH connections:
| name             | remote-address       | remotePort | username | password  |
| deployment       | <<DEP_SERVER_IP>>    | 22         | root     | !frqAdmin |
| hmiHost1         | <<CLIENT1_IP>>       | 22         | root     | !frqAdmin |
| audioBox1        | <<AUDIOBOX_1_IP>>    | 22         | root     | !frqAdmin |

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

Scenario: Get items of active phone-routing-service instance
Then get items of active instance amongst ${opVoice_1_1_items} and ${opVoice_1_2_items} :=> active_opVoice_items
Then get opVoice interfaces KPIs values from zabbix host ${active_opVoice_items} :=> items_values

Scenario: Check Audio Interface status KPI
Then evaluate ${items_values}["Association status of phone to audio app"] equals 0

Scenario: Check GUI Interface status KPI
Then evaluate ${items_values}["GUI connection status"] equals 0

Scenario: Check Mission Service Interface status KPI
Then evaluate ${items_values}["Connection status to the mission service"] equals 0

Scenario: Kill Mission Service instances
When SSH host deployment executes xvp services remove mission-service -g
!-- And waiting for 5 seconds

Scenario: OP1 tries to change its mission
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_TWR_NAME>>
Then HMI OP1 activates mission

Scenario: Check mission wasn't change
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>
And waiting for 15 seconds

Scenario: Remove voice-hmi-service on HMI1
When SSH host hmiHost1 executes docker kill $(docker ps -q -a -f name=${PARTITION_KEY_1})
And waiting for 5 seconds

Scenario: Kill audio-service from AudioBox1
When SSH host audioBox1 executes docker kill audio-app

Scenario: Wait for Zabbix update
When waiting for 90 seconds

Scenario: Interrogate Zabbix for data
When Zabbix ZABBIX.test requests items:
| hostids                                   |
| #{${active_opVoice_items}.get(0).hostid}  | :=> active_opVoice_items_update1

Scenario: Get KPI values
Then get opVoice interfaces KPIs values from zabbix host ${active_opVoice_items_update1} :=> items_values_update

Scenario: Check Audio Interface KPIs
Then evaluate ${items_values_update}["Association status of phone to audio app"] equals 1

Scenario: Check GUI Interface KPIs
Then evaluate ${items_values_update}["GUI connection status"] equals 1

Scenario: Check Mission Interface KPIs
Then evaluate ${items_values_update}["Connection status to the mission service"] equals 1

Scenario: Compare values of audioApp Association Status Changes
Then evaluate new Integer(${items_values_update}["Number of the association status changes to the audio app"]) > new Integer(${items_values}["Number of the association status changes to the audio app"])

Scenario: Compare values of connection Status Changes GUI/HMI
Then evaluate new Integer(${items_values_update}["Number of websocket connection association status change"]) > new Integer(${items_values}["Number of websocket connection association status change"])

Scenario: Compare values of connection Status Changes MissionService
Then evaluate new Integer(${items_values_update}["Number of the association status changes to the mission service"]) > new Integer(${items_values}["Number of the association status changes to the mission service"])

Scenario: Clean-up: start audio-service from AudioBox1
When SSH host audioBox1 executes docker start audio-app
And waiting for 1 seconds

Scenario: Clean-up start both Mission Service instances
When SSH host deployment executes xvp services deploy --force mission-service -g
And waiting for 1 seconds

Scenario: Clean-up: start voice-hmi-service on HMI1
When SSH host hmiHost1 executes docker start $(docker ps -q -a -f name=${PARTITION_KEY_1})
And waiting for 60 seconds

Scenario: Check mission was changed
Then HMI OP1 has in the DISPLAY STATUS TWR section mission the assigned mission <<MISSION_TWR_NAME>>

Scenario: Clean-ul: OP1 changes its mission back
When HMI OP1 with layout <<LAYOUT_TWR>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIMission.story
Then waiting until the cleanup is done



