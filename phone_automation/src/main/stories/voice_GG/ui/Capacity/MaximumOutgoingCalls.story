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

Scenario: Caller clears call history list
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 clears Call History list
Then HMI OP1 verifies that call history list contains 0 entries
Then HMI OP1 closes Call History popup window

Scenario: Sip phone calls operator
When SipContact calls SIP URI <<OPVOICE1_PHONE_URI>>
Then waiting for 2 seconds

Scenario: Op1 verifies the number of incoming calls in the queue
Then HMI OP1 has in the call queue a number of 3 calls
Then HMI OP1 has in the waiting list a number of 3 calls
Then HMI OP1 has in the collapsed area a number of 13 calls

Scenario: Op1 answers the waiting calls
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

Scenario: Op1 terminates the active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: Op1 opens call history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 verifies that call history list contains 16 entries

Scenario: Op1 selects entry from history
When HMI OP1 selects call history list entry number: 0

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 selects call history list entry number: 1

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 selects call history list entry number: 3

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 selects call history list entry number: 5

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 1 time(s)
When HMI OP1 selects call history list entry number: 1

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 1 time(s)
When HMI OP1 selects call history list entry number: 3

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 1 time(s)
When HMI OP1 selects call history list entry number: 5

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 2 time(s)
When HMI OP1 selects call history list entry number: 1

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 2 time(s)
When HMI OP1 selects call history list entry number: 3

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 2 time(s)
When HMI OP1 selects call history list entry number: 5

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 3 time(s)
When HMI OP1 selects call history list entry number: 1

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 3 time(s)
When HMI OP1 selects call history list entry number: 3

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 3 time(s)
When HMI OP1 selects call history list entry number: 5

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 4 time(s)
When HMI OP1 selects call history list entry number: 3

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 4 time(s)
When HMI OP1 selects call history list entry number: 5

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 selects entry from history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
When HMI OP1 clicks on the scroll down button in call history for 5 time(s)
When HMI OP1 selects call history list entry number: 4

Scenario: Op1 does call from call history
When HMI OP1 initiates a call from the call history
Then HMI OP1 has in the active list a number of 1 calls

Scenario: Op1 terminates active call
Then HMI OP1 terminates item 1 from active call queue list

Scenario: Op1 opens call history
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 verifies that call history list contains 32 entries

Scenario: Op1 closes call history
Then HMI OP1 closes Call History popup window

Scenario: Remove phone
When SipContact is removed



