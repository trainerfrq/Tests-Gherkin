Narrative:
As a conference participant in an active conference
I want to receive a DA call
So I can verify that if I answer the DA call I will automatically leave the conference

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Define call queue items
Given the call queue items:
| key            | source                 | target                   | callType |
| OP1-OP2        | sip:111111@example.com | sip:222222@example.com   | DA/IDA   |
| OP2-OP1        | sip:222222@example.com | sip:111111@example.com   | DA/IDA   |
| OP1-OP2-Conf   | sip:111111@example.com | sip:222222@example.com   | CONF     |
| OP2-OP1-Conf   | <<OPVOICE2_CONF_URI>>  | sip:111111@example.com   | DA/IDA   |
| OP2-OP3-Conf   | <<OPVOICE2_CONF_URI>>  | sip:op3@example.com:5060 | DA/IDA   |
| SipContact-OP1 | <<SIP_PHONE2>>         | <<OPVOICE1_PHONE_URI>>   | DA/IDA   |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Op2 establishes an outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Op1 client receives the incoming call and answers the call
Then HMI OP1 has the DA key OP2(as OP1) in state inc_initiated
When HMI OP1 presses DA key OP2(as OP1)

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op2 starts a conference using an existing active call
When HMI OP2 starts a conference using an existing active call
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label OP1
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 1 more participant
Then HMI OP2 has a notification that shows Conference call active

Scenario: Op1 call state verification
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected

Scenario: Op2 adds another participant to the conference
When HMI OP2 presses DA key OP3

Scenario: Op3 client receives the incoming call and answers the call
Then HMI OP3 has the call queue item OP2-OP3-Conf in state inc_initiated
Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name sip:op3@example.com

Scenario: Sip phone calls Op1
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Op1 receives the incoming call
Then HMI OP1 has the call queue item SipContact-OP1 in state inc_initiated
Then HMI OP1 has the call queue item SipContact-OP1 in the waiting list with name label Madoline
Then HMI OP1 has the call queue item OP2-OP1-Conf in state connected
Then HMI OP1 has in the call queue a number of 2 calls

Scenario: Op1 accepts call
		  @REQUIREMENTS:GID-2878006
Then HMI OP1 accepts the call queue item SipContact-OP1
Then HMI OP1 has the call queue item SipContact-OP1 in state connected
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: Op2 verifies conference participants list
		  @REQUIREMENTS:GID-3229804
Then HMI OP2 verifies that conference participants list contains 2 participants
!-- Then HMI OP2 verifies in the list that conference participant on position 1 has status disconnected
!-- TODO enable step when story QXVP-8656 is implemented
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name sip:op3@example.com

Scenario: Op2 leaves the conference
Then HMI OP2 leaves conference
Then HMI OP2 has the DA key OP3 in state terminated
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Call is terminated also for the left participant
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Sip phone clears calls
When SipContact terminates calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed


