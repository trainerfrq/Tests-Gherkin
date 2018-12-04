Narrative:
As an operator
I want to establish and receive different types of call
So I can verify that each section shall display the calls in the order of their arrival time into these Call Queue sections.

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key            | source                 | target                 | callType |
| OP1-OP2        | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1        | sip:222222@example.com | sip:111111@example.com | DA/IDA   |
| OP3-OP1        | sip:op3@example.com    | sip:111111@example.com | DA/IDA   |
| OP1-OP3        | sip:111111@example.com | sip:op3@example.com    | DA/IDA   |
| SipContact-OP1 | <<SIP_PHONE2>>         | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

Scenario: Op3 initiates a priority call
When HMI OP3 initiates a priority call on DA key OP1(as OP3)
Then HMI OP1 has in the call queue the item OP3-OP1 with priority

Scenario: Op2 initiates another priority call
When HMI OP2 initiates a priority call on DA key OP1
Then HMI OP1 has in the call queue the item OP2-OP1 with priority

Scenario: Op1 verifies the order of the received call queue items in the priority section
		  @REQUIREMENTS:GID-3371932
Then HMI OP1 verifies that the call queue item OP2-OP1 has index 0 in the priority list
Then HMI OP1 verifies that the call queue item OP3-OP1 has index 1 in the priority list

Scenario: Op3 terminates the call
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op3 initiates a DA call
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP1 has the DA key OP3(as OP1) in state inc_initiated

Scenario: Op1 receives a SIP call
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Op1 verifies call queue sections
Then HMI OP1 has the call queue item SipContact-OP1 in the waiting list with label Madoline
Then HMI OP1 has the call queue item OP3-OP1 in the waiting list with label op3
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with label OP2 Physical

Scenario: Operator verifies the order of call queue items in the waiting section
		  @REQUIREMENTS:GID-3371932
Then HMI OP1 verifies that the call queue item SipContact-OP1 has index 0 in the waiting list
Then HMI OP1 verifies that the call queue item OP3-OP1 has index 1 in the waiting list

Scenario: Operator answers and puts on hold the active priority call
When HMI OP1 presses DA key OP2(as OP1)
When HMI OP1 puts on hold the active call

Scenario: Operator answers and puts on hold the Sip call
Then HMI OP1 accepts the call queue item SipContact-OP1
When HMI OP1 puts on hold the active call

Scenario: Operator answers and initiates transfer the DA call
Then HMI OP1 accepts the call queue item OP3-OP1
When HMI OP1 initiates a transfer on the active call

Scenario: Operator verifies the order of call queue items in the hold section
		  @REQUIREMENTS:GID-3371932
Then HMI OP1 verifies that the call queue item OP3-OP1 has index 0 in the hold list
Then HMI OP1 verifies that the call queue item SipContact-OP1 has index 1 in the hold list
Then HMI OP1 verifies that the call queue item OP2-OP1 has index 2 in the hold list

Scenario: Operator retrieves from hold and terminates all calls
Then HMI OP1 retrieves from hold the call queue item OP2-OP1
Then HMI OP1 terminates the call queue item OP2-OP1
Then HMI OP1 retrieves from hold the call queue item OP3-OP1
Then HMI OP1 terminates the call queue item OP3-OP1
Then HMI OP1 retrieves from hold the call queue item SipContact-OP1
Then HMI OP1 terminates the call queue item SipContact-OP1

Scenario: Verify call is terminated for all operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed
