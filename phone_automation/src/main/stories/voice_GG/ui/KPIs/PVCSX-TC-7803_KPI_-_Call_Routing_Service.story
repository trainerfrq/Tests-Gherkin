Meta:
@TEST_CASE_VERSION: V6
@TEST_CASE_NAME: KPI - Call Routing Service
@TEST_CASE_DESCRIPTION: 
As an operator monitoring the KPIs of Call-Routing-Service
I want to stop and start other services
So I can verify that the KPIs are modified according to my actions
@TEST_CASE_PRECONDITION: 
- Call Routing Service available with registered Users and Contacts
- Monitoring Tool available
@TEST_CASE_PASS_FAIL_CRITERIA: 
This test is passed, when the Call Routing Service provides the following KPI's:
- Number of currently registered Users
- Number of currently registered Contacts
- Counter of time expired registrations
- Counter of accepted registrations
- Counter of rejected registrations
@TEST_CASE_DEVICES_IN_USE: 
Call Routing Service
Op Voice Service
Monitoring Tool (Zabbix)
@TEST_CASE_ID: PVCSX-TC-7803
@TEST_CASE_GLOBAL_ID: GID-4628889
@TEST_CASE_API_ID: 15010040

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

Scenario: 1. Verify Call Routing Service KPIs are displayed
Meta:
@TEST_STEP_ACTION: Monitoring Tool: Verify that the following KPI's are displayed for the Call Routing Service - - Number of currently registered Users, Number of currently registered Contacts, Counter of time expired registrations, Counter of accepted registrations, Counter of rejected registrations
@TEST_STEP_REACTION: The following KPI's are displayed for the Call Routing Service - - Number of currently registered Users, Number of currently registered Contacts, Counter of time expired registrations, Counter of accepted registrations, Counter of rejected registrations
@TEST_STEP_REF: [CATS-REF: oepw]
Then get items of active instance amongst ${phoneRouting_1_items} and ${phoneRouting_2_items} :=> active_phoneRouting_items
Then get phone-routing KPIs values from zabbix host ${active_phoneRouting_items} :=> items_values

Scenario: 1.1 Verify that status change reason indicates an active instance
Then evaluate ${items_values}["Lifecycle status change reason"] contains "active"

Scenario: 1.2 Verify that Service operates in normal conditions
Then verify that ${items_values}["Service operationalStatus"] has the expected value 0

Scenario: 1.3 Verify the details of Service's operational Status
Then verify that ${items_values}["Service operational status in details"] has the expected value "OK"

Scenario: 1.4 Verify that Service's SIP signalling interface is okay
Then verify that ${items_values}["SIP signalling interface operational status"] has the expected value 0

Scenario: 1.5 Verify the details of Service's SIP signalling interface
Then verify that ${items_values}["SIP signalling interface operational status in details"] has the expected value "VIP OK, PHY OK"

Scenario: 2. Verify number of currently registered contacts
Meta:
@TEST_STEP_ACTION: Verify number of currently registered contacts
@TEST_STEP_REACTION: Number of currently registered contacts is equal with the sum of all OPs' assigned roles plus the number of physical OPs
@TEST_STEP_REF: [CATS-REF: iuld]
Then verify that ${items_values}["Number of currently registered contacts"] has the expected value 23

Scenario: 3. Verify number of currently registered users
Meta:
@TEST_STEP_ACTION: Verify number of currently registered users
@TEST_STEP_REACTION: Number of currently registered users is equal with the sum of all unique OPs' assigned roles plus the number of physical OPs
@TEST_STEP_REF: [CATS-REF: coTF]
Then verify that ${items_values}["Number of currently registered users"] has the expected value 16

Scenario: 4. Create a valid Phonebook entry, like: sip:12345@frequentis.com
Meta:
@TEST_STEP_ACTION: Create a valid Phonebook entry, like: sip:12345@frequentis.com
@TEST_STEP_REACTION: Phonebook entry is created and registered successfully
@TEST_STEP_REF: [CATS-REF: oASC]
Given SipContacts group SipContactValid:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContactValid are created

Scenario: 5. Create an invalid Phonebook entry, like:sip:ThiIsASipContactWhichWillNotBeRegisteredCorrectlyDueToTheLenghtOfTheAddress@invalidSipURI.com
Meta:
@TEST_STEP_ACTION: Create an invalid Phonebook entry, like:sip:ThiIsASipContactWhichWillNotBeRegisteredCorrectlyDueToTheLenghtOfTheAddress@invalidSipURI.com
@TEST_STEP_REACTION: Phonebook entry is created, but it is not registered due its too long name. (registration is rejected)
@TEST_STEP_REF: [CATS-REF: vo1g]
Given SipContacts group SipContactInvalid:
| key        | profile | user-entity                                                                  | sip-uri                                                                                           |
| SipContact | VOIP    | ThiIsASipContactWhichWillNotBeRegisteredCorrectlyDueToTheLenghtOfTheAddress  | sip:ThiIsASipContactWhichWillNotBeRegisteredCorrectlyDueToTheLenghtOfTheAddress@invalidSipURI.com |
And phones for SipContactInvalid are created

Scenario: 6. Kill all Op Voice Service instances
Meta:
@TEST_STEP_ACTION: Kill all Op Voice Service instances
@TEST_STEP_REACTION: All Op Voice Service instances are killed and the registrations active until now will expire
@TEST_STEP_REF: [CATS-REF: YrVy]
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost1.story,
			  voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
Then waiting for 1 second

Scenario: 7. Wait for Zabbix update
Meta:
@TEST_STEP_ACTION: Wait for Zabbix update
@TEST_STEP_REACTION: Zabbix is Refreshed with updated values
@TEST_STEP_REF: [CATS-REF: mu2W]
Then waiting for 120 seconds

Scenario: 7.1 Interrogate Zabbix for data
When Zabbix ZABBIX.test requests items:
| hostids                                        |
| #{${active_phoneRouting_items}.get(0).hostid}  | :=> active_phoneRouting_items_update1

Scenario: 7.2 Get KPI values
Then get phone-routing KPIs values from zabbix host ${active_phoneRouting_items_update1} :=> items_values_update

Scenario: 8. Verify number of currently registered contacts
Meta:
@TEST_STEP_ACTION: Verify number of currently registered contacts
@TEST_STEP_REACTION: Number of currently registered contacts is 1 (the successful registered phonebook entry)
@TEST_STEP_REF: [CATS-REF: 1Oh3]
Then verify that ${items_values_update}["Number of currently registered contacts"] has the expected value 1

Scenario: 9. Verify number of currently registered users
Meta:
@TEST_STEP_ACTION: Verify number of currently registered users
@TEST_STEP_REACTION: Number of currently registered users is 1 (the successful registered phonebook entry)
@TEST_STEP_REF: [CATS-REF: PqRy]
Then verify that ${items_values_update}["Number of currently registered users"] has the expected value 1

Scenario: 10. Verify value of Counter of time expired registrations
Meta:
@TEST_STEP_ACTION: Verify value of Counter of time expired registrations
@TEST_STEP_REACTION: Value of Counter of time expired registrations is greater than previous saved value
@TEST_STEP_REF: [CATS-REF: sdsH]
Then verify that ${items_values_update}["Counter of expired registrations"] is greater than ${items_values}["Counter of expired registrations"]

Scenario: 11. Verify value of Counter of accepted registrations
Meta:
@TEST_STEP_ACTION: Verify value of Counter of accepted registrations
@TEST_STEP_REACTION: Value of Counter of accepted registrations is greater than previous saved value
@TEST_STEP_REF: [CATS-REF: Ydyh]
Then verify that ${items_values_update}["Counter of accepted registrations"] is greater or equal to ${items_values}["Counter of accepted registrations"]

Scenario: 12. Verify value of Counter of rejected registrations
Meta:
@TEST_STEP_ACTION: Verify value of Counter of rejected registrations
@TEST_STEP_REACTION: Value of Counter of rejected registrations is greater than previous saved value
@TEST_STEP_REF: [CATS-REF: AaE6]
Then verify that ${items_values_update}["Counter of rejected registrations"] is greater than ${items_values}["Counter of rejected registrations"]

Scenario: Clean-up: Remove valid phone
When SipContactValid is removed

Scenario: Clean-up: Remove invalid phone
When SipContactInvalid is removed

Scenario: Restart both OP-Voice-Service instances
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost1.story,
			  voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
