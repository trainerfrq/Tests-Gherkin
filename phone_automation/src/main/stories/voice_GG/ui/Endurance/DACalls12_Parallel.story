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
When DISPLAY STATUS label mission is clicked by:
| profile |
| HMI OP1 |
| HMI OP2 |
Then current mission is changed to:
| profile | mission            |
| HMI OP1 | <<MISSION_1_NAME>> |
| HMI OP2 | <<MISSION_2_NAME>> |

Scenario: Remove SIP Contact
When SipContact is removed
