Narrative:
As an operator
I want to establish and receive different types of call
So I can verify that each Call Queue Item is in the right section

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
| IA-OP1-OP2     | sip:111111@example.com | sip:222222@example.com | IA       |
| IA-OP2-OP1     | sip:222222@example.com | sip:111111@example.com | IA       |
| SipContact-OP1 | <<SIP_PHONE2>>         | <<OPVOICE1_PHONE_URI>> | DA/IDA   |

Scenario: Operator establishes an outgoing IA call and verifies call queue section (active)
		  @REQUIREMENTS:GID-3371943
		  @REQUIREMENTS:GID-3490383
When HMI OP2 presses IA key IA - OP1
Then HMI OP2 has the call queue item IA-OP1-OP2 in the active list with label IA - OP1
Then HMI OP1 has the call queue item IA-OP2-OP1 in the active list with label OP2 Physical
Then HMI OP1 verifies that the call queue item IA-OP2-OP1 from the active list has call type IA

Scenario: Operator terminates the call
When HMI OP2 presses IA key IA - OP1
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Operator receives a priority call and verifies call queue section (priority)
		  @REQUIREMENTS:GID-3371933
		  @REQUIREMENTS:GID-3371931
When HMI OP2 initiates a priority call on DA key OP1
Then HMI OP1 has in the call queue the item OP2-OP1 with priority
Then HMI OP1 has the call queue item OP2-OP1 in the priority list with label OP2 Physical
Then HMI OP2 has the call queue item OP1-OP2 in the active list with label OP1
Then HMI OP1 verifies that the call queue item OP2-OP1 from the priority list has call type DA/IDA

Scenario: Operator receives another priority call and verifies call queue section (priority)
		  @REQUIREMENTS:GID-3371933
		  @REQUIREMENTS:GID-3371931
When HMI OP3 initiates a priority call on DA key OP1(as OP3)
Then HMI OP1 has in the call queue the item OP3-OP1 with priority
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with label op3
Then HMI OP3 has the call queue item OP1-OP3 in the active list with label OP1(as OP3)
Then HMI OP1 verifies that the call queue item OP3-OP1 from the priority list has call type DA/IDA

Scenario: Operator verifies the order of call queue items in the priority section
		  @REQUIREMENTS:GID-3371932
Then HMI OP1 verifies that the call queue item OP3-OP1 has index 0 in the priority list
Then HMI OP1 verifies that the call queue item OP2-OP1 has index 1 in the priority list

Scenario: Operator answers first incoming call
When HMI OP1 presses DA key OP2(as OP1)
Then HMI OP1 verifies that the call queue item OP2-OP1 was removed from the priority list
Then HMI OP1 has the call queue item OP2-OP1 in the active list with label OP2 Physical
Then HMI OP2 has the call queue item OP1-OP2 in the active list with label OP1
Then HMI OP1 has the call queue item OP3-OP1 in the priority list with label op3

Scenario: One of the callers terminates the call
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Operator receives a DA call and verifies call queue section (waiting)
When HMI OP3 presses DA key OP1(as OP3)
Then HMI OP3 has the DA key OP1(as OP3) in state out_ringing
Then HMI OP1 has the DA key OP3(as OP1) in state ringing
Then HMI OP3 has the call queue item OP1-OP3 in the active list with label OP1(as OP3)
Then HMI OP1 has the call queue item OP3-OP1 in the waiting list with label op3
Then HMI OP1 has the call queue item OP2-OP1 in the active list with label OP2 Physical
Then HMI OP1 verifies that the call queue item OP3-OP1 from the waiting list has call type DA/IDA

Scenario: Operator receives a SIP call
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds
Then HMI OP1 has the call queue item SipContact-OP1 in state ringing

Scenario: Operator puts the active call on hold and verifies call queue section (hold)
When HMI OP1 puts on hold the active call
Then HMI OP1 verifies that the call queue item OP2-OP1 was removed from the active list
Then HMI OP1 has the call queue item OP2-OP1 in the hold list with label OP2 Physical
Then HMI OP1 verifies that the call queue item OP2-OP1 from the hold list has call type DA/IDA

Scenario: Operator verifies the order of call queue items in the waiting section
		  @REQUIREMENTS:GID-3371932
Then HMI OP1 verifies that the call queue item SipContact-OP1 has index 0 in the waiting list
Then HMI OP1 verifies that the call queue item OP3-OP1 has index 1 in the waiting list

Scenario: Operator answers Sip call
Then HMI OP1 accepts the call queue item SipContact-OP1
Then HMI OP1 has the call queue item SipContact-OP1 in state connected
Then HMI OP1 has the call queue item SipContact-OP1 in the waiting list with label 12345

Scenario: Operator puts the Sip call on hold and verifies call queue section (hold)
When HMI OP1 puts on hold the active call
Then HMI OP1 verifies that the call queue item SipContact-OP1 was removed from the active list
Then HMI OP1 has the call queue item SipContact-OP1 in the hold list with label 12345
Then HMI OP1 verifies that the call queue item SipContact-OP1 from the hold list has call type DA/IDA

Scenario: Operator answers the DA call and verifies call queue section (active)
Then HMI OP1 accepts the call queue item OP3-OP1
Then HMI OP1 verifies that the call queue item OP3-OP1 was removed from the waiting list
Then HMI OP1 has the call queue item OP3-OP1 in the active list with label op3

Scenario: Operator initiates transfer for the active call
When HMI OP1 initiates a transfer on the active call
Then HMI OP1 verifies that the call queue item OP3-OP1 was removed from the active list
Then HMI OP1 has the call queue item OP3-OP1 in the hold list with label 12345

Scenario: Operator verifies the order of call queue items in the hold section
		  @REQUIREMENTS:GID-3371932
Then HMI OP1 verifies that the call queue item OP3-OP1 has index 0 in the hold list
Then HMI OP1 verifies that the call queue item SipContact-OP1 has index 1 in the hold list
Then HMI OP1 verifies that the call queue item OP2-OP1 has index 2 in the hold list

Scenario: Operator retrieves and terminates all calls
Then HMI OP1 retrieves from hold the call queue item OP2-OP1
Then HMI OP1 verifies that the call queue item OP2-OP1 was removed from the hold list
Then HMI OP1 has the call queue item OP2-OP1 in the active list with label OP2 Physical
Then HMI OP1 terminates the call queue item OP2-OP1
Then HMI OP1 retrieves from hold the call queue item OP3-OP1
Then HMI OP1 verifies that the call queue item OP3-OP1 was removed from the hold list
Then HMI OP1 has the call queue item OP3-OP1 in the active list with label op3
Then HMI OP1 terminates the call queue item OP3-OP1
Then HMI OP1 retrieves from hold the call queue item SipContact-OP1
Then HMI OP1 terminates the call queue item SipContact-OP1

Scenario: Verify call is terminated for all operators
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls
