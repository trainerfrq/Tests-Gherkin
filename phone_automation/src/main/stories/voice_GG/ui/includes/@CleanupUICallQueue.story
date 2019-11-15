Scenario: Define call queue items
Given the call queue items:
| key                  | source                        | target                         | callType |
| OP1-OP2              | <<OP1_URI>>                   | <<OP2_URI>>                    | DA/IDA   |
| OP2-OP1              | <<OP2_URI>>                   | <<OP1_URI>>                    | DA/IDA   |
| OP3-OP2              | <<OP3_URI>>                   | <<OP2_URI>>                    | DA/IDA   |
| OP2-OP3              | <<OP2_URI>>                   | <<OP3_URI>>                    | DA/IDA   |
| OP1-OP3              | <<OP1_URI>>                   | <<OP3_URI>>                    | DA/IDA   |
| OP3-OP1              | <<OP3_URI>>                   | <<OP1_URI>>                    | DA/IDA   |
| OP1-OP2-IA           | <<OP1_URI>>                   | <<OP2_URI>>                    | IA       |
| OP2-OP1-IA           | <<OP2_URI>>                   | <<OP1_URI>>                    | IA       |
| OP3-OP2-IA           | <<OP3_URI>>                   | <<OP2_URI>>                    | IA       |
| OP2-OP3-IA           | <<OP2_URI>>                   | <<OP3_URI>>                    | IA       |
| OP1-OP3-IA           | <<OP1_URI>>                   | <<OP3_URI>>                    | IA       |
| OP3-OP1-IA           | <<OP3_URI>>                   | <<OP1_URI>>                    | IA       |
| ROLE1-ROLE2-IA       | <<ROLE1_URI>>                 | <<ROLE2_URI>>                  | IA       |
| ROLE2-ROLE1-IA       | <<ROLE2_URI>>                 | <<ROLE1_URI>>                  | IA       |
| OP2-ROLE1-IA         | <<OP2_URI>>                   | sip:role1@example.com          | IA       |
| ROLE1-OP2-IA         | sip:role1@example.com         | <<OP2_URI>>                    | IA       |
| ROLE2-IA             | <<ROLE2_URI>>                 |                                | IA       |
| SipContact2-OP1      | <<SIP_PHONE2>>                | <<OPVOICE1_PHONE_URI>>         | DA/IDA   |
| SipContact2-OP2      | <<SIP_PHONE2>>                | <<OPVOICE2_PHONE_URI>>         | DA/IDA   |
| SipContact3-OP1      | <<SIP_PHONE3>>                | <<OPVOICE1_PHONE_URI>>         | DA/IDA   |
| OP1-SipContact       | <<SIP_PHONE2>>                |                                | DA/IDA   |
| OP3-OP2-Conf         | <<OP3_URI>>                   | <<OP2_URI>>                    | CONF     |
| OP1-OP2-Conf         | <<OP1_URI>>                   | <<OP2_URI>>                    | CONF     |
| OP2-OP3-Conf         | <<OPVOICE2_CONF_URI>>         | <<OP3_URI>>                    | DA/IDA   |
| OP2-OP1-Conf         | <<OPVOICE2_CONF_URI>>         | <<OP1_URI>>                    | DA/IDA   |
| OP2-OP3-Conf-URI     | <<OPVOICE2_CONF_URI>>         | <<OPVOICE3_PHONE_URI>>         | DA/IDA   |
| ROLE1-ROLE2          | <<ROLE1_URI>>                 | <<ROLE2_URI>>                  | DA/IDA   |
| ROLE2-ROLE1          | <<ROLE2_URI>>                 | <<ROLE1_URI>>                  | DA/IDA   |
| ROLE1-OP2            | <<ROLE1_URI>>                 | <<OP2_URI>>                    | DA/IDA   |
| OP2-ROLE1            | <<OP2_URI>>                   | <<ROLE1_URI>>                  | DA/IDA   |
| ROLE2-ROLE3          | <<ROLE2_URI>>                 | <<ROLE3_URI>>                  | DA/IDA   |
| ROLE3-ROLE2          | <<ROLE3_URI>>                 | <<ROLE2_URI>>                  | DA/IDA   |
| ROLE2                | <<ROLE2_URI>>                 |                                | DA/IDA   |
| ROLE3                | <<ROLE3_URI>>                 |                                | DA/IDA   |
| OP3-Role1            | <<OP3_URI>>                   | sip:role1@example.com          | DA/IDA   |
| Role1-OP3            | sip:role1@example.com         | <<OP3_URI>>                    | DA/IDA   |
| OP3-OP1_uregent      | <<OP3_URI>>                   | <<OP1_URI>>                    | DA/IDA   |
| OP1_uregent-OP3      | <<OP1_URI>>                   | <<OP3_URI>>                    | DA/IDA   |
| OP1-SipContact2      | <<SIP_PHONE5>>                |                                | DA/IDA   |
| OP1-SipContact3      | <<SIP_PHONE4>>                |                                | DA/IDA   |
| OP2-RoleEmergency    | <<OP2_URI>>                   | <<ROLE_EMERGENCY_URI>>         | DA/IDA   |
| RoleEmergency-OP2    | <<ROLE_EMERGENCY_URI>>        | <<OP2_URI>>                    | DA/IDA   |
| OP2-SipContact       | <<SIP_PHONE6>>                | <<ROLE2_URI>>                  | DA/IDA   |
| OP1_Master-OP2       | <<ROLE1_URI>>                 | <<OP2_URI>>                    | DA/IDA   |
| OP2-OP1_Master       | <<OP2_URI>>                   |                                | DA/IDA   |

Scenario: OP1 cleans up active list call queues, if is the case
Then HMI OP1 cleans the call queue item OP2-OP1-IA from the call queue list activeList
Then HMI OP1 cleans the call queue item OP3-OP1-IA from the call queue list activeList
Then HMI OP1 cleans the call queue item OP2-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item OP3-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item SipContact2-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item SipContact3-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item OP2-OP1-Conf from the call queue list activeList
Then HMI OP1 cleans the call queue item ROLE2-ROLE1 from the call queue list activeList
Then HMI OP1 cleans the call queue item OP2-ROLE1 from the call queue list activeList
Then HMI OP1 cleans the call queue item ROLE3 from the call queue list activeList
Then HMI OP1 cleans the call queue item ROLE2 from the call queue list activeList
Then HMI OP1 cleans the call queue item ROLE2-ROLE1-IA from the call queue list activeList
Then HMI OP1 cleans the call queue item OP2-ROLE1-IA from the call queue list activeList
Then HMI OP1 cleans the call queue item ROLE2-IA from the call queue list activeList
Then HMI OP1 cleans the call queue item OP3-Role1 from the call queue list activeList
Then HMI OP1 cleans the call queue item OP3-OP1_uregent from the call queue list activeList
Then HMI OP1 cleans the call queue item OP2-RoleEmergency from the call queue list activeList
Then HMI OP1 cleans the call queue item OP1-SipContact2 from the call queue list activeList
Then HMI OP1 cleans the call queue item OP1-SipContact3 from the call queue list activeList
Then HMI OP1 cleans the call queue item OP2-OP1_Master from the call queue list activeList

Scenario: OP1 cleans up waiting list call queues, if is the case
Then HMI OP1 cleans the call queue item OP2-OP1-IA from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP3-OP1-IA from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP2-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP3-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item SipContact2-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item SipContact3-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP2-OP1-Conf from the call queue list waitingList
Then HMI OP1 cleans the call queue item ROLE2-ROLE1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP2-ROLE1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item ROLE3 from the call queue list waitingList
Then HMI OP1 cleans the call queue item ROLE2 from the call queue list waitingList
Then HMI OP1 cleans the call queue item ROLE2-ROLE1-IA from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP2-ROLE1-IA from the call queue list waitingList
Then HMI OP1 cleans the call queue item ROLE2-IA from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP3-Role1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP3-OP1_uregent from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP2-RoleEmergency from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP1-SipContact2 from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP1-SipContact3 from the call queue list waitingList
Then HMI OP1 cleans the call queue item OP2-OP1_Master from the call queue list waitingList

Scenario: OP1 cleans up hold list call queues, if is the case
Then HMI OP1 cleans the call queue item OP2-OP1-IA from the call queue list holdList
Then HMI OP1 cleans the call queue item OP3-OP1-IA from the call queue list holdList
Then HMI OP1 cleans the call queue item OP2-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item OP3-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item SipContact2-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item SipContact3-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item OP2-OP1-Conf from the call queue list holdList
Then HMI OP1 cleans the call queue item ROLE2-ROLE1 from the call queue list holdList
Then HMI OP1 cleans the call queue item OP2-ROLE1 from the call queue list holdList
Then HMI OP1 cleans the call queue item ROLE3 from the call queue list holdList
Then HMI OP1 cleans the call queue item ROLE2 from the call queue list holdList
Then HMI OP1 cleans the call queue item ROLE2-ROLE1-IA from the call queue list holdList
Then HMI OP1 cleans the call queue item OP2-ROLE1-IA from the call queue list holdList
Then HMI OP1 cleans the call queue item ROLE2-IA from the call queue list holdList
Then HMI OP1 cleans the call queue item OP3-Role1 from the call queue list holdList
Then HMI OP1 cleans the call queue item OP3-OP1_uregent from the call queue list holdList
Then HMI OP1 cleans the call queue item OP2-RoleEmergency from the call queue list holdList
Then HMI OP1 cleans the call queue item OP1-SipContact2 from the call queue list holdList
Then HMI OP1 cleans the call queue item OP1-SipContact3 from the call queue list holdList
Then HMI OP1 cleans the call queue item OP2-OP1_Master from the call queue list holdList

Scenario: OP1 cleans up priority list call queues, if is the case
Then HMI OP1 cleans the call queue item OP2-OP1-IA from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP3-OP1-IA from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP2-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP3-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item SipContact2-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item SipContact3-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP2-OP1-Conf from the call queue list priorityList
Then HMI OP1 cleans the call queue item ROLE2-ROLE1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP2-ROLE1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item ROLE3 from the call queue list priorityList
Then HMI OP1 cleans the call queue item ROLE2 from the call queue list priorityList
Then HMI OP1 cleans the call queue item ROLE2-ROLE1-IA from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP2-ROLE1-IA from the call queue list priorityList
Then HMI OP1 cleans the call queue item ROLE2-IA from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP3-Role1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP3-OP1_uregent from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP2-RoleEmergency from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP1-SipContact2 from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP1-SipContact3 from the call queue list priorityList
Then HMI OP1 cleans the call queue item OP2-OP1_Master from the call queue list priorityList

Scenario: OP2 cleans up active list call queues, if is the case
Then HMI OP2 cleans the call queue item OP1-OP2-IA from the call queue list activeList
Then HMI OP2 cleans the call queue item OP3-OP2-IA from the call queue list activeList
Then HMI OP2 cleans the call queue item OP1-OP2 from the call queue list activeList
Then HMI OP2 cleans the call queue item OP3-OP2 from the call queue list activeList
Then HMI OP2 cleans the call queue item SipContact2-OP2 from the call queue list activeList
Then HMI OP2 cleans the call queue item OP1-OP2-Conf from the call queue list activeList
Then HMI OP2 cleans the call queue item OP3-OP2-Conf from the call queue list activeList
Then HMI OP2 cleans the call queue item ROLE1-ROLE2 from the call queue list activeList
Then HMI OP2 cleans the call queue item ROLE1-OP2 from the call queue list activeList
Then HMI OP2 cleans the call queue item ROLE3-ROLE2 from the call queue list activeList
Then HMI OP2 cleans the call queue item ROLE3 from the call queue list activeList
Then HMI OP2 cleans the call queue item ROLE1-OP2-IA from the call queue list activeList
Then HMI OP2 cleans the call queue item ROLE1-ROLE2-IA from the call queue list activeList
Then HMI OP2 cleans the call queue item OP3-Role1 from the call queue list activeList
Then HMI OP2 cleans the call queue item RoleEmergency-OP2 from the call queue list activeList
Then HMI OP2 cleans the call queue item OP1_Master-OP2 from the call queue list activeList
Then HMI OP2 cleans the call queue item OP2-SipContact from the call queue list activeList

Scenario: OP2 cleans up waiting list call queues, if is the case
Then HMI OP2 cleans the call queue item OP1-OP2-IA from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP3-OP2-IA from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP1-OP2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP3-OP2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item SipContact2-OP2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP1-OP2-Conf from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP3-OP2-Conf from the call queue list waitingList
Then HMI OP2 cleans the call queue item ROLE1-ROLE2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item ROLE1-OP2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item ROLE3-ROLE2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item ROLE3 from the call queue list waitingList
Then HMI OP2 cleans the call queue item ROLE1-OP2-IA from the call queue list waitingList
Then HMI OP2 cleans the call queue item ROLE1-ROLE2-IA from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP3-Role1 from the call queue list waitingList
Then HMI OP2 cleans the call queue item RoleEmergency-OP2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP1_Master-OP2 from the call queue list waitingList
Then HMI OP2 cleans the call queue item OP2-SipContact from the call queue list waitingList

Scenario: OP2 cleans up hold list call queues, if is the case
Then HMI OP2 cleans the call queue item OP2-OP1-IA from the call queue list holdList
Then HMI OP2 cleans the call queue item OP3-OP2-IA from the call queue list holdList
Then HMI OP2 cleans the call queue item OP1-OP2 from the call queue list holdList
Then HMI OP2 cleans the call queue item OP3-OP2 from the call queue list holdList
Then HMI OP2 cleans the call queue item SipContact2-OP2 from the call queue list holdList
Then HMI OP2 cleans the call queue item OP1-OP2-Conf from the call queue list holdList
Then HMI OP2 cleans the call queue item OP3-OP2-Conf from the call queue list holdList
Then HMI OP2 cleans the call queue item ROLE1-ROLE2 from the call queue list holdList
Then HMI OP2 cleans the call queue item ROLE1-OP2 from the call queue list holdList
Then HMI OP2 cleans the call queue item ROLE3-ROLE2 from the call queue list holdList
Then HMI OP2 cleans the call queue item ROLE3 from the call queue list holdList
Then HMI OP2 cleans the call queue item ROLE1-OP2-IA from the call queue list holdList
Then HMI OP2 cleans the call queue item ROLE1-ROLE2-IA from the call queue list holdList
Then HMI OP2 cleans the call queue item OP3-Role1 from the call queue list holdList
Then HMI OP2 cleans the call queue item RoleEmergency-OP2 from the call queue list holdList
Then HMI OP2 cleans the call queue item OP1_Master-OP2 from the call queue list holdList
Then HMI OP2 cleans the call queue item OP2-SipContact from the call queue list holdList

Scenario: OP2 cleans up priority list call queues, if is the case
Then HMI OP2 cleans the call queue item OP1-OP2-IA from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP3-OP2-IA from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP1-OP2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP3-OP2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item SipContact2-OP2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP1-OP2-Conf from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP3-OP2-Conf from the call queue list priorityList
Then HMI OP2 cleans the call queue item ROLE1-ROLE2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item ROLE1-OP2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item ROLE3-ROLE2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item ROLE3 from the call queue list priorityList
Then HMI OP2 cleans the call queue item ROLE1-OP2-IA from the call queue list priorityList
Then HMI OP2 cleans the call queue item ROLE1-ROLE2-IA from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP3-Role1 from the call queue list priorityList
Then HMI OP2 cleans the call queue item RoleEmergency-OP2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP1_Master-OP2 from the call queue list priorityList
Then HMI OP2 cleans the call queue item OP2-SipContact from the call queue list priorityList

Scenario: OP3 cleans up active list call queues, if is the case
Then HMI OP3 cleans the call queue item OP2-OP3-IA from the call queue list activeList
Then HMI OP3 cleans the call queue item OP1-OP3-IA from the call queue list activeList
Then HMI OP3 cleans the call queue item OP2-OP3 from the call queue list activeList
Then HMI OP3 cleans the call queue item OP1-OP3 from the call queue list activeList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf from the call queue list activeList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf-URI from the call queue list activeList
Then HMI OP3 cleans the call queue item ROLE2-ROLE3 from the call queue list activeList
Then HMI OP3 cleans the call queue item ROLE2 from the call queue list activeList
Then HMI OP3 cleans the call queue item Role1-OP3 from the call queue list activeList
Then HMI OP3 cleans the call queue item OP1_uregent-OP3 from the call queue list activeList
Then HMI OP3 cleans the call queue item OP2-RoleEmergency from the call queue list activeList

Scenario: OP3 cleans up waiting list call queues, if is the case
Then HMI OP3 cleans the call queue item OP2-OP3-IA from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP1-OP3-IA from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP2-OP3 from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP1-OP3 from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf-URI from the call queue list waitingList
Then HMI OP3 cleans the call queue item ROLE2-ROLE3 from the call queue list waitingList
Then HMI OP3 cleans the call queue item ROLE2 from the call queue list waitingList
Then HMI OP3 cleans the call queue item Role1-OP3 from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP1_uregent-OP3 from the call queue list waitingList
Then HMI OP3 cleans the call queue item OP2-RoleEmergency from the call queue list waitingList

Scenario: OP3 cleans up ahold list call queues, if is the case
Then HMI OP3 cleans the call queue item OP2-OP3-IA from the call queue list holdList
Then HMI OP3 cleans the call queue item OP1-OP3-IA from the call queue list holdList
Then HMI OP3 cleans the call queue item OP2-OP3 from the call queue list holdList
Then HMI OP3 cleans the call queue item OP1-OP3 from the call queue list holdList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf from the call queue list holdList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf-URI from the call queue list holdList
Then HMI OP3 cleans the call queue item ROLE2-ROLE3 from the call queue list holdList
Then HMI OP3 cleans the call queue item ROLE2 from the call queue list holdList
Then HMI OP3 cleans the call queue item Role1-OP3 from the call queue list holdList
Then HMI OP3 cleans the call queue item OP1_uregent-OP3 from the call queue list holdList
Then HMI OP3 cleans the call queue item OP2-RoleEmergency from the call queue list holdList

Scenario: OP3 cleans up priority list call queues, if is the case
Then HMI OP3 cleans the call queue item OP2-OP3-IA from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP1-OP3-IA from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP2-OP3 from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP1-OP3 from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP2-OP3-Conf-URI from the call queue list priorityList
Then HMI OP3 cleans the call queue item ROLE2-ROLE3 from the call queue list priorityList
Then HMI OP3 cleans the call queue item ROLE2 from the call queue list priorityList
Then HMI OP3 cleans the call queue item Role1-OP3 from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP1_uregent-OP3 from the call queue list priorityList
Then HMI OP3 cleans the call queue item OP2-RoleEmergency from the call queue list priorityList

