Scenario: Define call queue items
Given the call queue items:
| key              | source                 | target                 | callType |
| OP1-OP2          | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1          | sip:222222@example.com | sip:111111@example.com | DA/IDA   |
| OP3-OP2          | sip:op3@example.com    | sip:222222@example.com | DA/IDA   |
| OP2-OP3          | sip:222222@example.com | sip:op3@example.com    | DA/IDA   |
| OP1-OP3          | sip:111111@example.com | sip:op3@example.com    | DA/IDA   |
| OP3-OP1          | sip:op3@example.com    | sip:111111@example.com | DA/IDA   |
| OP1-OP2-IA       | sip:111111@example.com | sip:222222@example.com | IA       |
| OP2-OP1-IA       | sip:222222@example.com | sip:111111@example.com | IA       |
| OP3-OP2-IA       | sip:op3@example.com    | sip:222222@example.com | IA       |
| OP2-OP3-IA       | sip:222222@example.com | sip:op3@example.com    | IA       |
| OP1-OP3-IA       | sip:111111@example.com | sip:op3@example.com    | IA       |
| OP3-OP1-IA       | sip:op3@example.com    | sip:111111@example.com | IA       |
| SipContact2-OP1  | <<SIP_PHONE2>>         | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| SipContact2-OP2  | <<SIP_PHONE2>>         | <<OPVOICE2_PHONE_URI>> | DA/IDA   |
| SipContact3-OP1  | <<SIP_PHONE3>>         | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| OP1-SipContact   | <<SIP_PHONE2>>         |                        | DA/IDA   |
| OP3-OP2-Conf     | sip:op3@example.com    | sip:222222@example.com | CONF     |
| OP1-OP2-Conf     | sip:111111@example.com | sip:222222@example.com | CONF     |
| OP2-OP3-Conf     | <<OPVOICE2_CONF_URI>>  | sip:op3@example.com    | DA/IDA   |
| OP2-OP1-Conf     | <<OPVOICE2_CONF_URI>>  | sip:111111@example.com | DA/IDA   |
| OP2-OP3-Conf-URI | <<OPVOICE2_CONF_URI>>  | <<OPVOICE3_PHONE_URI>> | DA/IDA   |

Scenario: OP1 cleans up call queues, if is the case
Then HMI OP1 cleans the call queue item OP2-OP1-IA from the call queue list activeList
Then HMI OP1 cleans the call queue item OP3-OP1-IA from the call queue list activeList
Then HMI OP1 cleans the call queue item OP2-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item OP3-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item SipContact2-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item SipContact3-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item OP2-OP1-Conf from the call queue list activeList

Then HMI OP1 cleans the call queue item OP2-OP1-IA from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP3-OP1-IA from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP2-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP3-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item SipContact2-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item SipContact3-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP2-OP1-Conf from the call queue list waitingList

Then HMI OP1 cleans the call queue item OP2-OP1-IA from the call queue list holdList
Then HMI OP1 cleans the call queue item OP3-OP1-IA from the call queue list holdList
Then HMI OP1 cleans the call queue item OP2-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item OP3-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item SipContact2-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item SipContact3-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item OP2-OP1-Conf from the call queue list holdList

Then HMI OP1 cleans the call queue item OP2-OP1-IA from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP3-OP1-IA from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP2-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP3-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item SipContact2-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item SipContact3-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP2-OP1-Conf from the call queue list priorityList

Scenario: OP2 cleans up call queues, if is the case
Then HMI OP2 cleans the call queue item OP1-OP2-IA from the call queue list activeList
Then HMI OP2 cleans the call queue item OP3-OP2-IA from the call queue list activeList
Then HMI OP2 cleans the call queue item OP1-OP2 from the call queue list activeList
Then HMI OP2 cleans the call queue item OP3-OP2 from the call queue list activeList
Then HMI OP2 cleans the call queue item SipContact2-OP2 from the call queue list activeList
Then HMI OP2 cleans the call queue item OP1-OP2-Conf from the call queue list activeList
Then HMI OP2 cleans the call queue item OP3-OP2-Conf from the call queue list activeList

Then HMI OP2 cleans the call queue item OP1-OP2-IA from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP3-OP2-IA from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP1-OP2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP3-OP2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item SipContact2-OP2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP1-OP2-Conf from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP3-OP2-Conf from the call queue list waitingList

Then HMI OP2 cleans the call queue item OP2-OP1-IA from the call queue list holdList
Then HMI OP2 cleans the call queue item OP3-OP2-IA from the call queue list holdList
Then HMI OP2 cleans the call queue item OP1-OP2 from the call queue list holdList
Then HMI OP2 cleans the call queue item OP3-OP2 from the call queue list holdList
Then HMI OP2 cleans the call queue item SipContact2-OP2 from the call queue list holdList
Then HMI OP2 cleans the call queue item OP1-OP2-Conf from the call queue list holdList
Then HMI OP2 cleans the call queue item OP3-OP2-Conf from the call queue list holdList

Then HMI OP2 cleans the call queue item OP1-OP2-IA from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP3-OP2-IA from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP1-OP2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP3-OP2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item SipContact2-OP2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP1-OP2-Conf from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP3-OP2-Conf from the call queue list priorityList

Scenario: OP3 cleans up call queues, if is the case
Then HMI OP3 cleans the call queue item OP2-OP3-IA from the call queue list activeList
Then HMI OP3 cleans the call queue item OP1-OP3-IA from the call queue list activeList
Then HMI OP3 cleans the call queue item OP2-OP3 from the call queue list activeList
Then HMI OP3 cleans the call queue item OP1-OP3 from the call queue list activeList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf from the call queue list activeList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf-URI from the call queue list activeList

Then HMI OP3 cleans the call queue item OP2-OP3-IA from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP1-OP3-IA from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP2-OP3 from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP1-OP3 from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf-URI from the call queue list waitingList

Then HMI OP3 cleans the call queue item OP2-OP3-IA from the call queue list holdList
Then HMI OP3 cleans the call queue item OP1-OP3-IA from the call queue list holdList
Then HMI OP3 cleans the call queue item OP2-OP3 from the call queue list holdList
Then HMI OP3 cleans the call queue item OP1-OP3 from the call queue list holdList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf from the call queue list holdList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf-URI from the call queue list holdList

Then HMI OP3 cleans the call queue item OP2-OP3-IA from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP1-OP3-IA from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP2-OP3 from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP1-OP3 from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf-URI from the call queue list priorityList

