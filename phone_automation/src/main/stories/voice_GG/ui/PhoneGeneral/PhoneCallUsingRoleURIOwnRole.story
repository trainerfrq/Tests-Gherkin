Narrative:
As a caller operator
I want to initiate a phone call using an Role SIP URI towards the role I am taking part of
So I can verify that the phone call is initiated towards all the logged in operators of the target role including myself

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key       | source                 | target                 | callType |
| OP1-Role1 | sip:111111@example.com | sip:role1@example.com  | DA/IDA   |
| Role1-OP1 | sip:role1@example.com  | sip:111111@example.com | DA/IDA   |

Scenario: Caller establishes an outgoing call
		  @REQUIREMENTS:GID-2535698
When HMI OP1 presses DA key ROLE1(as OP1)
Then HMI OP1 has the DA key ROLE1(as OP1) in state out_ringing

Scenario: Op1 client receives the incoming call
Then HMI OP1 has the call queue item Role1-OP1 in state out_ringing

Scenario: Op1 client verifies the outgoing call
Then HMI OP1 has the call queue item OP1-Role1 in state ringing

Scenario: Op3 client receives the incoming call
Then HMI OP3 has the call queue item OP1-Role1 in state ringing

Scenario: Caller clears outgoing call
When HMI OP1 presses DA key ROLE1(as OP1)