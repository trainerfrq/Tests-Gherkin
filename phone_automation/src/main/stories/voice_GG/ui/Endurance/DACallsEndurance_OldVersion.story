Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host           | identifier |
| javafx              | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx              | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key            | source         | target        | callType |
| OP1-OP2-1      | <<ROLE1_URI>>  | <<ROLE2_URI>> | DA/IDA   |
| OP2-OP1-1      | <<ROLE2_URI>>  |               | DA/IDA   |
| OP1-OP2-2      | <<ROLE1_URI>>  |               | DA/IDA   |
| OP2-OP1-2      | <<ROLE2_URI>>  | <<ROLE1_URI>> | DA/IDA   |
| OP1-SipContact | <<SIP_PHONE2>> |               | DA/IDA   |

Scenario: Operator1 changes the mission on HMI screen
When HMI OP1 clicks on DISPLAY STATUS label mission
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then wait for 5 seconds

Scenario: Operator2 changes the mission on HMI screen
When HMI OP2 clicks on DISPLAY STATUS label mission
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then wait for 5 seconds

Scenario: Steps 1 and 2 described in the Narrative
When HMI OP1 presses DA key <<ROLE_2_NAME>>
Then HMI OP1 has the DA key <<ROLE_2_NAME>> in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1-1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2-1 in state inc_initiated
When HMI OP2 presses DA key <<ROLE_1_NAME>>
Then HMI OP1 has the call queue item OP2-OP1-1 in state connected
Then HMI OP2 has the call queue item OP1-OP2-1 in state connected
Then waiting for 10 seconds
When HMI OP1 presses DA key <<ROLE_2_NAME>>
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
Then waiting for 5 seconds
When HMI OP2 presses DA key <<ROLE_1_NAME>>
Then HMI OP2 has the DA key <<ROLE_1_NAME>> in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2-2 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1-2 in state inc_initiated
When HMI OP1 presses DA key <<ROLE_2_NAME>>
Then HMI OP1 has the call queue item OP2-OP1-2 in state connected
Then HMI OP2 has the call queue item OP1-OP2-2 in state connected
Then waiting for 10 seconds
When HMI OP2 presses DA key <<ROLE_1_NAME>>
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
Then waiting for 5 seconds
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
When HMI OP1 clicks on the scroll down button in phonebook for 1 time(s)
When HMI OP1 selects phonebook entry number: 14
Then HMI OP1 verifies that phone book text box displays text Madoline
When HMI OP1 initiates a call from the phonebook
When SipContact answers incoming calls
Then HMI OP1 has the call queue item OP1-SipContact in state connected
Then waiting for 10 seconds
Then HMI OP1 terminates the call queue item OP1-SipContact
Then HMI OP1 has in the call queue a number of 0 calls
Then waiting for 20 seconds

Examples:
| Iteration |
| 1         |
| 2         |
| 3         |
| 4         |
| 5         |
| 6         |
| 7         |
| 8         |
| 9         |
| 10        |
| 11        |
| 12        |
| 13        |
| 14        |
| 15        |
| 16        |
| 17        |
| 18        |
| 19        |
| 20        |
| 21        |
| 22        |
| 23        |
| 24        |
| 25        |
| 26        |
| 27        |
| 28        |
| 29        |
| 30        |

Scenario: Operator1 changes the mission on HMI screen
When HMI OP1 clicks on DISPLAY STATUS label mission
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then wait for 5 seconds

Scenario: Operator2 changes the mission on HMI screen
When HMI OP2 clicks on DISPLAY STATUS label mission
Then HMI OP2 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP2 activates mission
Then wait for 5 seconds

Scenario: Steps 1 and 2 described in the Narrative
When HMI OP1 presses DA key <<ROLE_1_NAME>>
Then HMI OP1 has the DA key <<ROLE_1_NAME>> in state out_ringing
Then HMI OP1 has the call queue item OP1-OP2-2 in state out_ringing
Then HMI OP2 has the call queue item OP2-OP1-2 in state inc_initiated
When HMI OP2 presses DA key <<ROLE_2_NAME>>
Then HMI OP2 has the call queue item OP2-OP1-2 in state connected
Then HMI OP1 has the call queue item OP1-OP2-2 in state connected
Then waiting for 10 seconds
When HMI OP1 presses DA key <<ROLE_1_NAME>>
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls
Then waiting for 5 seconds
When HMI OP2 presses DA key <<ROLE_2_NAME>>
Then HMI OP2 has the DA key <<ROLE_2_NAME>> in state out_ringing
Then HMI OP2 has the call queue item OP2-OP1-1 in state out_ringing
Then HMI OP1 has the call queue item OP1-OP2-1 in state inc_initiated
When HMI OP1 presses DA key <<ROLE_1_NAME>>
Then HMI OP2 has the call queue item OP2-OP1-1 in state connected
Then HMI OP1 has the call queue item OP1-OP2-1 in state connected
Then waiting for 10 seconds
When HMI OP1 presses DA key <<ROLE_1_NAME>>
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then waiting for 5 seconds
When HMI OP2 with layout <<LAYOUT_MISSION2>> presses function key PHONEBOOK
When HMI OP2 clicks on the scroll down button in phonebook for 1 time(s)
When HMI OP2 selects phonebook entry number: 14
Then HMI OP2 verifies that phone book text box displays text Madoline
When HMI OP2 initiates a call from the phonebook
When SipContact answers incoming calls
Then HMI OP2 has the call queue item OP1-SipContact in state connected
Then waiting for 10 seconds
Then HMI OP2 terminates the call queue item OP1-SipContact
Then HMI OP1 has in the call queue a number of 0 calls
Then waiting for 20 seconds

Examples:
| Iteration |
| 1         |
| 2         |
| 3         |
| 4         |
| 5         |
| 6         |
| 7         |
| 8         |
| 9         |
| 10        |
| 11        |
| 12        |
| 13        |
| 14        |
| 15        |
| 16        |
| 17        |
| 18        |
| 19        |
| 20        |
| 21        |
| 22        |
| 23        |
| 24        |
| 25        |
| 26        |
| 27        |
| 28        |
| 29        |
| 30        |

Scenario: Operator1 changes the mission on HMI screen
When HMI OP1 clicks on DISPLAY STATUS label mission
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then wait for 5 seconds

Scenario: Operator2 changes the mission on HMI screen
When HMI OP2 clicks on DISPLAY STATUS label mission
Then HMI OP2 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP2 activates mission
Then wait for 5 seconds

Scenario: Remove SIP Contact
When SipContact is removed
