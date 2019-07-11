Narrative:
As an operator
I want to configurate a DA key
So I can verify that the call is established properly

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                   | target                   | callType |
| OP1-OP2-1 | sip:111111@example.com   | sip:222222@example.com   | DA/IDA   |
| OP1-OP2-2 | sip:op3@example.com      | sip:222222@example.com   | DA/IDA   |
| OP1-OP2-3 | sip:111111@example.com   | sip:mission2@example.com | DA/IDA   |
| OP2-OP1-3 | sip:mission2@example.com | sip:111111@example.com   | DA/IDA   |

Scenario: Outgoing DA call using as source Physical OP SIP Address
 		  @REQUIREMENTS:GID-4123501
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 has the DA key OP2(as OP1) in state out_ringing
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP2 has the call queue item OP1-OP2-1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2-1 in the waiting list with name label Operator1
When HMI OP1 presses DA key OP2(as OP1)

Scenario: Outgoing DA call using as source another specific SIP address
When HMI OP1 presses DA key OP2(as OP3)
Then HMI OP1 has the DA key OP2(as OP3) in state out_ringing
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP2 has the call queue item OP1-OP2-2 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2-2 in the waiting list with name label op3
When HMI OP1 presses DA key OP2(as OP3)

Scenario: Outgoing DA call using as source the default SIP address
When HMI OP2 presses DA key OP1-mission
Then HMI OP2 has the DA key OP1-mission in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2-3 in state out_ringing
Then HMI OP1 has the call queue item OP2-OP1-3 in the waiting list with name label mission2
Then HMI OP1 has in the waiting list a number of 1 calls
When HMI OP2 presses DA key OP1-mission

Scenario: Verify call is terminated for both operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
