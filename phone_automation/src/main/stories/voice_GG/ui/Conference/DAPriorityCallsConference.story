Narrative:
As an operator part of an active DA priority call
I want to start a conference
So I can add and/or remove participants to the call

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key          | source                 | target                   | callType |
| OP1-OP2      | sip:111111@example.com | sip:222222@example.com   | DA/IDA   |
| OP2-OP1      | sip:222222@example.com | sip:111111@example.com   | DA/IDA   |
| OP1-OP2-Conf | sip:111111@example.com | sip:222222@example.com   | CONF     |
| OP2-OP1-Conf | <<OPVOICE2_CONF_URI>>  | sip:111111@example.com   | DA/IDA   |
| OP2-OP3-Conf | <<OPVOICE2_CONF_URI>>  | sip:op3@example.com:5060 | DA/IDA   |

Scenario: Op2 establishes an outgoing priority call
When HMI OP2 initiates a priority call on DA key OP1
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

Scenario: Op2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 1 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com
Then HMI OP2 closes Conference list popup window

Scenario: Op2 adds another participant to the conference
		  @REQUIREMENTS:GID-2529024
When HMI OP2 presses DA key OP3

Scenario: Op3 client receives the incoming call
Then HMI OP3 has the call queue item OP2-OP3-Conf in state inc_initiated

Scenario: Op2 verifies conference state
Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label OP1
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 2 more participants
Then HMI OP2 has a notification that shows Conference call active

Scenario: Op2 verifies conference participants list
		  @REQUIREMENTS:GID-3229804
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 2 has status ringing
Then HMI OP2 verifies in the list that conference participant on position 2 has name sip:op3@example.com
Then HMI OP2 verifies that remove conference participant button is disabled
Then HMI OP2 verifies that terminate conference button is enabled

Scenario: Op3 client answers the call
Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: Op3 call state verification
Then HMI OP3 has the call queue item OP2-OP3-Conf in state connected

Scenario: Op2 verifies Op3 stat in the conference participants list
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected

Scenario: On Op2 position DA buttons of the participants are correctly signalized
Then HMI OP2 verifies that the DA key OP1 has the info label Conference
Then HMI OP2 verifies that the DA key OP3 has the info label Conference

Scenario: Op2 removes one participant from conference participants list
When HMI OP2 selects conference participant: 1
Then HMI OP2 verifies that remove conference participant button is enabled
Then HMI OP2 removes conference participant
Then HMI OP2 verifies that conference participants list contains 1 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name sip:111111@example.com

Scenario: Call is terminated for the removed participant
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Op2 verifies conference state
Then HMI OP2 has the DA key OP3 in state terminated
Then HMI OP2 verifies that the DA key OP1 has the info label Conference
Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with info label 1 more participant

Scenario: Op1 leaves the conference
Then HMI OP1 terminates the call queue item OP2-OP1-Conf
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Conference is terminated for the initiator also, because it was the only one left
Then HMI OP2 has in the call queue a number of 0 calls

