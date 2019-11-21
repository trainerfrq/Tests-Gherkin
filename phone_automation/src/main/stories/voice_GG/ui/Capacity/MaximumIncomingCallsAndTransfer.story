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
When HMI OP1 initiates a transfer on the active call

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: Verify answer call is not possible
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Call Transfer in progress
When HMI OP1 selects tab event from notification display popup
Then HMI OP1 verifies that list Event contains on position 0 text Call can not be accepted, TRANSFER mode active
When HMI OP1 selects tab state from notification display popup

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Op1 tries to initiates consultation call
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state terminated

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: Op1 retrives from hold one call
Then HMI OP1 retrives from hold item 1 from hold call queue list

Scenario: Op3 terminates call
Then HMI OP3 terminates item 1 from active call queue list

Scenario: Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 has in the call queue a number of 4 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 11 calls

Scenario: Op1 puts call on hold
When HMI OP1 initiates a transfer on the active call

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 1 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 2 calls
Then HMI OP1 has in the collapsed area a number of 12 calls

Scenario: Op1 answers one call
Then HMI OP1 answers item 1 from waiting call queue list

Scenario: Verify answer call is not possible
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Call Transfer in progress
When HMI OP1 selects tab event from notification display popup
Then HMI OP1 verifies that list Event contains on position 0 text Call can not be accepted, TRANSFER mode active
When HMI OP1 selects tab state from notification display popup

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Op1 initiates consultation call
When HMI OP1 presses DA key OP3
Then HMI OP1 has the DA key OP3 in state out_ringing

Scenario: Transfer target receives incoming call
Then HMI OP3 has the DA key OP1 in state inc_initiated

Scenario: Op1 finishes transfer
When HMI OP1 presses DA key OP3
Then wait for 2 seconds

Scenario: Op1 verifies the number of calls in the queue
Then HMI OP1 has in the active list a number of 0 calls
Then HMI OP1 has in the hold list a number of 0 calls
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 11 calls

Scenario: Op1 answers and terminates the rest of the waiting calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 answers item 1 from waiting call queue list
Then HMI OP1 has in the active list a number of 1 calls
Then HMI OP1 terminates item 1 from active call queue list

Scenario: Remove phone
When SipContact is removed
