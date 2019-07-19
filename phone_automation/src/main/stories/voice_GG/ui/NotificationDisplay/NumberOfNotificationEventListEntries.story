Narrative:
As an operator
I want to establish 101 failed call
So I can check that the notification event list supports up to 100 entries

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Operator opens Notification Display popup and clears the event list
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that popup notification is visible
When HMI OP1 selects tab event from notification display popup
When HMI OP1 clears the notification events from list
Then HMI OP1 verifies that Notification Display list Event has 0 items

Scenario: Operator closes the Notification popup
Then HMI OP1 closes notification popup

Scenario: Caller establishes 100 out failed calls
When HMI OP1 presses for 200 times the DA key OP1

Scenario: Verify call is terminated for both operators
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Operator opens Notification Display popup and verifies the Event list
		  @REQUIREMENTS: GID-3281817
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that popup notification is visible
When HMI OP1 selects tab event from notification display popup
Then HMI OP1 verifies that Notification Display list Event has 100 items

Scenario: Operator closes the Notification popup
Then HMI OP1 closes notification popup

Scenario: Operator establishes the 101st failed call
When HMI OP1 presses for 2 times the DA key OP1

Scenario: Call is terminated also for caller
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Operator opens Notification Display popup and verifies the Event list
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that popup notification is visible
When HMI OP1 selects tab event from notification display popup
Then HMI OP1 verifies that Notification Display list Event has 100 items

Scenario: Operator closes the Notification popup
Then HMI OP1 closes notification popup





