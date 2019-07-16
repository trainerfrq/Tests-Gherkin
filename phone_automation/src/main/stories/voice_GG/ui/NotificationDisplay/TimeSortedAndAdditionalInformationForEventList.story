Narrative:
As an operator having notifications in the event list
I want to check the list
So I can verify that events are displayed sorted by date and time and additional information is correctly displayed

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP3-OP2 | <<OP3_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |
| OP2-OP3 | <<OP2_URI>> | <<OP3_URI>> | DA/IDA   |

Scenario: Define notification entries
Given the following notification entries:
| entry  | severity | notificationText                  |
| entry5 | Warning  | Hold limit exceeded               |
| entry4 | Error    | General failure for phone call to |
| entry3 | Warning  | Hold limit exceeded               |
| entry2 | Error    | General failure for phone call to |
| entry1 | Warning  | Hold limit exceeded               |

Scenario: Op1 establishes an outgoing call
When HMI OP1 presses DA key OP2

Scenario: Op2 accepts incoming call
When HMI OP2 presses DA key OP1

Scenario: Verify call is connected
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op2 puts call on hold
When HMI OP2 puts on hold the active call

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP2

Scenario: Op2 accepts incoming call
When HMI OP2 presses DA key OP3

Scenario: Verify call is connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: Op2 puts call on hold
When HMI OP2 puts on hold the active call
Then HMI OP2 has a notification that shows Hold limit exceeded

Scenario: Op2 ends active call
When HMI OP2 presses DA key OP3

Scenario: Caller establishes an outgoing IA call
When HMI OP2 presses IA key IA - OP2

Scenario: Verify call is received and call status is failed
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the IA key IA - OP2 in state out_failed
Then HMI OP2 has a notification that shows General failure for phone call to

Scenario: Caller clears outgoing call
When HMI OP2 presses IA key IA - OP2

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP2

Scenario: Op2 accepts incoming call
When HMI OP2 presses DA key OP3

Scenario: Verify call is connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: Op2 puts call on hold
When HMI OP2 puts on hold the active call
Then HMI OP2 has a notification that shows Hold limit exceeded

Scenario: Op2 ends active call
When HMI OP2 presses DA key OP3

Scenario: Caller establishes an outgoing IA call
When HMI OP2 presses IA key IA - OP2

Scenario: Verify call is received and call status is failed
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the IA key IA - OP2 in state out_failed
Then HMI OP2 has a notification that shows General failure for phone call to

Scenario: Caller clears outgoing call
When HMI OP2 presses IA key IA - OP2

Scenario: Op3 establishes an outgoing call
When HMI OP3 presses DA key OP2

Scenario: Op2 accepts incoming call
When HMI OP2 presses DA key OP3

Scenario: Verify call is connected
Then HMI OP2 has the call queue item OP3-OP2 in state connected
Then HMI OP3 has the call queue item OP2-OP3 in state connected

Scenario: Op2 puts call on hold
When HMI OP2 puts on hold the active call
Then HMI OP2 has a notification that shows Hold limit exceeded

Scenario: Op2 ends active call
When HMI OP2 presses DA key OP3

Scenario: Op2 opens Notification Display popup
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that popup notification is visible

Scenario: Op2 verifies the size of events list
		  @REQUIREMENTS: GID-3281816
When HMI OP2 selects tab event from notification display popup
Then HMI OP2 verifies that Notification Display list Event has 5 items

Scenario: Op2 verifies the events list is time sorted
Then HMI OP2 using format <<dateFormat>> verifies that Notification Display list event is time-sorted

Scenario: Operator verifies the events in list have the expected text and severity
Then HMI OP2 verifies that entry1 from list event has the expected text and severity
Then HMI OP2 verifies that entry2 from list event has the expected text and severity
Then HMI OP2 verifies that entry3 from list event has the expected text and severity
Then HMI OP2 verifies that entry4 from list event has the expected text and severity
Then HMI OP2 verifies that entry5 from list event has the expected text and severity

Scenario: Op2 closes Notification Display popup
Then HMI OP1 closes notification popup
Then HMI OP1 verifies that popup notification is not visible
