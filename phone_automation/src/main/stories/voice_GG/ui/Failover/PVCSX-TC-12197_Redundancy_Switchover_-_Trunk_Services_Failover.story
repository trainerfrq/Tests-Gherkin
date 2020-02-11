Meta: @TEST_CASE_VERSION: V9
@TEST_CASE_NAME: Redundancy Switchover - Trunk Services Failover
@TEST_CASE_DESCRIPTION: This test case verifies the failover for the Trunk Location service and Trunk Proxy service works as expected (no interruption of any G/G calls for more than 1 second, either with call reestablishment or without)
@TEST_CASE_PRECONDITION:
- OP1 available
- Legacy external phone available- trunk-location-service on host server 1 and 2 available- trunk-proxy-service on host server 1 and 2 available
- trunk-proxy-service and trunk-location-service on host server 2 are restarted before doing the test. This will assure that the active instance of the services is the instance on host server 1.
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, when the system provides a switchover for the redundant G/G related services which results in:
- No interruption of any G/G calls for more than 1 second, either with call reestablishment or without
@TEST_CASE_DEVICES_IN_USE: OP1 and an external phone
@TEST_CASE_ID: PVCSX-TC-12197
@TEST_CASE_GLOBAL_ID: GID-5187170
@TEST_CASE_API_ID: 17965211

GivenStories: voice_GG/includes/KillStartTrunkProxyOnDockerHost1.story,
voice_GG/includes/KillStartTrunkLocationOnDockerHost1.story

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
| key             | source               | target | callType |
| OP1-LegacyPhone | sip:0001@example.com |        | DA/IDA   |

Scenario: 1. System Technician: Restart trunk-proxy-service on host 1 and OP1 calls legacy external phone after 1 second
Meta: @TEST_STEP_ACTION: System Technician: Restart trunk-proxy-service on host 1 and OP1 calls legacy external phone after 1 second
@TEST_STEP_REACTION: trunk-proxy-service on host 1 restarts. Call is established and OP1 has a ringing indication.
@TEST_STEP_REF: [CATS-REF: 7UOO]

Scenario: 1.1 Kill Trunk Proxy service on docker host 1
When SSH host dockerHost1 executes docker kill trunk-proxy-service-1

Scenario: 1.2 Start Trunk Proxy service on docker host 1
When SSH host dockerHost1 executes docker start trunk-proxy-service-1
Then waiting for <<trunkProxyFailoverTime>> seconds
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' trunk-proxy-service-1 and the output contains running

Scenario: 1.3 Op1 calls legacy phone
When HMI OP1 presses DA key LegacyPhone

Scenario: 1.4 Call is initiated
Then HMI OP1 has the call queue item OP1-LegacyPhone in state out_ringing

Scenario: Gateway answers call (in this way we validate that the call reached gateway)
When SipContact answers incoming calls

Scenario: 2. OP1 ends ringing call.

Meta: @TEST_STEP_ACTION: OP1 ends ringing call.
@TEST_STEP_REACTION: OP1 has no calls.
@TEST_STEP_REF: [CATS-REF: 0t1W]

Scenario: 2.1 Gateway terminates call
When VoIP SipContact gets terminated

Scenario: 2.2 Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP1-LegacyPhone

Scenario: 2.3 Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then waiting for 30 seconds

Scenario: 3. System Technician: Restart trunk-proxy-service on host 2 and OP1 calls legacy external phone after 1 second
Meta: @TEST_STEP_ACTION: System Technician: Restart trunk-proxy-service on host 2 and OP1 calls legacy external phone after 1 second
@TEST_STEP_REACTION: trunk-proxy-service on host 2 restarts. Call is established and OP1 has a ringing indication.
@TEST_STEP_REF: [CATS-REF: nLA6]

Scenario: 3.1 Kill Trunk Proxy service on docker host 2
When SSH host dockerHost2 executes docker kill trunk-proxy-service-2

Scenario: 3.2 Start Trunk Proxy service on docker host 2
When SSH host dockerHost2 executes docker start trunk-proxy-service-2
Then waiting for <<trunkProxyFailoverTime>> seconds
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' trunk-proxy-service-2 and the output contains running

Scenario: 3.3 Op1 calls legacy phone
When HMI OP1 presses DA key LegacyPhone

Scenario: 3.4 Call is initiated
Then HMI OP1 has the call queue item OP1-LegacyPhone in state out_ringing

Scenario: 3.5 Gateway answers call (in this way we validate that the call reached gateway)
When SipContact answers incoming calls

Scenario: 4. OP1 ends ringing call.

Meta: @TEST_STEP_ACTION: OP1 ends ringing call.
@TEST_STEP_REACTION: OP1 has no calls.
@TEST_STEP_REF: [CATS-REF: sCXb]

Scenario: 4.1 Gateway terminates call
When VoIP SipContact gets terminated

Scenario: 4.2 Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP1-LegacyPhone

Scenario: 4.3 Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then waiting for 30 seconds

Scenario: 5. System Technician: Restart trunk-location-service on host 1 and OP1 calls legacy external phone after 1 second
Meta: @TEST_STEP_ACTION: System Technician: Restart trunk-location-service on host 1 and OP1 calls legacy external phone after 1 second
@TEST_STEP_REACTION: trunk-location-service on host 1 restarts. Call is established and OP1 has a ringing indication.
@TEST_STEP_REF: [CATS-REF: rp3r]

Scenario: 5.1 Kill Trunk Location service on docker host 1
When SSH host dockerHost1 executes docker kill trunk-location-service-1

Scenario: 5.2 Start Trunk Location service on docker host 1
When SSH host dockerHost1 executes docker start trunk-location-service-1
Then waiting for <<trunkLocationFailoverTime>> seconds
When SSH host dockerHost1 executes docker inspect -f '{{.State.Status}}' trunk-location-service-1 and the output contains running

Scenario: 5.3 Op1 calls legacy phone
When HMI OP1 presses DA key LegacyPhone

Scenario: 5.4 Call is initiated
Then HMI OP1 has the call queue item OP1-LegacyPhone in state out_ringing

Scenario: 5.5 Gateway answers call (in this way we validate that the call reached gateway)
When SipContact answers incoming calls

Scenario: 6. OP1 ends ringing call.

Meta: @TEST_STEP_ACTION: OP1 ends ringing call.
@TEST_STEP_REACTION: OP1 has no calls.
@TEST_STEP_REF: [CATS-REF: LRNh]

Scenario: 6.1 Gateway terminates call
When VoIP SipContact gets terminated

Scenario: 6.2 Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP1-LegacyPhone

Scenario: 6.3 Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls
Then waiting for 30 seconds

Scenario: 7. System Technician: Restart trunk-location-service on host 2 and OP1 calls legacy external phone after 1 second
Meta: @TEST_STEP_ACTION: System Technician: Restart trunk-location-service on host 2 and OP1 calls legacy external phone after 1 second
@TEST_STEP_REACTION: trunk-location-service on host 2 restarts. Call is established and OP1 has a ringing indication.
@TEST_STEP_REF: [CATS-REF: NyL9]

Scenario: 7.1 Kill Trunk Location service on docker host 2
When SSH host dockerHost2 executes docker kill trunk-location-service-2

Scenario: 7.2 Start Trunk Location service on docker host 2
When SSH host dockerHost2 executes docker start trunk-location-service-2
Then waiting for <<trunkLocationFailoverTime>> seconds
When SSH host dockerHost2 executes docker inspect -f '{{.State.Status}}' trunk-location-service-2 and the output contains running

Scenario: 7.3 Op1 calls legacy phone
When HMI OP1 presses DA key LegacyPhone

Scenario: 7.4 Call is initiated
Then HMI OP1 has the call queue item OP1-LegacyPhone in state out_ringing

Scenario: 7.5 Gateway answers call (in this way we validate that the call reached gateway)
When SipContact answers incoming calls

Scenario: 8. OP1 ends ringing call.

Meta: @TEST_STEP_ACTION: OP1 ends ringing call.
@TEST_STEP_REACTION: OP1 has no calls
@TEST_STEP_REF: [CATS-REF: Fxgc]

Scenario: 8.1 Sip Contact terminates call
When VoIP SipContact gets terminated

Scenario: 8.2 Caller clears outgoing call
Then HMI OP1 terminates the call queue item OP1-LegacyPhone

Scenario: 8.3 Call is terminated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: Remove phone
When SipContact is removed