Narrative:
As an operator monitoring another operator position and an active conference
I want to add to the conference the monitored position
So I can verify that the monitored position can be part of the conference

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call source and API URI
When define values in story data:
| name    | value            |
| HMI OP1 | <<HMI1_API.URI>> |
| HMI OP2 | <<HMI2_API.URI>> |
| HMI OP3 | <<HMI3_API.URI>> |

Scenario: Define call queue items
Given the call queue items:
| key          | source                | target           | callType |
| OP1-OP2      | <<OP1_URI>>           | <<OP2_URI>>      | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>           | <<OP1_URI>>      | DA/IDA   |
| OP2-OP1-CONF | <<OP2_URI>>           | <<OP1_URI>>      | CONF     |
| OP1-OP2-Conf | <<OPVOICE1_CONF_URI>> | <<OP2_URI>>      | CONF     |
| OP1-OP3-Conf | <<OPVOICE1_CONF_URI>> | <<OP3_URI>>:5060 | CONF     |

Scenario: Op1 activates Monitoring to Op3
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING
When HMI OP1 presses DA key OP3

Scenario: Op1 has an indication that is monitoring Op3
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState

Scenario: Stop monitoring ongoing on the function key
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MONITORING

Scenario: Op2 establishes an outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: Op1 client receives the incoming call and answers the call
Then HMI OP1 has the DA key OP2 in state inc_initiated
When HMI OP1 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: Op1 starts a conference using an existing active call
		  @REQUIREMENTS:GID-4021244
		  @REQUIREMENTS:GID-3371944
When HMI OP1 starts a conference using an existing active call
And waiting for 1 second
Then HMI OP1 has the call queue item OP2-OP1-CONF in state connected
Then HMI OP1 has the call queue item OP2-OP1-CONF in the active list with name label CONF
Then HMI OP1 has the call queue item OP2-OP1-CONF in the active list with info label 2 participants

Scenario: Verify conference call notification
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Conference call active

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Op2 call state verification
Then HMI OP2 verify (via POST request) that call queue has status ESTABLISHED
Then HMI OP2 verify (via POST request) that call queue shows CONF
!-- Then HMI OP2 has the call queue item OP1-OP2-Conf in state connected
!-- Then HMI OP2 has the call queue item OP1-OP2-Conf in the active list with name label CONF

Scenario: Op1 adds another participant to the conference
		  @REQUIREMENTS:GID-2529024
When HMI OP1 presses DA key OP3

Scenario: Op1 verifies conference state
Then HMI OP1 has the call queue item OP2-OP1-CONF in state connected
Then HMI OP1 has the call queue item OP2-OP1-CONF in the active list with name label CONF
Then HMI OP1 has the call queue item OP2-OP1-CONF in the active list with info label 3 participants

Scenario: Verify conference call notification
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Conference call active

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: Op3 client receives the incoming call and answers the call
Then HMI OP3 verify (via POST request) that call queue has status RINGING
When HMI OP3 answers (via POST request) CONF call by clicking on the queue
!-- Then HMI OP3 has the call queue item OP1-OP3-Conf in state inc_initiated
!-- Then HMI OP3 accepts the call queue item OP1-OP3-Conf

Scenario: Op1 opens monitoring list
When HMI OP1 with layout <<LAYOUT_MISSION1>> opens monitoring list using function key MONITORING menu
Then HMI OP1 verifies that popup monitoring is visible

Scenario: Op1 verifies monitoring list entries
		  @REQUIREMENTS:GID-4968898
Then HMI OP1 verifies that monitoring list contains 1 entries
Then HMI OP1 verifies in the monitoring list that for entry 1 the first column has value ALL
Then HMI OP1 verifies in the monitoring list that for entry 1 the second column has value <<OP3_NAME>>

Scenario: Op1 closes monitoring popup
Then HMI OP1 closes monitoring popup

Scenario: Op1 verifies conference participants list
		  @REQUIREMENTS:GID-3229804
When HMI OP1 opens the conference participants list using call queue item OP2-OP1-CONF
Then HMI OP1 verifies that conference participants list contains 3 participants
Then HMI OP1 verifies in the list that conference participant on position 3 has status connected
Then HMI OP1 verifies in the list that conference participant on position 3 has name <<OP3_NAME>>

Scenario: Op2 leaves the conference
		  @REQUIREMENTS:GID-2529028
Then HMI OP1 leaves conference
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Op1 has an indication that is monitoring Op3
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState

Scenario: Call is not terminated for the left participants
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP2 has in the call queue a number of 1 calls

Scenario: Op3 terminates conference
When HMI OP3 terminates (via POST request) CONF call visible on call queue
!-- Then HMI OP3 terminates the call queue item OP1-OP3-Conf
Then waiting for 2 seconds

Scenario: Verify call is terminated also for both operators
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: Op1 has an indication that is monitoring Op3
Then HMI OP1 has the DA key OP3 with visible state monitoringActiveState

Scenario: Op1 terminates all monitoring calls
When HMI OP1 with layout <<LAYOUT_MISSION1>> terminates monitoring calls using function key MONITORING menu

Scenario: Op1 has no indication that is monitoring Op3
Then HMI OP1 has the DA key OP3 with not visible state monitoringActiveState

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
