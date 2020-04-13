Narrative:
As an operator monitoring the KPIs of Conferencer-Service
I want to interrogate data from Zabbix
So I can verify that the KPIs have the desired values

Scenario: Zabbix setup
Given Zabbix client group ZABBIX:
| key  | user            | apiUrl         | password            |
| test | <<ZABBIX_USER>> | <<ZABBIX_URL>> | <<ZABBIX_PASSWORD>> |

Scenario: Interrogate Zabbix for conferencer-service instance 1
When Zabbix ZABBIX.test requests items:
| host                          |
| <<CONFERENCER_1_NAME_ZABBIX>>  | :=> conferencer_1_items

Scenario: Interrogate Zabbix for conferencer-service instance 2
When Zabbix ZABBIX.test requests items:
| host                          |
| <<CONFERENCER_2_NAME_ZABBIX>>  | :=> conferencer_2_items

Scenario: Get items of active conferencer-service instance
Then get items of active instance amongst ${conferencer_1_items} and ${conferencer_2_items} :=> active_conferencer_items
Then get Conferencer KPIs values from zabbix host ${active_conferencer_items} :=> items_values

Scenario: Verify that status change reason indicates an active instance
Then evaluate ${items_values}["Lifecycle status change reason"] contains "active"

Scenario: Verify that service has a Valid Configuration
Then verify that ${items_values}["Configuration validity"] has the expected value 0
Then verify that ${items_values}["Configuration validity in details"] has the expected value "OK"

Scenario: Verify that Service operates in normal conditions
Then verify that ${items_values}["Service operationalStatus"] has the expected value 0
Then verify that ${items_values}["Service operational status in details"] has the expected value "OK"

Scenario: Verify that Service's SIP signalling interface operates in normal conditions
Then verify that ${items_values}["SIP signalling interface operational status"] has the expected value 0
Then verify that ${items_values}["SIP signalling interface operational status in details"] has the expected value "VIP OK"

