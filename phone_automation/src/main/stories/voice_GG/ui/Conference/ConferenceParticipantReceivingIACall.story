Narrative:
As a conference participant in an active conference
I want to receive an IA call
So I can verify that if is not a full duplex call I will not automatically leave the conference and I can also hear the IA call

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key            | source                 | target                 | callType |
| OP1-OP2        | sip:111111@example.com | sip:222222@example.com | DA/IDA   |
| OP2-OP1        | sip:222222@example.com | sip:111111@example.com | DA/IDA   |
| OP1-OP2-Conf   | sip:111111@example.com | sip:222222@example.com | CONF     |
| OP2-OP1-Conf   | <<OPVOICE2_CONF_URI>>  | sip:111111@example.com | DA/IDA   |
| SipContact-OP1 | <<SIP_PHONE2>>         | <<OPVOICE1_PHONE_URI>> | DA/IDA   |
| OP3-OP1        | sip:op3@example.com    | sip:111111@example.com | IA       |
| OP1-OP3        | sip:111111@example.com | sip:op3@example.com    | IA       |

Scenario: Op2 establishes an outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Op1 client receives the incoming call and answers the call
Then HMI OP1 has the DA key OP2(as OP1) in state inc_initiated
When HMI OP1 presses DA key OP2(as OP1)

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op2 starts a conference
		  @REQUIREMENTS:GID-4021244
When HMI OP2 starts a conference
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label OP1
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 1 more participant
Then HMI OP2 has a notification that shows Conference call active

Scenario: Op1 call state verification
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
!-- Then HMI OP1 verifies that the DA key OP2(as OP1) has the info label Conference

Scenario: Op2 adds a conference participant from phonebook
When HMI OP2 presses function key PHONEBOOK
When HMI OP2 selects call route selector: none
When HMI OP2 selects phonebook entry number: 2
Then HMI OP2 verifies that phone book text box displays text Madoline
When HMI OP2 initiates a call from the phonebook
When SipContact answers incoming calls

Scenario: Op3 establishes an outgoing IA call to Op1
When HMI OP3 presses IA key IA - OP1(as OP3)
Then HMI OP3 has the call queue item OP1-OP3 in state connected
Then HMI OP3 has the IA key IA - OP1(as OP3) in state connected

Scenario: Op1 receives incoming IA call
Then HMI OP1 click on call queue Elements list
Then HMI OP1 has in the collapsed area a number of 1 calls
Then HMI OP1 has the call queue item OP3-OP1 in state connected
Then HMI OP1 has the IA key IA - OP3(as OP1) in state connected
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected

Scenario: Op2 verifies conference participants list
		  @REQUIREMENTS:GID-3229804
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<SIP_PHONE2>>

Scenario: Op1 answers the IA call
When HMI OP1 presses IA key IA - OP3(as OP1)

Scenario: Verify call direction
Then HMI OP3 has the IA call queue item OP1-OP3 with audio direction duplex
Then HMI OP1 has the IA call queue item OP3-OP1 with audio direction duplex

Scenario: Op2 verifies conference participants list
		  @REQUIREMENTS:GID-2878006
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status disconnected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<SIP_PHONE2>>

Scenario: Op1 and Op3 clear IA call
When HMI OP3 presses IA key IA - OP1(as OP3)
When HMI OP1 presses IA key IA - OP3(as OP1)
Then HMI OP1 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Sip phone clears calls
When SipContact terminates calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed


