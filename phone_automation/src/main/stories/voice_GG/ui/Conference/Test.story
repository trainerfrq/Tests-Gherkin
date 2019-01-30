Narrative:
As an operator part of an active call
I want to start a conference
So I can add more participants to the call

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key                 | source                 | target                   | callType |
| OP2-OP1-Conf        | <<OPVOICE2_CONF_URI>>  | sip:111111@example.com   | DA/IDA   |
| OP2-OP3-Conf        | <<OPVOICE2_CONF_URI>>  | sip:op3@example.com:5060 | DA/IDA   |
| SipContact-OP2      | <<SIP_PHONE2>>         | <<OPVOICE2_PHONE_URI>>   | DA/IDA   |
| SipContact-OP2-Conf | <<SIP_PHONE2>>         | <<OPVOICE2_PHONE_URI>>   | CONF     |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Given SipContacts group SipConf:
| key        | profile | user-entity | sip-uri        |
| SipConf    | VOIP    | conf        | sip:conf@192.168.40.129:5060 |
And phones for SipConf are created

Scenario: Sip phone calls operator Op2
When SipContact calls SIP URI <<OPVOICE2_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Op2 accepts external sip call
Then HMI OP2 accepts the call queue item SipContact-OP2

Scenario: Op2 starts a conference
When HMI OP2 starts a conference
When SipConf answers incoming calls
Then HMI OP2 has the call queue item SipContact-OP2-Conf in state connected
Then HMI OP2 has the call queue item SipContact-OP2-Conf in the active list with name label Madoline
Then HMI OP2 has the call queue item SipContact-OP2-Conf in the active list with info label 1 more participant
Then HMI OP2 has a notification that shows Conference call active
