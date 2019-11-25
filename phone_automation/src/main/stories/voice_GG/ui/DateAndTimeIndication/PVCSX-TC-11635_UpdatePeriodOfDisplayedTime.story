Meta:
@TEST_CASE_VERSION: V7
@TEST_CASE_NAME: UpdatePeriodOfDisplayedTime
@TEST_CASE_DESCRIPTION: As an operator having a HMI machine working properlyI want to check the interface displayed timeSo I can verify that the displayed time is updated every second
@TEST_CASE_PRECONDITION: On CWP1 the HMI is working properly with mission MAN-NIGHT-TACT activated.
MAN-NIGHT-TACT settings: - notificationDisplay show time - true
                         - StatusDisplay show time - true
@TEST_CASE_PASS_FAIL_CRITERIA: The interface time is updated every second
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

Scenario: Autogenerated Scenario 1
Meta:
@TEST_STEP_ACTION: Op1 verifies Notification Display bar's time is the same with the system time
@TEST_STEP_REACTION: System time is the same with the time in the Notification Display bar
@TEST_STEP_REF: [CATS-REF: FIAB]
When HMI OP1 checks the time of system and NOTIFICATION DISPLAY with format hh:mm:ss

Scenario: Autogenerated Scenario 2
Meta:
@TEST_STEP_ACTION: Op1 checks that Notification Display bar's time is updated every second
@TEST_STEP_REACTION: Displayed time in Notification Display bar is modified every second
@TEST_STEP_REF: [CATS-REF: CZ3m]
When HMI OP1 checks NOTIFICATION DISPLAY time update

Scenario: Autogenerated Scenario 3
Meta:
@TEST_STEP_ACTION: Op1 verifies Status Display's time is the same with the system time
@TEST_STEP_REACTION: System time is the same with the time in the Display time
@TEST_STEP_REF: [CATS-REF: 6ASm]
When HMI OP1 checks the time of system and DISPLAY STATUS with format hh:mm:ss

Scenario: Autogenerated Scenario 4
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display's time is updated every second
@TEST_STEP_REACTION: Displayed time in Status Display is modified every second
@TEST_STEP_REF: [CATS-REF: ceVL]
When HMI OP1 checks DISPLAY STATUS time update

Scenario: Autogenerated Scenario 5
Meta:
@TEST_STEP_ACTION: Op1 verifies Notification Display bar's time and Status Display's time are the same
@TEST_STEP_REACTION: Displayed time in Notification Display bar is the same with the one in Status Display 
@TEST_STEP_REF: [CATS-REF: QV6N]
When HMI OP1 checks time synchronization between NOTIFICATION DISPLAY time and DISPLAY STATUS time
