Meta:
@TEST_CASE_VERSION: V8
@TEST_CASE_NAME: Performance SRS - Trunk Proxy Service Startup
@TEST_CASE_DESCRIPTION: This testcase verifies the startup performance of the Trunk Proxy Service.
@TEST_CASE_PRECONDITION: Trunk Proxy service has been deployed on the physical target hardware in a redundancy mode, so there are 2 instances running (one on DOCKERHOST-01 and one on DOCKERHOST-02) 
OP1 available
Legacy external phone available
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed when Trunk Proxy service is available and working properly after 15 seconds after the Trunk Proxy service was restarted.
@TEST_CASE_DEVICES_IN_USE: DOCKERHOST-01
DOCKERHOST-02
OP1 
Legacy external phone
@TEST_CASE_ID: PVCSX-TC-12414
@TEST_CASE_GLOBAL_ID: GID-5203686
@TEST_CASE_API_ID: 18127850

Scenario: Booking profiles
Given booked profiles:
| profile               | group   | host           | identifier |
| javafx                | hmi     | <<CLIENT1_IP>> | HMI OP1    |
| javafx                | hmi     | <<CLIENT2_IP>> | HMI OP2    |
| javafx                | hmi     | <<CLIENT3_IP>> | HMI OP3    |
| voip/<<systemName>>GW | gateway | <<CO3_IP>>     | GATEWAY    |

Scenario: Connect to deployment server
Given SSH connections:
| name        | remote-address       | remotePort | username | password  |
| dockerHost1 | <<OPVOICE_HOST1_IP>> | 22         | root     | !frqAdmin |
| dockerHost2 | <<OPVOICE_HOST2_IP>> | 22         | root     | !frqAdmin |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key   | profile | user-entity        | sip-uri     |
| Line0 | GATEWAY | 0001_slot=1_line=0 | <<GATEWAY>> |
And phones for SipContact are created

Scenario: Define call queue items
Given the call queue items:
| key             | source           | target | callType |
| OP1-LegacyPhone | 0001@example.com |        | DA/IDA   |

Scenario: 1. CWP-01: setup active call to legacy external phone
Meta:
@TEST_STEP_ACTION: CWP-01: setup active call to legacy external phone
@TEST_STEP_REACTION: Call established and 2-way audio available.
@TEST_STEP_REF: [CATS-REF: 9QGP]
Scenario: 1.1 Op1 calls legacy phone
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
When HMI OP1 selects call route selector: none
When HMI OP1 writes in phonebook text box the address: 0001@example.com
When HMI OP1 initiates a call from the phonebook

Scenario: 1.2 Call is initiated
Then HMI OP1 has the call queue item OP1-LegacyPhone in state out_ringing

Scenario: 1.3 Gateway answers call (in this way we validate that the call reached gateway)
When SipContact answers incoming calls

Scenario: 2. CWP-01 ends call
Meta:
@TEST_STEP_ACTION: CWP-01 ends call
@TEST_STEP_REACTION: CWP-01 has no calls
@TEST_STEP_REF: [CATS-REF: DNk3]
Scenario: 2.1 Gateway terminates call
When VoIP SipContact gets terminated

Scenario: 2.2 Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP1-LegacyPhone

Scenario: 2.3 Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 3. DOCKERHOST-01: from the docker CLI, stop Trunk Proxy Service instance 1
Meta:
@TEST_STEP_ACTION: DOCKERHOST-01: from the docker CLI, stop Trunk Proxy Service instance 1
@TEST_STEP_REACTION: Trunk Proxy Service instance 1 is no longer running on DOCKERHOST-01 (not listed with "docker ps" command)
@TEST_STEP_REF: [CATS-REF: Ki1F]
When SSH host dockerHost1 executes docker kill trunk-proxy-service-1
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' trunk-proxy-service-1 and the output contains exited

Scenario: 4. DOCKERHOST-02: from the docker CLI, stop Trunk Proxy Service instance 2
Meta:
@TEST_STEP_ACTION: DOCKERHOST-02: from the docker CLI, stop Trunk Proxy Service instance 2
@TEST_STEP_REACTION: Trunk Proxy Service instance 2 is no longer running on DOCKERHOST-02 (not listed with "docker ps" command).
@TEST_STEP_REF: [CATS-REF: jrfw]
When SSH host dockerHost2 executes docker kill trunk-proxy-service-2
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' trunk-proxy-service-2 and the output contains exited

Scenario: 5. DOCKERHOST-02: from the docker CLI, start Trunk Proxy Service instance 2
Meta:
@TEST_STEP_ACTION: DOCKERHOST-02: from the docker CLI, start Trunk Proxy Service instance 2
@TEST_STEP_REACTION: DOCKERHOST-02: Trunk Proxy Service instance 2 appears in list of active services (run "docker ps") within 15 sec.
@TEST_STEP_REF: [CATS-REF: F9Ew]
When SSH host dockerHost2 executes docker start trunk-proxy-service-2
Then waiting for 15 seconds
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' trunk-proxy-service-2 and the output contains running

Scenario: 6. CWP-01: within 15 sec., it is possible from CWP-03 to initiate a call to legacy external phone
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: CWP-01: within 15 sec., it is possible from CWP-03 to initiate a call to legacy external phone
@TEST_STEP_REF: [CATS-REF: NEHm]
Scenario: 6.1 Op1 calls legacy phone
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key PHONEBOOK
When HMI OP1 selects call route selector: none
When HMI OP1 writes in phonebook text box the address: 0001@example.com
When HMI OP1 initiates a call from the phonebook

Scenario: 6.2 Call is initiated
Then HMI OP1 has the call queue item OP1-LegacyPhone in state out_ringing

Scenario: 6.3 Gateway answers call (in this way we validate that the call reached gateway)
When SipContact answers incoming calls

Scenario: 7. DOCKERHOST-01: from the docker CLI, start Trunk Proxy Service instance 1.
Meta:
@TEST_STEP_ACTION: DOCKERHOST-01: from the docker CLI, start Trunk Proxy Service instance 1.
@TEST_STEP_REACTION: DOCKERHOST-01: Trunk Proxy Service instance 1 appears in list of active services (run "docker ps") within 15 sec.
@TEST_STEP_REF: [CATS-REF: cdSz]
When SSH host dockerHost1 executes docker start trunk-proxy-service-1
Then waiting for <<trunkProxyFailoverTime>> seconds
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' trunk-proxy-service-1 and the output contains running

Scenario: 8. CWP-01 ends call
Meta:
@TEST_STEP_ACTION: CWP-01 ends call
@TEST_STEP_REACTION: CWP-01 has no calls
@TEST_STEP_REF: [CATS-REF: YBXH]
Scenario: 8.1 Gateway terminates call
When VoIP SipContact gets terminated

Scenario: 8.2 Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP1-LegacyPhone

Scenario: 8.3 Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed



