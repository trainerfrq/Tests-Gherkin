Narrative:
As an operator monitoring the KPIs of Phone-Routing-Service
I want to stop and start other services
So I can verify that the KPIs are modified according to my actions

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Zabbix setup
Given Zabbix client group ZABBIX:
| key  | user            | apiUrl         | password            |
| test | <<ZABBIX_USER>> | <<ZABBIX_URL>> | <<ZABBIX_PASSWORD>> |

Scenario: Interrogate Zabbix for phone-routing-service instance 1
When Zabbix ZABBIX.test requests items:
| host                             |
| <<PHONE_ROUTING_1_NAME_ZABBIX>>  | :=> phoneRouting_1_items

Scenario: Interrogate Zabbix for phone-routing-service instance 2
When Zabbix ZABBIX.test requests items:
| host                         |
| <<PHONE_ROUTING_2_NAME_ZABBIX>>  | :=> phoneRouting_2_items

Scenario: Get items of active phone-routing-service instance
Then get items of active instance amongst ${phoneRouting_1_items} and ${phoneRouting_2_items} :=> active_phoneRouting_items
Then get phone-routing KPIs values from zabbix host ${active_phoneRouting_items} :=> items_values

Scenario: Check status change reason
Then evaluate ${items_values}["Lifecycle status change reason"] contains "active"

Scenario: Check Registered Contacts
Then verify that ${items_values}["Number of currently registered contacts"] has the expected value 23

Scenario: Check Registered Users
Then verify that ${items_values}["Number of currently registered users"] has the expected value 16

Scenario: Check Service's operational Status
Then verify that ${items_values}["Service operationalStatus"] has the expected value 0

Scenario: Check the details of Service's operational Status
Then verify that ${items_values}["Service operational status in details"] has the expected value "OK"

Scenario: Check Service's SIP signalling interface
Then verify that ${items_values}["SIP signalling interface operational status"] has the expected value 0

Scenario: Check the details of Service's SIP signalling interface
Then verify that ${items_values}["SIP signalling interface operational status in details"] has the expected value "VIP OK, PHY OK"

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity                                                                  | sip-uri                                                                                           |
| SipContact | VOIP    | ThiIsASipContactWhichWillNotBeRegisteredCorrectlyDueToTheLenghtOfTheAddress  | sip:ThiIsASipContactWhichWillNotBeRegisteredCorrectlyDueToTheLenghtOfTheAddress@invalidSipURI.com |
And phones for SipContact are created

Scenario: Stop all running op-voice-services and Wait for Zabbix update
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost1.story,
			  voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
Then waiting for 120 seconds

Scenario: Interrogate Zabbix for data
When Zabbix ZABBIX.test requests items:
| hostids                                        |
| #{${active_phoneRouting_items}.get(0).hostid}  | :=> active_phoneRouting_items_update1

Scenario: Get KPI values
Then get phone-routing KPIs values from zabbix host ${active_phoneRouting_items_update1} :=> items_values_update

Scenario: Check new value of Currently registered contacts
Then verify that new Integer(${items_values_update}["Number of currently registered contacts"]) has the expected value 0

Scenario: Check new value of Currently registered users
Then verify that new Integer(${items_values_update}["Number of currently registered users"]) has the expected value 0

Scenario: Compare accepted registrations counters
Then verify that ${items_values_update}["Counter of accepted registrations"] is greater or equal to ${items_values}["Counter of accepted registrations"]

Scenario: Compare expired registrations counters
Then verify that ${items_values_update}["Counter of expired registrations"] is greater than ${items_values}["Counter of expired registrations"]

Scenario: Compare rejected registrations counters
Then verify that ${items_values_update}["Counter of rejected registrations"] is greater than ${items_values}["Counter of rejected registrations"]

Scenario: Remove phone
When SipContact is removed

Scenario: Restart both OP-Voice-Service instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost1.story,
			  voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds

