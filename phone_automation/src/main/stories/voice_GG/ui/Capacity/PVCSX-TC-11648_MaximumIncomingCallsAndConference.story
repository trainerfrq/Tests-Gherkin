Meta:
@TEST_CASE_VERSION: V3
@TEST_CASE_NAME: MaximumIncomingCallsAndConference
@TEST_CASE_DESCRIPTION: As an operator having an active conference with 2 participantsI want to receive 16 incoming external callsSo I can verify that only 15 of them will be visible on the operator position
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when the operator has 1 active conference call and 15 incoming calls
@TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 16 external calls
@TEST_CASE_ID: PVCSX-TC-11648
@TEST_CASE_GLOBAL_ID: GID-5112026
@TEST_CASE_API_ID: 17055692

Scenario: Autogenerated Scenario 1
Meta:
@TEST_STEP_ACTION: Op2 calls Op1
@TEST_STEP_REACTION: Op1 answers the call
@TEST_STEP_REF: [CATS-REF: X25n]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 2
Meta:
@TEST_STEP_ACTION: Op1 starts a conference using the existing active call
@TEST_STEP_REACTION: Op1 has a conference with 2 participants
@TEST_STEP_REF: [CATS-REF: 30wW]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 3
Meta:
@TEST_STEP_ACTION: Op1 invites Op3 to the conference. 
@TEST_STEP_REACTION: Op3 receives conference call. 
@TEST_STEP_REF: [CATS-REF: HOhu]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 4
Meta:
@TEST_STEP_ACTION: Op3 answers conference call
@TEST_STEP_REACTION: Op1 has a n active conference with 3 participants
@TEST_STEP_REF: [CATS-REF: tpWe]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 5
Meta:
@TEST_STEP_ACTION: Have 16 external calls that call Op1
@TEST_STEP_REACTION: Op1 has 15 incoming calls and 1 active conference call
@TEST_STEP_REF: [CATS-REF: rAOg]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 6
Meta:
@TEST_STEP_ACTION: Op1 terminates conference call
@TEST_STEP_REACTION: Op1 has 15 incoming calls and 0 active calls
@TEST_STEP_REF: [CATS-REF: z74m]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 7
Meta:
@TEST_STEP_ACTION: Op2 calls Op1
@TEST_STEP_REACTION: Op1 answers the call
@TEST_STEP_REF: [CATS-REF: QCGZ]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 8
Meta:
@TEST_STEP_ACTION: Op1 starts a conference using the existing active call
@TEST_STEP_REACTION: Op1 has a conference with 2 participants. Op1 has 15 incoming calls
@TEST_STEP_REF: [CATS-REF: axKc]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 9
Meta:
@TEST_STEP_ACTION: Op1 terminates conference call
@TEST_STEP_REACTION: Op1 has 15 incoming calls and 0 active calls
@TEST_STEP_REF: [CATS-REF: Mx0X]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 10
Meta:
@TEST_STEP_ACTION: External source terminates all 15 incoming calls
@TEST_STEP_REACTION: Op1 has no calls in the call queue
@TEST_STEP_REF: [CATS-REF: MR4B]
!-- insert steps here!!!



