Meta: @TEST_CASE_VERSION: V3
@TEST_CASE_NAME: Redundancy Switchover - G/G Services Failover
@TEST_CASE_DESCRIPTION:
@TEST_CASE_PRECONDITION:
- OP1-OP3 available
- phone-routing-service on host server 1 and 2 available
- conference-service on host server 1 and server 2 available
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, when the system provides a switchover for the redundant G/G related services which results in:
- No interruption of any G/G calls for more than 1 second, either with call reestablishment or without
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-9986
@TEST_CASE_GLOBAL_ID: GID-4782356
@TEST_CASE_API_ID: 15010028

GivenStories: voice_GG/includes/KillStartPhoneRoutingOnDockerHost1.story,
voice_GG/includes/KillStartConferencerOnDockerHost1.story

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

Scenario: Connect to deployment server
Given SSH connections:
| name        | remote-address       | remotePort | username | password  |
| dockerHost1 | <<OPVOICE_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2 | <<OPVOICE_HOST2_IP>> | 22         | root     | !frqAdmin |

Scenario: Define call queue items
Given the call queue items:
| key          | source                | target           | callType |
| OP1-OP2      | <<OP1_URI>>           | <<OP2_URI>>      | DA/IDA   |
| OP2-OP1      | <<OP2_URI>>           | <<OP1_URI>>      | DA/IDA   |
| OP1-OP2-CONF | <<OP1_URI>>           | <<OP2_URI>>      | CONF     |
| OP3-OP2-CONF | <<OP3_URI>>           | <<OP2_URI>>      | CONF     |
| OP2-OP1-Conf | <<OPVOICE2_CONF_URI>> | <<OP1_URI>>:5060 | CONF     |
| OP2-OP3-Conf | <<OPVOICE2_CONF_URI>> | <<OP3_URI>>:5060 | CONF     |

Scenario: 1. OP1: Set up an active conference with OP2
Meta: @TEST_STEP_ACTION: OP1: Set up an active conference with OP2
@TEST_STEP_REACTION: OP1, OP2 have an active conference
@TEST_STEP_REF: [CATS-REF: urln]

Scenario: 1.1 OP2 establishes an outgoing call
When HMI OP2 presses DA key OP1
Then HMI OP2 has the DA key OP1 in state out_ringing

Scenario: 1.2 OP1 client receives the incoming call and answers the call
Then HMI OP1 has the DA key OP2 in state inc_initiated
When HMI OP1 presses DA key OP2

Scenario: 1.3 Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 1.4 OP2 starts a conference using an existing active call
When HMI OP2 starts a conference using an existing active call
Then wait for 2 seconds
Then HMI OP2 has the call queue item OP1-OP2-CONF in state connected
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with info label 2 participants

Scenario: 2. System Technician: Restart phone-routing-service on host 1 and try to add OP3 to the conference between OP1 and OP2 latest after 1 second
Meta: @TEST_STEP_ACTION: System Technician: Restart phone-routing-service on host 1 and try to add OP3 to the conference between OP1 and OP2 latest after 1 second
@TEST_STEP_REACTION: phone-routing-service on host 1 restarts
@TEST_STEP_REF: [CATS-REF: 6Dan]

Scenario: 2.1 Kill Phone Routing service on docker host 1
When SSH host dockerHost1 executes docker kill phone-routing-service-1

Scenario: 2.2 Start Phone Routing service on docker host 1
When SSH host dockerHost1 executes docker start phone-routing-service-1
Then waiting for <<phoneRoutingFailoverTime>> seconds

Scenario: 2.3 OP2 adds another participant to the conference
When HMI OP2 presses DA key OP3

Scenario: 3. Conference between OP1, OP2 and OP3 is established latest after 1 second
Meta: @TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Conference between OP1, OP2 and OP3 is established latest after 1 second
@TEST_STEP_REF: [CATS-REF: jPqF]

Scenario: 3.1 OP3 client receives the incoming call and answers the call
Then HMI OP3 verify (via POST request) that call queue has status RINGING
When HMI OP3 answers (via POST request) CONF call by clicking on the queue
!-- Then HMI OP3 has the call queue item OP2-OP3-Conf in state inc_initiated
!-- Then HMI OP3 accepts the call queue item OP2-OP3-Conf

Scenario: 3.2 OP2 verifies conference state
Then HMI OP2 has the call queue item OP1-OP2-CONF in state connected
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with name label CONF
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with info label 3 participants

Scenario: 4. Wait until phone-routing-service on host 1 is up and running again
Meta: @TEST_STEP_ACTION: Wait until phone-routing-service on host A is up and running again
@TEST_STEP_REACTION: phone-routing-service on host A is up and running again
@TEST_STEP_REF: [CATS-REF: fsi2]
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' phone-routing-service-1 and the output contains running

Scenario: 5. System Technician: Restart phone-routing-service on host 2 and try to remove OP1 from the conference latest after 1 second
Meta: @TEST_STEP_ACTION: System Technician: Restart phone-routing-service on host 2 and try to remove OP1 from the conference latest after 1 second
@TEST_STEP_REACTION: phone-routing-service on host 2 restarts
@TEST_STEP_REF: [CATS-REF: nw2y]

Scenario: 5.1 Kill Phone Routing service on docker host 2
When SSH host dockerHost2 executes docker kill phone-routing-service-2

Scenario: 5.2 Start Phone Routing service on docker host 2
When SSH host dockerHost2 executes docker start phone-routing-service-2
Then waiting for <<phoneRoutingFailoverTime>> seconds

Scenario: 5.3 OP2 removes one participant from conference participants list
When HMI OP2 opens the conference participants list
When HMI OP2 selects conference participant: 0
Then HMI OP2 verifies that remove conference participant button is enabled
Then HMI OP2 removes conference participant
And waiting for 1 second

Scenario: 6. Conference between OP1 and OP3 is still running, but OP1 is no longer part of the conference
Meta: @TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Conference between OP1 and OP3 is still running, but OP1 is no longer part of the conference
@TEST_STEP_REF: [CATS-REF: O58C]
Then HMI OP2 verifies that conference participants list contains 2 participants
Then HMI OP2 verifies in the list that conference participant on position 2 has status connected
Then HMI OP2 verifies in the list that conference participant on position 2 has name <<OP3_NAME>>

Scenario: 6.1 Call is terminated for the removed participant
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 6.2 Op2 closes conference participants list
Then HMI OP2 closes Conference list popup window

Scenario: 6.3 Op2 verifies that conference is correctly signalized on the call queue
Then HMI OP2 has the call queue item OP1-OP2-CONF in the active list with info label 2 participants

Scenario: 7. Wait until phone-routing-service on host 2 is up and running again
Meta: @TEST_STEP_ACTION: Wait until phone-routing-service on host 2 is up and running again
@TEST_STEP_REACTION: phone-routing-service on host 2 is up and running again
@TEST_STEP_REF: [CATS-REF: TA3u]
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' phone-routing-service-2 and the output contains running
Then wait for 30 seconds

Scenario: 8. System Technician: Restart conference-service on host 1
Meta: @TEST_STEP_ACTION: System Technician: Restart conference-service on host 1
@TEST_STEP_REACTION: conference-service on host 1 restarts and conference is terminated
@TEST_STEP_REF: [CATS-REF: PuY0]

Scenario: 8.1 Kill Conferencer service on docker host 1
When SSH host dockerHost1 executes docker kill conferencer-service-1

Scenario: 8.2 Start Conferencer service on docker host 1
When SSH host dockerHost1 executes docker start conferencer-service-1
Then waiting for <<conferencerFailoverTime>> seconds

Scenario: 9. OP2 and OP3 leave the conference
Meta: @TEST_STEP_ACTION: OP2 and OP3 leave the conference (as audio is no longer available on the conference)
@TEST_STEP_REACTION: Conference is terminated for both participants
@TEST_STEP_REF: [CATS-REF: Ar8U]
When HMI OP2 opens the conference participants list
Then HMI OP2 leaves conference

Scenario: 9.1 Call is terminated initiator, but not for the participant
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 9.2 OP3 ends conference
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 10. OP2 reestablishes the conference with OP3
Meta: @TEST_STEP_ACTION: OP2 reestablishes the conference with OP3
@TEST_STEP_REACTION: Conference between OP3 and OP2 is reestablished
@TEST_STEP_REF: [CATS-REF: 9s83]
When HMI OP2 presses DA key OP3
When HMI OP3 presses DA key OP2
When HMI OP2 starts a conference using an existing active call
Then wait for 2 seconds
Then HMI OP2 has the call queue item OP3-OP2-CONF in state connected
Then HMI OP2 has the call queue item OP3-OP2-CONF in the active list with name label CONF
Then HMI OP2 has the call queue item OP3-OP2-CONF in the active list with info label 2 participants

Scenario: 11. OP2 adds OP1 to the conference
Meta: @TEST_STEP_ACTION: OP2 adds OP1 to the conference
@TEST_STEP_REACTION: OP1 is added to the conference
@TEST_STEP_REF: [CATS-REF: A83g]
When HMI OP2 presses DA key OP1

Scenario: 11.1 OP1 client receives the incoming call and answers the call
Then HMI OP1 verify (via POST request) that call queue has status RINGING
When HMI OP1 answers (via POST request) CONF call by clicking on the queue
!-- Then HMI OP1 has the call queue item OP2-OP1-Conf in state inc_initiated
!-- Then HMI OP1 accepts the call queue item OP2-OP1-Conf
Then wait for 1 second

Scenario: 11.2 OP2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP3_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OP1_NAME>>
Then HMI OP2 closes Conference list popup window

Scenario: 12. Wait until conference-service on host 1 is up and running again
Meta: @TEST_STEP_ACTION: Wait until conference-service on host 1 is up and running again
@TEST_STEP_REACTION: conference-service on host 1 is up and running again
@TEST_STEP_REF: [CATS-REF: JQHs]
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' conferencer-service-1 and the output contains running

Scenario: 13. System Technician: Restart conference-service on host 2 and try to reestablish the conference between OP3 and OP2 latest after 1 second
Meta: @TEST_STEP_ACTION: System Technician: Restart conference-service on host 2 and try to reestablish the conference between OP3 and OP2 latest after 1 second
@TEST_STEP_REACTION: conference-service on host 2 restarts and conference is terminated
@TEST_STEP_REF: [CATS-REF: 5erw]

Scenario: 13.1 Kill Conferencer service on docker host 2
When SSH host dockerHost2 executes docker kill conferencer-service-2

Scenario: 13.2 Start Conferencer service on docker host 2
When SSH host dockerHost2 executes docker start conferencer-service-2
Then waiting for <<conferencerFailoverTime>> seconds

Scenario: 14. OP2 leaves the conference
Meta: @TEST_STEP_ACTION: OP2 leaves the conference (as audio is no longer available on the conference)
@TEST_STEP_REACTION: Conference is terminated for OP2, but is not terminated for OP1 and OP3
@TEST_STEP_REF: [CATS-REF: aluG]
When HMI OP2 opens the conference participants list using call queue item OP3-OP2-CONF
Then HMI OP2 leaves conference

Scenario: 14.1 Conference is terminated for the initiator
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: 15. OP2 reestablishes the conference with OP3
Meta: @TEST_STEP_ACTION: OP2 reestablishes the conference with OP3
@TEST_STEP_REACTION: Conference between OP3 and OP2 is reestablish
@TEST_STEP_REF: [CATS-REF: rnLs]
When HMI OP2 presses DA key OP3
When HMI OP3 presses DA key OP2
When HMI OP2 starts a conference using an existing active call
Then wait for 2 seconds
Then HMI OP2 has the call queue item OP3-OP2-CONF in state connected
Then HMI OP2 has the call queue item OP3-OP2-CONF in the active list with name label CONF
Then HMI OP2 has the call queue item OP3-OP2-CONF in the active list with info label 2 participants

Scenario: 16. OP2 adds OP1 to the conference
Meta: @TEST_STEP_ACTION: OP2 adds OP1 to the conference
@TEST_STEP_REACTION: OP1 is added to the conference
@TEST_STEP_REF: [CATS-REF: zwi1]
When HMI OP2 presses DA key OP1

Scenario: 16.1 OP1 client receives the incoming call and answers the call
Then HMI OP1 verifies (via POST request) that there are 2 calls in the call queue with status: RINGING, ESTABLISHED
When HMI OP1 answers (via POST request) CONF call by clicking on the queue
!-- Then HMI OP1 has the call queue item OP2-OP1-Conf in state inc_initiated
!-- Then HMI OP1 accepts the call queue item OP2-OP1-Conf

Scenario: 16.2 OP2 verifies conference participants list
When HMI OP2 opens the conference participants list
Then HMI OP2 verifies that conference participants list contains 3 participants
Then HMI OP2 verifies in the list that conference participant on position 1 has status connected
Then HMI OP2 verifies in the list that conference participant on position 1 has name <<OP3_NAME>>
Then HMI OP2 verifies in the list that conference participant on position 3 has status connected
Then HMI OP2 verifies in the list that conference participant on position 3 has name <<OP1_NAME>>
Then HMI OP2 closes Conference list popup window

Scenario: 17. Wait until conference-service on host 2 is up and running again
Meta: @TEST_STEP_ACTION: Wait until conference-service on host 2 is up and running again
@TEST_STEP_REACTION: conference-service on host 2 is up and running again
@TEST_STEP_REF: [CATS-REF: V5ZO]
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' conferencer-service-2 and the output contains running

Scenario: 18. OP2 removes one participant and ends the conference
Meta: @TEST_STEP_ACTION: OP2 removes one participant and ends the conference
@TEST_STEP_REACTION: Conference is ended
@TEST_STEP_REF: [CATS-REF: eweQ]
When HMI OP2 opens the conference participants list using call queue item OP3-OP2-CONF
When HMI OP2 selects conference participant: 2
Then HMI OP2 verifies that remove conference participant button is enabled
Then HMI OP2 removes conference participant
Then HMI OP2 closes Conference list popup window
And waiting for 1 second

Scenario: 18.1 Conference is terminated for the OP1
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 18.2 OP2 terminates the conference
Then HMI OP2 terminates the call queue item OP3-OP2-CONF
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done


