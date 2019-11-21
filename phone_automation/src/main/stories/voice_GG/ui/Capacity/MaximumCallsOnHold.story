Narrative:
As a callee operator having an incoming call from a SIP contact
I want to have a matching entry for the caller SIP contact
So that I can verify that the telephone book entry display name will be displayed on the call queue item

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
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: Op1 puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: Op1 puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 2 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 2 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: Op1 puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 2 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 12 calls

Scenario: Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 2 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 11 calls

Scenario: Op1 puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 3 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 11 calls

Scenario: Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 3 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 10 calls

Scenario: Op1 puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 4 calls
Then HMI OP1 has in the call queue a number of 2 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 10 calls

Scenario: Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 4 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 9 calls

Scenario: Op1 puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the collapsed hold area a number of 4 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 1 calls
Then HMI OP1 has in the collapsed waiting area a number of 9 calls

Scenario: Op1 terminates the active call
Then HMI OP1 terminates item 1 from active call queue list
Then wait for 1 seconds

Scenario: Op1 answers and terminates the rest of the waiting calls
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
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 3 calls
Then HMI OP1 has in the collapsed hold area a number of 2 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: Op1 retrives from hold one call
Then HMI OP1 retrives from hold item 1 from hold call queue list

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the hold list a number of 4 calls
Then HMI OP1 has in the collapsed hold area a number of 0 calls
Then HMI OP1 has in the call queue a number of 5 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: Caller establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: Callee client receives the incoming call
Then HMI OP2 has the DA key OP1 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated

Scenario: Callee accepts incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Caller puts call on hold
When HMI OP1 puts on hold the active call

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 3 calls
Then HMI OP1 has in the collapsed hold area a number of 2 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: Sip phones are cleared
When SipContact terminates calls

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has in the waiting list a number of 0 calls

Scenario: Caller retrieves call from hold
Then HMI OP1 retrieves from hold the call queue item OP2-OP1

Scenario: Verify call is connected again
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Callee clears outgoing call
When HMI OP2 presses DA key OP1

Scenario: Remove phone
When SipContact is removed
