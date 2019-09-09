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
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Define notification entries
Given the following notification entries:
| key     | severity | notificationText                               |
| Entry_3 | error    | General failure for phone call to              |
| Entry_2 | info     | Call can not be accepted, TRANSFER mode active |
| Entry_1 | error    | General failure for phone call to              |

Scenario: Cleanup events list
When HMI OP2 opens Notification Display list
When HMI OP2 selects tab event from notification display popup
When HMI OP2 clears the notification events from list
Then HMI OP2 verifies that Notification Display list Event has 0 items
Then HMI OP2 closes notification popup

Scenario: Caller establishes an outgoing IA call
When HMI OP2 with layout lower-west-exec-layout selects grid tab 2
When HMI OP2 presses IA key IA - OP2

Scenario: Verify call is received and call status is failed
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has the IA key IA - OP2 in state out_failed
Then HMI OP2 has a notification that shows General failure for phone call to

Scenario: Caller clears outgoing call
When HMI OP2 presses IA key IA - OP2

Scenario: Caller establishes an outgoing DA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 1
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing
Then HMI OP2 has the call queue item OP1-OP2 in state out_ringing

Scenario: Callee accepts the incoming DA call
Then HMI OP1 has the call queue item OP2-OP1 in state inc_initiated
When HMI OP1 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Transferor initiates transfer
When HMI OP2 initiates a transfer on the active call

Scenario: Op3 establishes an outgoing DA call to Op2
When HMI OP3 presses DA key OP2
Then HMI OP3 has the DA key OP2 in state out_ringing

Scenario: Op2 attempts to answer the incoming DA call
When HMI OP2 presses DA key OP3
Then HMI OP2 has a notification that shows Call can not be accepted, TRANSFER mode active

Scenario: Op3 clears the outgoing DA call to Op2
When HMI OP3 presses DA key OP2

Scenario: Op1 clears the DA call with Op2
When HMI OP1 presses DA key OP2
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Caller establishes an outgoing IA call
When HMI OP2 with layout <<LAYOUT_MISSION2>> selects grid tab 2
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
Then wait for 3 seconds
Then HMI OP2 verifies that Notification Display list Event has 3 items

Scenario: Op2 verifies the events list is time sorted
Then HMI OP2 using format <<dateFormat>> verifies that Notification Display list Event is time-sorted

Scenario: Operator verifies the events in list have the expected text and severity
Then HMI OP2 verifies that Entry_1 from list Event has the expected text and severity
Then HMI OP2 verifies that Entry_2 from list Event has the expected text and severity
Then HMI OP2 verifies that Entry_3 from list Event has the expected text and severity

Scenario: Op2 clears the notification event list
When HMI OP2 clears the notification events from list

Scenario: Op2 closes Notification Display popup
Then HMI OP2 closes notification popup
Then HMI OP2 verifies that popup notification is not visible

Scenario: Cleanup - always select first tab
When HMI OP2 with layout lower-west-exec-layout selects grid tab 1

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond
