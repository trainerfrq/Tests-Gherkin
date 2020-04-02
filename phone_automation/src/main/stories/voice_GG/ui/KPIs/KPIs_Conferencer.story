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

Scenario: Check status change reason
Then evaluate ${items_values}["Lifecycle status change reason"] contains "active"

Scenario: Check Configuration validity
Then evaluate ${items_values}["Configuration validity"] equals 0
Then evaluate ${items_values}["Configuration validity in details"] equals "OK"

Scenario: Check Service's operational Status
Then evaluate ${items_values}["Service operationalStatus"] equals 0
Then evaluate ${items_values}["Service operational status in details"] equals "OK"

Scenario: Check Service's SIP signalling interface
Then evaluate ${items_values}["SIP signalling interface operational status"] equals 0
Then evaluate ${items_values}["SIP signalling interface operational status in details"] equals "VIP OK"

