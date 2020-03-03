Meta:
@TEST_CASE_VERSION: V18
@TEST_CASE_NAME: UpdatePeriodOfDisplayedTime
@TEST_CASE_DESCRIPTION: As an operator having a HMI machine working properly I want to check the interface displayed time So I can verify that the displayed time is updated every second
@TEST_CASE_PRECONDITION:
System date and time is UTC date and time of the zone where the CWP1 is found
MISSION_2 layout:
* Layout settings:
                        - time format - HH:mm:ss
                        - date format - dd-MM-YYYY
                        - show clock - true
                        - show date - true
* Status widget settings:
                        - show clock - true
                        - show date - true

On CWP1 the HMI is working properly with mission MISSION_2_NAME activated.
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

Scenario: Op1 changes its mission to MISSION_2_NAME
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds
Then HMI OP1 has in the DISPLAY STATUS 2 section mission the assigned mission <<MISSION_2_NAME>>

Scenario: 1. Op1 verifies Notification Display bar's time is the same with the system time
Meta:
@TEST_STEP_ACTION: Op1 verifies Notification Display bar's time is the same with the system time
@TEST_STEP_REACTION: System time is the same with the time in the Notification Display bar
@TEST_STEP_REF: [CATS-REF: FIAB]
Then HMI OP1 verifies that the system time and the one displayed on NOTIFICATION DISPLAY with format <<timeFormat>> are the same

Scenario: 2. Op1 checks that Notification Display bar's time is updated every second
Meta:
@TEST_STEP_ACTION: Op1 checks that Notification Display bar's time is updated every second
@TEST_STEP_REACTION: Displayed time in Notification Display bar is modified every second
@TEST_STEP_REF: [CATS-REF: CZ3m]
Then HMI OP1 verifies that time displayed on NOTIFICATION DISPLAY is updated

Scenario: 3. Op1 verifies Status Display's time is the same with the system time
Meta:
@TEST_STEP_ACTION: Op1 verifies Status Display's time is the same with the system time
@TEST_STEP_REACTION: System time is the same with the time in the Display time
@TEST_STEP_REF: [CATS-REF: 6ASm]
Then HMI OP1 verifies that the system time and the one displayed on DISPLAY STATUS 2 with format <<timeFormat>> are the same

Scenario: 4. Op1 checks Status Display's time is updated every second
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display's time is updated every second
@TEST_STEP_REACTION: Displayed time in Status Display is modified every second
@TEST_STEP_REF: [CATS-REF: ceVL]
Then HMI OP1 verifies that time displayed on DISPLAY STATUS 2 is updated

Scenario: 5. Op1 verifies Notification Display bar's time and Status Display's time are the same
Meta:
@TEST_STEP_ACTION: Op1 verifies Notification Display bar's time and Status Display's time are the same
@TEST_STEP_REACTION: Displayed time in Notification Display bar is the same with the one in Status Display 
@TEST_STEP_REF: [CATS-REF: QV6N]
Then HMI OP1 verifies that time values from NOTIFICATION DISPLAY and from DISPLAY STATUS 2 are synchronized

Scenario: Clean-up
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>
