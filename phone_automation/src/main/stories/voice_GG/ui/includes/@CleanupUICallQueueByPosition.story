Scenario: OP1 cleans up waiting list call queues, if is the case
Then HMI OP1 cleans call queue list waitingList
Then HMI OP2 cleans call queue list waitingList
Then HMI OP3 cleans call queue list waitingList

Scenario: OP1 cleans up hold list call queues, if is the case
Then HMI OP1 cleans call queue list holdList
Then HMI OP2 cleans call queue list holdList
Then HMI OP3 cleans call queue list holdList

Scenario: OP1 cleans up priority list call queues, if is the case
Then HMI OP1 cleans call queue list priorityList
Then HMI OP2 cleans call queue list priorityList
Then HMI OP3 cleans call queue list priorityList

Scenario: OP1 cleans up active list call queues, if is the case
Then HMI OP1 cleans call queue list activeList
Then HMI OP2 cleans call queue list activeList
Then HMI OP3 cleans call queue list activeList



