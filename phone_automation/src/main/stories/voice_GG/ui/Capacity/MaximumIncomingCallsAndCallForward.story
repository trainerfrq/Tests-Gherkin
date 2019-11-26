Narrative:
As an operator having 16 incoming external calls
I want to activate call forward
So I can verify that all other calls made towards my position will be forward to another operator position

Scenario: Booking profiles
Given booked profiles:
| profile | group          | host           | identifier |
| javafx  | hmi            | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi            | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi            | <<CLIENT3_IP>> | HMI OP3    |
| voip    | <<systemName>> | <<CO3_IP>>     | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key      | profile | user-entity | sip-uri   |
| Caller1  | VOIP    | 1           | <<SIP1>>  |
| Caller2  | VOIP    | 2           | <<SIP2>>  |
| Caller3  | VOIP    | 3           | <<SIP3>>  |
| Caller4  | VOIP    | 4           | <<SIP4>>  |
| Caller5  | VOIP    | 5           | <<SIP5>>  |
| Caller6  | VOIP    | 6           | <<SIP6>>  |
| Caller7  | VOIP    | 7           | <<SIP7>>  |
| Caller8  | VOIP    | 8           | <<SIP8>>  |
| Caller9  | VOIP    | 9           | <<SIP9>>  |
| Caller10 | VOIP    | 10          | <<SIP10>> |
| Caller11 | VOIP    | 11          | <<SIP11>> |
| Caller12 | VOIP    | 12          | <<SIP12>> |
| Caller13 | VOIP    | 13          | <<SIP13>> |
| Caller14 | VOIP    | 14          | <<SIP14>> |
| Caller15 | VOIP    | 15          | <<SIP15>> |
| Caller16 | VOIP    | 16          | <<SIP16>> |

Given phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key         | source                 | target                 | callType |
| OP1-OP2     | <<OP1_URI>>            | <<OP2_URI>>            | IA       |
| OP2-OP1     | <<OP2_URI>>            | <<OP1_URI>>            | IA       |

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: Op1 activates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD

Scenario: Op1 chooses Op2 as call forward target
When HMI OP1 presses DA key OP2
Then HMI OP1 verifies that call queue info container contains Target: <<OP2_NAME>>

Scenario: Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 14 calls

Scenario: Op3 establishes an outgoing call to Op1
When HMI OP3 presses DA key OP1
Then HMI OP3 has the DA key OP1 in state out_ringing

Scenario: Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 14 calls

Scenario: Call is automatically forwarded to Op2
Then HMI OP2 has the DA key OP3 in state inc_initiated

Scenario: Op3 client clears the phone call
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: Call is terminated also for Op2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 answers and terminates the 16 waiting calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 still has Call Forward active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state

Scenario: Op1 deactivates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Remove phone
When SipContact is removed



