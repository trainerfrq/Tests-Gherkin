Meta:
@TEST_CASE_VERSION: V29
@TEST_CASE_NAME: DisplayedDateANDTimeFormat
@TEST_CASE_DESCRIPTION: 
As an operator having a HMI machine working properly
I want to check the date and the time in Notification Display bar and Status Display
So I can verify that the Date and Time are the same with the system's ones and in the expected format
@TEST_CASE_PRECONDITION:
System date and time is UTC date and time of the zone where the CWP1 is found

MISSION_1 layout:
* Layout settings:
                  - time format - HH:mm:ss
                  - date format - dd-MM-YYYY
                  - show clock - true
                  - show date - false
* Status widget settings:
                  - show clock - false
                  - show date - true

MISSION_2 layout:
* Layout settings:
                  - time format - HH:mm:ss
                  - date format - dd-MM-YYYY
                  - show clock - true
                  - show date - true
* Status widget settings:
                  - show clock - true
                  - show date - true

MISSION_4 layout:
* Layout settings:
                  - time format - HH:mm
                  - date format - yyyy.MM.dd
                  - show clock - false
                  - show date - true
* Status widget settings:
                  - show clock - true
                  - show date - false
On CWP1 the HMI is working properly with mission MISSION_1_NAME activated.
Missions chosen at mission change are: MISSION_2_NAME, MISSION_4_NAME
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed if the system is able to display the Date and Time as configured
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
@TEST_STEP_REACTION: Time format in the Notification Display bar is HH:mm:ss
@TEST_STEP_REF: [CATS-REF: KxSP]
Then HMI OP1 has NOTIFICATION DISPLAY with the expected time format <<timeFormat>>

Scenario: 3. Op1 checks Notification Display bar time is the same with the system time
Meta:
@TEST_STEP_ACTION: Op1 checks Notification Display bar time is the same with the system time
@TEST_STEP_REACTION: The system time is the same with the time in the Notification Display bar
@TEST_STEP_REF: [CATS-REF: UT1c]
Then HMI OP1 verifies that the system time and the one displayed on NOTIFICATION DISPLAY with format <<timeFormat>> are the same

Scenario: 4. Op1 checks Status Display date format
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display date format
@TEST_STEP_REACTION: Date format in Status Display is dd-MM-YYYY
@TEST_STEP_REF: [CATS-REF: LLdY]
Then HMI OP1 has DISPLAY STATUS with the expected date format <<dateFormat>>

Scenario: 5. Op1 checks Status Display date is the same with the system's one
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display date is the same with the system's one
@TEST_STEP_REACTION: System's date is the same with Status Display's one
@TEST_STEP_REF: [CATS-REF: dvhf]
Then HMI OP1 verifies that the system date and the one displayed on DISPLAY STATUS with format <<dateFormat>> are the same

Scenario: 6. Op1 changes its mission to MISSION_2_NAME
Meta:
@TEST_STEP_ACTION: Op1 changes its mission to MISSION_2_NAME
@TEST_STEP_REACTION: The name of the current mission in the Status Display is: MISSION_2_NAME
@TEST_STEP_REF: [CATS-REF: ao3B]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds
Then HMI OP1 has in the DISPLAY STATUS 2 section mission the assigned mission <<MISSION_2_NAME>>

Scenario: 7. Op1 checks the date and time format in Notification Display bar
Meta:
@TEST_STEP_ACTION: Op1 checks the date and time format in Notification Display bar
@TEST_STEP_REACTION: Time format in the Notification Display bar is HH:mm:ss and date format in the Notification Display bar is dd-MM-YYYY
@TEST_STEP_REF: [CATS-REF: FJr2]
Then HMI OP1 has NOTIFICATION DISPLAY with the expected time format <<timeFormat>>
Then HMI OP1 has NOTIFICATION DISPLAY with the expected date format <<dateFormat>>

Scenario: 8. Op1 checks Notification Display bar's date and time are the same with the system ones
Meta:
@TEST_STEP_ACTION: Op1 checks Notification Display bar's date and time are the same with the system ones
@TEST_STEP_REACTION: The system date and time are the same with the ones in the Notification Display bar
@TEST_STEP_REF: [CATS-REF: 4lQc]
Then HMI OP1 verifies that the system time and the one displayed on NOTIFICATION DISPLAY with format <<timeFormat>> are the same
Then HMI OP1 verifies that the system date and the one displayed on NOTIFICATION DISPLAY with format <<dateFormat>> are the same

Scenario: 9. Op1 checks Status Display date and time format
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display date and time format
@TEST_STEP_REACTION: Time format in Status Display is HH:mm:ss and date format in Status Display is dd-MM-YYYY
@TEST_STEP_REF: [CATS-REF: YK3g]
Then HMI OP1 has DISPLAY STATUS 2 with the expected time format <<timeFormat>>
Then HMI OP1 has DISPLAY STATUS 2 with the expected date format <<dateFormat>>

Scenario: 10. Op1 checks Status Display date and time are the same with the system's ones
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display date and time are the same with the system's ones
@TEST_STEP_REACTION: System's date and time are the same with Status Display's ones
@TEST_STEP_REF: [CATS-REF: aTGC]
Then HMI OP1 verifies that the system time and the one displayed on DISPLAY STATUS 2 with format <<timeFormat>> are the same
Then HMI OP1 verifies that the system date and the one displayed on DISPLAY STATUS 2 with format <<dateFormat>> are the same

Scenario: 11. Op1 checks Notification Display bar's time and Status Display's time are the same
Meta:
@TEST_STEP_ACTION: Op1 checks Notification Display bar's time and Status Display's time are the same
@TEST_STEP_REACTION: Displayed time in Notification Display bar is the same with the one in Status Display
@TEST_STEP_REF: [CATS-REF: JS3x]
Then HMI OP1 verifies that time values from NOTIFICATION DISPLAY and from DISPLAY STATUS 2 are synchronized

Scenario: 12. Op1 changes its mission to MISSION_4_NAME
Meta:
@TEST_STEP_ACTION: Op1 changes its mission to MISSION_4_NAME
@TEST_STEP_REACTION: The name of the current mission in the Status Display is: MISSION_4_NAME
@TEST_STEP_REF: [CATS-REF: WpwQ]
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_4_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds
Then HMI OP1 has in the DISPLAY STATUS 4 section mission the assigned mission <<MISSION_4_NAME>>

Scenario: 13. Op1 checks the date format in Notification Display bar
Meta:
@TEST_STEP_ACTION: Op1 checks the date format in Notification Display bar
@TEST_STEP_REACTION: Date format in Notification Display bar is yyyy.MM.dd
@TEST_STEP_REF: [CATS-REF: 0WuV]
Then HMI OP1 has NOTIFICATION DISPLAY with the expected date format yyyy.MM.dd

Scenario: 14. Op1 checks Notification Display bar date is the same with the system's one
Meta:
@TEST_STEP_ACTION: Op1 checks Notification Display bar date is the same with the system's one
@TEST_STEP_REACTION: System's date is the same with Notification Display bar's one
@TEST_STEP_REF: [CATS-REF: 4tde]
Then HMI OP1 verifies that the system date and the one displayed on NOTIFICATION DISPLAY with format yyyy.MM.dd are the same

Scenario: 15. Op1 checks Status Display time format
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display time format
@TEST_STEP_REACTION: Time format in the Status Display is HH:mm
@TEST_STEP_REF: [CATS-REF: NkG8]
Then HMI OP1 has DISPLAY STATUS 4 with the expected time format HH:mm

Scenario: 16. Op1 checks Status Display time is the same with the system's one
Meta:
@TEST_STEP_ACTION: Op1 checks Status Display time is the same with the system's one
@TEST_STEP_REACTION: System's time is the same with Status Display's one
@TEST_STEP_REF: [CATS-REF: HsDv]
Then HMI OP1 verifies that the system time and the one displayed on DISPLAY STATUS 4 with format HH:mm are the same

Scenario: Clean-up
When HMI OP1 with layout <<LAYOUT_MISSION4>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>
