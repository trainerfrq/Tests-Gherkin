Meta:
@TEST_CASE_VERSION: V3
@TEST_CASE_NAME: MaximumIncomingCallsAnswered
@TEST_CASE_DESCRIPTION: narrative:As an operator having 16 incoming external calls I want to answer each of the incoming call So I can verify that the call queue is adapted accordingly with my actions
@TEST_CASE_PRECONDITION:
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed when each call is answered and call queue is updated with each answer action
@TEST_CASE_DEVICES_IN_USE: CATS tool is used to simulate 16 external calls
@TEST_CASE_ID: PVCSX-TC-11644
@TEST_CASE_GLOBAL_ID: GID-5109361
@TEST_CASE_API_ID: 16974420

Scenario: Autogenerated Scenario 1
Meta:
@TEST_STEP_ACTION: Have 16 external calls that call Op1
@TEST_STEP_REACTION: Op1 has 16 incoming calls. 3 calls are visible in the waiting list and 13 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: phco]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 2
Meta:
@TEST_STEP_ACTION: Op1 answers one calls
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 3 calls are visible in the waiting call queue list and 12 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: aGUm]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 3
Meta:
@TEST_STEP_ACTION: Op1 terminates active call 
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 3 calls are visible in the waiting call queue list and 12 are in a collapsed area
@TEST_STEP_REF: [CATS-REF: NFCi]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 4
Meta:
@TEST_STEP_ACTION: Steps 2 and 3 are repeated for the next 10 calls
@TEST_STEP_REACTION: The call queue will be adapted accordingly: active call visible when answered, not visible when terminated, 3 calls visible in the waiting call queue list and calls shown in the collapsed area is decreasing by one with every answered call
@TEST_STEP_REF: [CATS-REF: yjsJ]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 5
Meta:
@TEST_STEP_ACTION: Op1 answers one call
@TEST_STEP_REACTION: In the call queue there are: 1 active call, 3 calls are visible in the waiting list and collapsed area is not visible anymore
@TEST_STEP_REF: [CATS-REF: wXi5]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 6
Meta:
@TEST_STEP_ACTION: Op1 terminates active call 
@TEST_STEP_REACTION: In the call queue there are: 0 active call, 3 calls are visible in the waiting list and collapsed area is not visible anymore
@TEST_STEP_REF: [CATS-REF: lLjw]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 7
Meta:
@TEST_STEP_ACTION: Steps 5 and 6 are repeated for the next 3 calls
@TEST_STEP_REACTION: The call queue will be adapted accordingly: active call visible when answered, not visible when terminated, calls visible in the waiting call queue list will be decreasing by one with every answered call
@TEST_STEP_REF: [CATS-REF: TUWs]
!-- insert steps here!!!



