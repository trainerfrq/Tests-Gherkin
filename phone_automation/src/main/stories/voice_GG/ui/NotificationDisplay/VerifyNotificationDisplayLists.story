Narrative:
As a caller operator
I want to verify the Notification Display list
So I can verify what events and states happened on the system

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source   | target | callType |
| OP1-OP1 | 111111   |        | DA/IDA   |

Scenario: Cleanup events list
When HMI OP1 opens Notification Display list
When HMI OP1 selects tab event from notification display popup
When HMI OP1 clears the notification events from list
Then HMI OP1 verifies that Notification Display list Event has 0 items
Then HMI OP1 closes notification popup

Scenario: Operator tries a call to its own position
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
When HMI OP1 writes in phonebook text box the address: 111111
When HMI OP1 initiates a call from the phonebook

Scenario: Verify call is received and call status is failed
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has the call queue item OP1-OP1 in state out_failed
Then HMI OP1 has a notification that shows General failure for phone call to

Scenario: Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP1-OP1

Scenario: Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Operator opens Notification Display popup
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that popup notification is visible

Scenario: Operator verifies the size of state and events lists
		  @REQUIREMENTS: GID-3281816
Then HMI OP1 verifies that Notification Display list State has 0 items
When HMI OP1 selects tab event from notification display popup
Then HMI OP1 verifies that Notification Display list Event has 1 items

Scenario: Operator closes Notification Display popup
Then HMI OP1 closes notification popup
Then HMI OP1 verifies that popup notification is not visible

Scenario: Operator activates Call Forward
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLFORWARD
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in forwardOngoing state
When HMI OP1 presses DA key OP2
Then HMI OP1 with layout <<LAYOUT_MISSION1>> has the function key CALLFORWARD in active state
Then HMI OP1 has a notification that shows Call Forward to cj-gg-cat-cwp-2 is active

Scenario: Operator opens Notification Display popup
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that popup notification is visible

Scenario: Operator verifies the size of state and events lists
Then HMI OP1 verifies that Notification Display list State has 1 items
When HMI OP1 selects tab event from notification display popup
Then HMI OP1 verifies that Notification Display list Event has 1 items

Scenario: Operator clears the event list
		  @REQUIREMENTS: GID-4308969
When HMI OP1 clears the notification events from list
Then HMI OP1 verifies that Notification Display list Event has 0 items
When HMI OP1 selects tab state from notification display popup
Then HMI OP1 verifies that Notification Display list State has 1 items

Scenario: Operator deactivates Call Forward
When HMI OP1 deactivates call forward by pressing on the call queue info
Then HMI OP1 verifies that call queue info container is not visible

Scenario: Operator verifies the size of state list
Then HMI OP1 verifies that Notification Display list State has 0 items

Scenario: Operator closes Notification Display popup
Then HMI OP1 closes notification popup
Then HMI OP1 verifies that popup notification is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupUICallQueue.story,
			  voice_GG/ui/includes/@CleanupUIMission.story,
			  voice_GG/ui/includes/@CleanupUIFunctionKeys.story,
			  voice_GG/ui/includes/@CleanupUIWindows.story
Then waiting for 1 millisecond




