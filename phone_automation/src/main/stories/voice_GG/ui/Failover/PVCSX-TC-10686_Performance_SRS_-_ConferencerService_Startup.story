Meta:
@TEST_CASE_VERSION: V5
@TEST_CASE_NAME: Performance SRS - ConferencerService Startup
@TEST_CASE_DESCRIPTION: This testcase verifies the startup performance of the ConferencerService.
@TEST_CASE_PRECONDITION: All 3020X voice services (maximum number of instances in line with the communication resource limits of the current release) have been deployed on the physical target hardware.
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed when the SRS performance requirements have been met on the physical target platform.
@TEST_CASE_DEVICES_IN_USE: 	DOCKERHOST-01	DOCKERHOST-02	OP1	OP2	OP3
@TEST_CASE_ID: PVCSX-TC-10686
@TEST_CASE_GLOBAL_ID: GID-4814419
@TEST_CASE_API_ID: 15010097

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

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
| OP1-OP2-CONF | <<OP2_URI>>           | <<OP1_URI>>      | CONF     |
| OP3-OP1-Conf | <<OP3_URI>>           | <<OP1_URI>>      | CONF     |
| OP1-OP2-Conf | <<OPVOICE1_CONF_URI>> | <<OP2_URI>>:5060 | CONF     |
| OP1-OP3-Conf | <<OPVOICE1_CONF_URI>> | <<OP3_URI>>:5060 | CONF     |

Scenario: 1. OP1: setup active call to OP2
Meta:
@TEST_STEP_ACTION: OP1: setup active call to OP2
@TEST_STEP_REACTION: Call established and 2-way audio available.
@TEST_STEP_REF: [CATS-REF: QYCt]
Scenario: 1.1 OP1 establishes an outgoing call
When HMI OP1 presses DA key OP2
Then HMI OP1 has the DA key OP2 in state out_ringing

Scenario: 1.2 OP2 client receives the incoming call and answers the call
Then HMI OP2 has the DA key OP1 in state inc_initiated
When HMI OP2 presses DA key OP1

Scenario: 1.3 Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 2. DOCKERHOST-01: from the docker CLI, stop ConferencerService instance
Meta:
@TEST_STEP_ACTION: DOCKERHOST-01: from the docker CLI, stop ConferencerService instance
@TEST_STEP_REACTION: ConferencerService instance is no longer running on DOCKERHOST-01 (not listed with "docker ps" command)
@TEST_STEP_REF: [CATS-REF: kwE4]
When SSH host dockerHost1 executes docker kill conferencer-service-1
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' conferencer-service-1 and the output contains exited

Scenario: 3. DOCKERHOST-02: from the docker CLI, stop ConferencerService instance
Meta:
@TEST_STEP_ACTION: DOCKERHOST-02: from the docker CLI, stop ConferencerService instance
@TEST_STEP_REACTION: ConferencerService instance is no longer running on DOCKERHOST-02 (not listed with "docker ps" command).
@TEST_STEP_REF: [CATS-REF: fdGO]
When SSH host dockerHost2 executes docker kill conferencer-service-2
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' conferencer-service-2 and the output contains exited

Scenario: 5. DOCKERHOST-02: from the docker CLI, start ConferencerService instance
Meta:
@TEST_STEP_ACTION: DOCKERHOST-02: from the docker CLI, start ConferencerService instance
@TEST_STEP_REACTION: DOCKERHOST-02: ConferencerService instance appears in list of active services (run "docker ps") within 30 sec.
@TEST_STEP_REF: [CATS-REF: ybPl]
When SSH host dockerHost2 executes docker start conferencer-service-2
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' conferencer-service-2 and the output contains running
Then wait for 30 seconds

Scenario: 6. OP1 initiates a conference call via the context menu on the active call button
Meta:
@TEST_STEP_ACTION: OP1 initiates a conference call via the context menu on the active call button
@TEST_STEP_REACTION: OP1, OP2 have an active conference
@TEST_STEP_REF: [CATS-REF: rxKi]
When HMI OP1 starts a conference using an existing active call
Then wait for 2 seconds
Then HMI OP1 has the call queue item OP1-OP2-CONF in state connected
Then HMI OP1 has the call queue item OP1-OP2-CONF in the active list with name label CONF
Then HMI OP1 has the call queue item OP1-OP2-CONF in the active list with info label 2 participants

Scenario: 7. DOCKERHOST-01: from the docker CLI, start ConferencerService instance
Meta:
@TEST_STEP_ACTION: DOCKERHOST-01: from the docker CLI, start ConferencerService instance
@TEST_STEP_REACTION: DOCKERHOST-01: ConferencerService instance appears in list of active services (run "docker ps") within 30 sec.
@TEST_STEP_REF: [CATS-REF: HDrU]
When SSH host dockerHost1 executes docker start conferencer-service-1
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' conferencer-service-1 and the output contains running

Scenario: 8. OP1 adds another participant to the conference
Meta: @TEST_STEP_ACTION: OP1 adds another participant to the conference
@TEST_STEP_REACTION: Conference between OP1, OP2 and OP3 is established latest after 1 second
@TEST_STEP_REF: [CATS-REF: jPqF]
When HMI OP1 presses DA key OP3

Scenario: 8.1 OP3 client receives the incoming call and answers the call
Then HMI OP3 has the call queue item OP1-OP3-Conf in state inc_initiated
Then HMI OP3 accepts the call queue item OP1-OP3-Conf

Scenario: 8.2 OP1 verifies conference state
Then HMI OP1 has the call queue item OP1-OP2-CONF in state connected
Then HMI OP1 has the call queue item OP1-OP2-CONF in the active list with name label CONF
Then HMI OP1 has the call queue item OP1-OP2-CONF in the active list with info label 3 participants

Scenario: 9. OP1 removes one participant and ends the conference
Meta: @TEST_STEP_ACTION: OP1 removes one participant and ends the conference
@TEST_STEP_REACTION: Conference is ended
@TEST_STEP_REF: [CATS-REF: uwU3]
When HMI OP1 opens the conference participants list using call queue item OP1-OP2-CONF
When HMI OP1 selects conference participant: 2
Then HMI OP1 verifies that remove conference participant button is enabled
Then HMI OP1 removes conference participant
Then HMI OP1 closes Conference list popup window
And waiting for 1 second

Scenario: 9.1 Conference is terminated for the OP1
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP3 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 1 calls

Scenario: 9.2 OP1 terminates the conference
Then HMI OP1 terminates the call queue item OP1-OP2-CONF
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done


