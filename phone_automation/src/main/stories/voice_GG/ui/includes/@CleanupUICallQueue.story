Scenario: Define call queue items
Given the call queue items:
| key              | source                | target                 | callType |
| OP1-OP2          | <<OP1_URI>>           | <<OP2_URI>>            | DA/IDA   |
| OP2-OP1          | <<OP2_URI>>           | <<OP1_URI>>            | DA/IDA   |
| OP3-OP2          | <<OP3_URI>>           | <<OP2_URI>>            | DA/IDA   |
| OP2-OP3          | <<OP2_URI>>           | <<OP3_URI>>            | DA/IDA   |
| OP1-OP3          | <<OP1_URI>>           | <<OP3_URI>>            | DA/IDA   |
| OP3-OP1          | <<OP3_URI>>           | <<OP1_URI>>            | DA/IDA   |
| OP1-OP2-IA       | <<OP1_URI>>           | <<OP2_URI>>            | IA       |
| OP2-OP1-IA       | <<OP2_URI>>           | <<OP1_URI>>            | IA       |
| OP3-OP2-IA       | <<OP3_URI>>           | <<OP2_URI>>            | IA       |
| OP2-OP3-IA       | <<OP2_URI>>           | <<OP3_URI>>            | IA       |
| OP1-OP3-IA       | <<OP1_URI>>           | <<OP3_URI>>            | IA       |
| OP3-OP1-IA       | <<OP3_URI>>           | <<OP1_URI>>            | IA       |
| SipContact2-OP1  | <<SIP_PHONE2>>        | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| SipContact2-OP2  | <<SIP_PHONE2>>        | <<OPVOICE2_PHONE_URI>> | DA/IDA   |
| SipContact3-OP1  | <<SIP_PHONE3>>        | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| OP1-SipContact   | <<SIP_PHONE2>>        |                        | DA/IDA   |
| OP3-OP2-Conf     | <<OP3_URI>>           | <<OP2_URI>>            | CONF     |
| OP1-OP2-Conf     | <<OP1_URI>>           | <<OP2_URI>>            | CONF     |
| OP2-OP3-Conf     | <<OPVOICE2_CONF_URI>> | <<OP3_URI>>            | DA/IDA   |
| OP2-OP1-Conf     | <<OPVOICE2_CONF_URI>> | <<OP1_URI>>            | DA/IDA   |
| OP2-OP3-Conf-URI | <<OPVOICE2_CONF_URI>> | <<OPVOICE3_PHONE_URI>> | DA/IDA   |

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

