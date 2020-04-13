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

Scenario: Zabbix setup
Given Zabbix client group ZABBIX:
| key  | user  | apiUrl                                     | password |
| test | Admin | http://10.31.205.106/zabbix/api_jsonrpc.php | zabbix   |

Scenario: Check discovery service
When Zabbix ZABBIX.test requests items:
| host                                                   |
| op-voice-service-cj-gg-cat-cwp-1-1.xvp.frequentis.frq  | :=> service_items0
Then host ${service_items0} contains Number of active outgoing IA Calls with value: 0

Scenario: Caller establishes an outgoing IA call
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 2
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP1 has the IA key IA - OP2 in state connected

Scenario: Callee receives incoming IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
Then HMI OP2 has the call queue item OP1-OP2 in state connected
Then HMI OP2 has the IA key IA - OP1 in state connected
And waiting for 60 seconds

Scenario: Check discovery service
When Zabbix ZABBIX.test requests items:
| host                                                   |
| op-voice-service-cj-gg-cat-cwp-1-1.xvp.frequentis.frq  | :=> service_items1
Then host ${service_items1} contains Number of active outgoing IA Calls with value: 1

Scenario: Clean up IA Call
When HMI OP1 presses IA key IA - OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Call is terminated also for callee
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Cleanup - always select first tab
When HMI OP1 with layout <<LAYOUT_MISSION1>> selects grid tab 1
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
