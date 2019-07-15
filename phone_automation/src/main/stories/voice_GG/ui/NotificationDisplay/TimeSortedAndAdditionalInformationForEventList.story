Narrative:
As an operator having notifications in the event list
I want to check the list
So I can verify that events are displayed sorted by date and time and additional information is correctly displayed

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |


Scenario: Define notification entries
Given the following notification entries:
| key    | severity | notificationText                  |
| entry2 | Error    | General failure for phone call to |
| entry1 | Error    | General failure for phone call to |


Scenario: Caller establishes an outgoing IA call
When HMI OP2 with layout lower-west-exec-layout selects grid tab 2
When HMI OP2 presses IA key IA - OP2

Scenario: Verify call is received and call status is failed
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the IA key IA - OP2 in state out_failed
Then HMI OP2 has a notification that shows General failure for phone call to

Scenario: Caller clears outgoing call
When HMI OP2 presses IA key IA - OP2

Scenario: Caller establishes an outgoing IA call
When HMI OP2 presses IA key IA - OP2

Scenario: Verify call is received and call status is failed
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the IA key IA - OP2 in state out_failed
Then HMI OP2 has a notification that shows General failure for phone call to

Scenario: Caller clears outgoing call
When HMI OP2 presses IA key IA - OP2

Scenario: Op2 opens Notification Display popup
When HMI OP2 opens Notification Display list
Then HMI OP2 verifies that popup notification is visible

Scenario: Op2 verifies the size of events list
		  @REQUIREMENTS: GID-3281816
When HMI OP2 selects tab event from notification display popup
Then HMI OP2 verifies that Notification Display list Event has 2 items

Scenario: Op2 verifies the events list is time sorted
Then HMI OP2 using format <<dateFormat>> verifies that Notification Display list Event is time-sorted

Scenario: Operator verifies the events in list have the expected text and severity
Then HMI OP2 verifies that entry1 from list Event has the expected text and severity
Then HMI OP2 verifies that entry2 from list Event has the expected text and severity

Scenario: Op2 closes Notification Display popup
Then HMI OP2 closes notification popup
Then HMI OP2 verifies that popup notification is not visible

Scenario: Cleanup - always select first tab
When HMI OP2 with layout lower-west-exec-layout selects grid tab 1
