Meta:
@TEST_CASE_VERSION: V13
@TEST_CASE_NAME: UpdatePeriodOfDisplayedTime
@TEST_CASE_DESCRIPTION: As an operator having a HMI machine working properly I want to check the interface displayed time So I can verify that the displayed time is updated every second
@TEST_CASE_PRECONDITION: On CWP1 the HMI is working properly with mission MISSION_1_NAME activated.
MISSION_1_NAME settings: - notificationDisplay show time - true
                         - StatusDisplay show time - true
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if the interface time is updated every second
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-11635
@TEST_CASE_GLOBAL_ID: GID-5099665
@TEST_CASE_API_ID: 16892375

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: 1. Op1 verifies Notification Display bar's time is the same with the system time
Meta:
@TEST_STEP_ACTION: Op1 verifies Notification Display bar's time is the same with the system time
@TEST_STEP_REACTION: System time is the same with the time in the Notification Display bar
@TEST_STEP_REF: [CATS-REF: FIAB]
Then HMI OP1 checks the time of system and NOTIFICATION DISPLAY with format <<timeFormat>>

Scenario: 2. Op1 checks that Notification Display bar's time is updated every second
Meta:
@TEST_STEP_ACTION: Op1 checks that Notification Display bar's time is updated every second
@TEST_STEP_REACTION: Displayed time in Notification Display bar is modified every second
@TEST_STEP_REF: [CATS-REF: CZ3m]
Then HMI OP1 checks NOTIFICATION DISPLAY time update

Scenario: 3. Op1 verifies Status Display's time is the same with the system time
Meta:
@TEST_STEP_ACTION: Op1 verifies Status Display's time is the same with the system time
@TEST_STEP_REACTION: System time is the same with the time in the Display time
@TEST_STEP_REF: [CATS-REF: 6ASm]
Then HMI OP1 checks the time of system and DISPLAY STATUS with format <<timeFormat>>

Scenario: 4. Op1 checks Status Display's time is updated every second
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display's time is updated every second
@TEST_STEP_REACTION: Displayed time in Status Display is modified every second
@TEST_STEP_REF: [CATS-REF: ceVL]
Then HMI OP1 checks DISPLAY STATUS time update

Scenario: 5. Op1 verifies Notification Display bar's time and Status Display's time are the same
Meta:
@TEST_STEP_ACTION: Op1 verifies Notification Display bar's time and Status Display's time are the same
@TEST_STEP_REACTION: Displayed time in Notification Display bar is the same with the one in Status Display 
@TEST_STEP_REF: [CATS-REF: QV6N]
Then HMI OP1 checks time synchronization between notification NOTIFICATION DISPLAY time and status DISPLAY STATUS time
