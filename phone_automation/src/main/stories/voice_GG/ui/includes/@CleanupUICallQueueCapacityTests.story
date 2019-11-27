Scenario: Define call queue items
Given the call queue items:
| key          | source    | target                 | callType |
| Caller1-OP1  | <<SIP1>>  | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller2-OP1  | <<SIP2>>  | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller3-OP1  | <<SIP3>>  | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller4-OP1  | <<SIP4>>  | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller5-OP1  | <<SIP5>>  | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller6-OP1  | <<SIP6>>  | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller7-OP1  | <<SIP7>>  | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller8-OP1  | <<SIP8>>  | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller9-OP1  | <<SIP9>>  | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller10-OP1 | <<SIP10>> | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller11-OP1 | <<SIP11>> | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller12-OP1 | <<SIP12>> | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller13-OP1 | <<SIP13>> | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller14-OP1 | <<SIP14>> | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller15-OP1 | <<SIP15>> | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| Caller16-OP1 | <<SIP16>> | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

Scenario: OP1 cleans up active list call queues, if is the case
Then HMI OP1 cleans the call queue item Caller1-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller2-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller3-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller4-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller5-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller6-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller7-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller8-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller9-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller10-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller11-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller12-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller13-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller14-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller15-OP1 from the call queue list activeList
Then HMI OP1 cleans the call queue item Caller16-OP1 from the call queue list activeList

Scenario: OP1 cleans up waiting list call queues, if is the case
Then HMI OP1 cleans the call queue item Caller1-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller2-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller3-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller4-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller5-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller6-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller7-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller8-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller9-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller10-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller11-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller12-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller13-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller14-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller15-OP1 from the call queue list waitingList
Then HMI OP1 cleans the call queue item Caller16-OP1 from the call queue list waitingList

Scenario: OP1 cleans up hold list call queues, if is the case
Then HMI OP1 cleans the call queue item Caller1-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller2-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller3-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller4-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller5-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller6-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller7-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller8-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller9-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller10-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller11-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller12-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller13-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller14-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller15-OP1 from the call queue list holdList
Then HMI OP1 cleans the call queue item Caller16-OP1 from the call queue list holdList

Scenario: OP1 cleans up priority list call queues, if is the case
Then HMI OP1 cleans the call queue item Caller1-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller2-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller3-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller4-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller5-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller6-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller7-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller8-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller9-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller10-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller11-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller12-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller13-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller14-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller15-OP1 from the call queue list priorityList
Then HMI OP1 cleans the call queue item Caller16-OP1 from the call queue list priorityList

