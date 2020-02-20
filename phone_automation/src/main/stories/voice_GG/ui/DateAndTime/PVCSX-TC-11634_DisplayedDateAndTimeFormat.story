Meta:
@TEST_CASE_VERSION: V22
@TEST_CASE_NAME: DisplayedDateAndTimeFormat
@TEST_CASE_DESCRIPTION: As an operator having a HMI machine working properly I want to check the date and the time in Notification Display bar and Status Display So I can verify that the Date and Time are the same with the system's ones and in the expected format
@TEST_CASE_PRECONDITION: On CWP1 the HMI is working properly with mission MISSION_1_NAME activated.
MISSION_1_NAME settings: - notificationDisplay time format - hh:mm:ss
                         - notificationDisplay date format - dd-MM-YYYY
                         - notificationDisplay show time - true
                         - notificationDisplay show date - false

                         - StatusDisplay time format - hh:mm:ss
                         - StatusDisplay date format - dd-MM-YYYY
                         - StatusDisplay show time - true
                         - StatusDisplay show date - true

Mission chosen at mission change: MISSION_4_NAME

MISSION_4_NAME settings: - notificationDisplay time format - HH:mm:ss
                          - notificationDisplay date format - YYYY-MM-dd
                          - notificationDisplay show time - true
                          - notificationDisplay show date - true

                          - StatusDisplay time format - hh:mm:ss
                          - StatusDisplay date format - dd-MM-YYYY
                          - StatusDisplay show time - true
                          - StatusDisplay show date - true
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if Date and Time are in the desired formats
@TEST_CASE_DEVICES_IN_USE: 
@TEST_CASE_ID: PVCSX-TC-11634
@TEST_CASE_GLOBAL_ID: GID-5099430
@TEST_CASE_API_ID: 16889698

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: 1. Op1 verifies its mission displayed name
Meta:
@TEST_STEP_ACTION: Op1 verifies its mission displayed name
@TEST_STEP_REACTION: The name of the current mission in the Status Display is MISSION_1_NAME
@TEST_STEP_REF: [CATS-REF: zjzK]
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: 2. Op1 checks the time format in Notification Display bar
Meta:
@TEST_STEP_ACTION: Op1 checks the time format in Notification Display bar
@TEST_STEP_REACTION: Time format in the Notification Display bar is the desired one
@TEST_STEP_REF: [CATS-REF: KxSP]
Then HMI OP1 has NOTIFICATION DISPLAY with the expected time format <<timeFormat>>

Scenario: 3. Op1 checks Notification Display bar time is the same with the system time
Meta:
@TEST_STEP_ACTION: Op1 checks Notification Display bar time is the same with the system time
@TEST_STEP_REACTION: The system time is the same with the time in the Notification Display bar
@TEST_STEP_REF: [CATS-REF: UT1c]
Then HMI OP1 verifies that the system time and the one displayed on NOTIFICATION DISPLAY with format <<timeFormat>> are the same

Scenario: 4. Op1 checks Status Display date and time format
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display date and time format
@TEST_STEP_REACTION: Date and Time format in the Status Display are the desired ones
@TEST_STEP_REF: [CATS-REF: LLdY]
Then HMI OP1 has DISPLAY STATUS with the expected time format <<timeFormat>>
Then HMI OP1 has DISPLAY STATUS with the expected date format <<dateFormat>>

Scenario: 5. Op1 checks Status Display date and time are the same with the system's ones
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display date and time are the same with the system's ones
@TEST_STEP_REACTION: System's date and time are the same with Status Display's ones
@TEST_STEP_REF: [CATS-REF: dvhf]
Then HMI OP1 verifies that the system time and the one displayed on DISPLAY STATUS with format <<timeFormat>> are the same
Then HMI OP1 verifies that the system date and the one displayed on DISPLAY STATUS with format <<dateFormat>> are the same

Scenario: 6. Op1 checks Notification Display bar's time and Status Display's time are the same
Meta:
@TEST_STEP_ACTION: Op1 checks Notification Display bar's time and Status Display's time are the same
@TEST_STEP_REACTION: Displayed time in Notification Display bar is the same with the one in Status Display 
@TEST_STEP_REF: [CATS-REF: JS3x]
Then HMI OP1 verifies that time values from NOTIFICATION DISPLAY and from DISPLAY STATUS are synchronized

Scenario: 7. Op1 changes its mission
Meta:
@TEST_STEP_ACTION: Op1 changes its mission
@TEST_STEP_REACTION: The name of the current mission in the Status Display is: MISSION_4_NAME
@TEST_STEP_REF: [CATS-REF: WpwQ]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_4_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds
Then HMI OP1 has in the DISPLAY STATUS 4 section mission the assigned mission <<MISSION_4_NAME>>

Scenario: 8. Op1 checks the date and time format in Notification Display bar
Meta:
@TEST_STEP_ACTION: Op1 checks the date and time format in Notification Display bar
@TEST_STEP_REACTION: Date and time format in the Notification Display bar are the desired ones
@TEST_STEP_REF: [CATS-REF: 0WuV]
Then HMI OP1 has NOTIFICATION DISPLAY with the expected time format HH:mm:ss
Then HMI OP1 has NOTIFICATION DISPLAY with the expected date format dd-MM-yyyy

Scenario: 9. Op1 checks Notification Display bar date and time are the same with the system's ones
Meta:
@TEST_STEP_ACTION: Op1 checks Notification Display bar date and time are the same with the system's ones
@TEST_STEP_REACTION: System's date and time are the same with Notification Display bar's ones
@TEST_STEP_REF: [CATS-REF: 4tde]
Then HMI OP1 verifies that the system time and the one displayed on NOTIFICATION DISPLAY with format HH:mm:ss are the same
Then HMI OP1 verifies that the system date and the one displayed on NOTIFICATION DISPLAY with format dd-MM-yyyy are the same

Scenario: 10. Op1 checks Status Display date and time format
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display date and time format
@TEST_STEP_REACTION: Date and Time format in the Status Display are the desired ones
@TEST_STEP_REF: [CATS-REF: NkG8]
Then HMI OP1 has DISPLAY STATUS 4 with the expected time format <<timeFormat>>
Then HMI OP1 has DISPLAY STATUS 4 with the expected date format <<dateFormat>>

Scenario: 11. Op1 checks Status Display date and time are the same with the system's ones
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display date and time are the same with the system's ones
@TEST_STEP_REACTION: System's date and time are the same with Status Display's ones
@TEST_STEP_REF: [CATS-REF: HsDv]
Then HMI OP1 verifies that the system time and the one displayed on DISPLAY STATUS 4 with format <<timeFormat>> are the same
Then HMI OP1 verifies that the system date and the one displayed on DISPLAY STATUS 4 with format <<dateFormat>> are the same

Scenario: 12. Op1 checks Notification Display bar's time and Status Display's time are the same
Meta:
@TEST_STEP_ACTION: Op1 checks Notification Display bar's time and Status Display's time are the same
@TEST_STEP_REACTION: Displayed time in Notification Display bar is the same with the one in Status Display 
@TEST_STEP_REF: [CATS-REF: uBs8]
Then HMI OP1 verifies that time values from NOTIFICATION DISPLAY and from DISPLAY STATUS 4 are synchronized

Scenario: Clean-up
When HMI OP1 with layout <<LAYOUT_MISSION4>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>
