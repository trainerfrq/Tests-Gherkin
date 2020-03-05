Meta:
@TEST_CASE_VERSION: V4
@TEST_CASE_NAME: Transfer after rejecting first consultation call
@TEST_CASE_DESCRIPTION: 
As an operator having an active call
I want to establish a consultation call that is rejected
AND then to establish another consultation call followed by the transfer
So I can verify that the second call is established and the transfer is done successfully
@TEST_CASE_PRECONDITION: 
- OP2 has a DA key for OP3 configured in layout
- OP3 has a DA key for OP1 configured in layout
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed if the transfer is done successfully even if the first transfer attempt was rejected
@TEST_CASE_DEVICES_IN_USE: OP1, OP2, OP3
@TEST_CASE_ID: PVCSX-TC-13039
@TEST_CASE_GLOBAL_ID: GID-5266316
@TEST_CASE_API_ID: 18553034

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source        | target        | callType |
| OP1-OP3 | <<OP1_URI>>   | <<OP3_URI>>   | DA/IDA   |
| OP3-OP1 | <<OP3_URI>>   | <<OP1_URI>>   | DA/IDA   |
| OP2-OP3 | <<OP2_URI>>   | <<OP3_URI>>   | DA/IDA   |
| OP3-OP2 | <<OP3_URI>>   | <<OP2_URI>>   | DA/IDA   |
| OP1-OP2 | <<OP1_URI>>   | <<OP2_URI>>   | DA/IDA   |
| OP2-OP1 | <<OP2_URI>>   | <<OP1_URI>>   | DA/IDA   |

Scenario: 1. OP2 establishes a call to OP3
Meta:
@TEST_STEP_ACTION: OP2 establishes a call to OP3
@TEST_STEP_REACTION: OP2 has an outgoing call to OP3
@TEST_STEP_REF: [CATS-REF: cC00]
When HMI OP2 presses DA key OP3
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has in the active list the call queue item OP3-OP2 with state out_ringing

Scenario: 1.1 OP3 receives the call
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP3 has a ringing call from OP2
@TEST_STEP_REF: [CATS-REF: YtYq]
Then HMI OP3 has in the call queue a number of 1 calls
Then HMI OP3 has in the waiting list the call queue item OP2-OP3 with state inc_initiated

Scenario: 1.2 Verifying call queue section
Then HMI OP2 has the call queue item OP3-OP2 in the active list with name label <<OP3_NAME>>
Then HMI OP3 has the call queue item OP2-OP3 in the waiting list with name label <<OP2_NAME>>

Scenario: 2. OP3 answers the call
Meta:
@TEST_STEP_ACTION: OP3 answers the call
@TEST_STEP_REACTION: The call is connected for both OP2 and OP3
@TEST_STEP_REF: [CATS-REF: 3zal]
When HMI OP3 presses DA key OP2
Then HMI OP2 has in the active list the call queue item OP3-OP2 with state connected
Then HMI OP3 has in the active list the call queue item OP2-OP3 with state connected

Scenario: 3. OP3 initiates the transfer
Meta:
@TEST_STEP_ACTION: OP3 initiates the transfer
@TEST_STEP_REACTION: OP3 has a call on hold
@TEST_STEP_REF: [CATS-REF: mrwy]
When HMI OP3 initiates a transfer on the active call

Scenario: 3.1 Verify calls are put on hold respectively held
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP2 has a call on held
@TEST_STEP_REF: [CATS-REF: 8xTa]
Then HMI OP3 has in the hold list the call queue item OP2-OP3 with state hold
Then HMI OP2 has in the active list the call queue item OP3-OP2 with state held

Scenario: 3.2 Verify call transfer is initiated
Then HMI OP3 has the call conditional flag set for call queue item OP2-OP3
Then HMI OP3 has the call queue item OP2-OP3 in the hold list with info label XFR Hold

Scenario: 4. OP3 establishes a consultation call to OP1
Meta:
@TEST_STEP_ACTION: OP3 establishes a consultation call to OP1
@TEST_STEP_REACTION: OP3 has a call on hold to OP2 and an outgoing call to OP1
@TEST_STEP_REF: [CATS-REF: srXi]
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 2 calls
Then HMI OP3 has in the hold list the call queue item OP2-OP3 with state hold
Then HMI OP3 has in the active list the call queue item OP1-OP3 with state out_ringing

Scenario: 4.1 Verifying OP2's call queue section
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP2 has a call on held from OP3
@TEST_STEP_REF: [CATS-REF: ICmb]
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has in the active list the call queue item OP3-OP2 with state held

Scenario: 4.2 Verifying OP1's call queue section
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1 has a ringing call from OP3
@TEST_STEP_REF: [CATS-REF: Ua4s]
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has in the waiting list the call queue item OP3-OP1 with state inc_initiated

Scenario: 5. OP1 rejects the call
Meta:
@TEST_STEP_ACTION: OP1 rejects the call
@TEST_STEP_REACTION: OP1 has no calls in queue
@TEST_STEP_REF: [CATS-REF: zeYo]
Then HMI OP1 rejects the waiting call queue item from waiting list
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 5.1 Verifying OP3's call queue section
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP3 has a busy call to OP1 and a hold call to OP2
@TEST_STEP_REF: [CATS-REF: P4TQ]
Then HMI OP3 has in the call queue a number of 2 calls
Then HMI OP3 has in the active list the call queue item OP1-OP3 with state out_failed
Then HMI OP3 has in the hold list the call queue item OP2-OP3 with state hold

Scenario: 5.2 OP3 cleans the failed call
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 1 calls

Scenario: 5.3 Verifying OP2's call queue section
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP2 has a call on held from OP3
@TEST_STEP_REF: [CATS-REF: ujsb]
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has in the active list the call queue item OP3-OP2 with state held

Scenario: 6. OP3 establishes a consultation call to OP1
Meta:
@TEST_STEP_ACTION: OP3 establishes a consultation call to OP1
@TEST_STEP_REACTION: OP3 has a call on hold to OP2 and an outgoing call to OP1
@TEST_STEP_REF: [CATS-REF: UF5e]
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 2 calls
Then HMI OP3 has in the hold list the call queue item OP2-OP3 with state hold
Then HMI OP3 has in the active list the call queue item OP1-OP3 with state out_ringing

Scenario: 6.1 Verifying OP2's call queue section
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP2 has a call on held from OP3
@TEST_STEP_REF: [CATS-REF: sXM1]
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has in the active list the call queue item OP3-OP2 with state held

Scenario: 6.2 Verifying OP1's call queue section
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1 has a ringing call from OP3
@TEST_STEP_REF: [CATS-REF: ot3E]
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has in the waiting list the call queue item OP3-OP1 with state inc_initiated

Scenario: 7. OP3 transfers the call to OP1
Meta:
@TEST_STEP_ACTION: OP3 transfers the call to OP1
@TEST_STEP_REACTION: OP3 has no calls in queue
@TEST_STEP_REF: [CATS-REF: hG49]
When HMI OP3 presses DA key OP1
Then HMI OP3 has in the call queue a number of 0 calls

Scenario: 7.1 Verifying OP2's calls queue section
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP2 has an outgoing call to OP1
@TEST_STEP_REF: [CATS-REF: FZoC]
Then HMI OP2 has in the call queue a number of 1 calls
Then HMI OP2 has in the active list the call queue item OP1-OP2 with state out_ringing

Scenario: 7.2 Verifying OP1's calls queue section
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: OP1 has a ringing call from OP2
@TEST_STEP_REF: [CATS-REF: Pk2g]
Then HMI OP1 has in the call queue a number of 1 calls
Then HMI OP1 has in the waiting list the call queue item OP2-OP1 with state inc_initiated

Scenario: 8. OP1 answers the call
Meta:
@TEST_STEP_ACTION: OP1 answers the call
@TEST_STEP_REACTION: The call is connected for both OP1 and OP2
@TEST_STEP_REF: [CATS-REF: H0hZ]
When HMI OP1 presses DA key OP2

Scenario: Verify call is connected for both operators
Then HMI OP1 has the call queue item OP2-OP1 in state connected
Then HMI OP2 has the call queue item OP1-OP2 in state connected

Scenario: 9. OP2 terminates the call
Meta:
@TEST_STEP_ACTION: OP2 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP1 and OP2
@TEST_STEP_REF: [CATS-REF: eBlN]
When HMI OP2 presses DA key OP1
Then HMI OP2 has in the call queue a number of 0 calls
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
