Meta:
@TEST_CASE_VERSION: V6
@TEST_CASE_NAME: PanelCleanMode
@TEST_CASE_DESCRIPTION: As an operator that wants to clean the Touch Input Display I want to use the Clean Screen function So I can clean the screen in a safe mode
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: The test will pass when the usage of Clean Screen function is done successfully
@TEST_CASE_DEVICES_IN_USE: HMI on CWP3 has to be up and running
@TEST_CASE_ID: PVCSX-TC-11603
@TEST_CASE_GLOBAL_ID: GID-5091759
@TEST_CASE_API_ID: 16715523

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Autogenerated Scenario 1
Meta:
@TEST_STEP_ACTION: Op1 opens Settings window
@TEST_STEP_REACTION: Settings window is visible. Clean Screen button is available and enabled
@TEST_STEP_REF: [CATS-REF: ozkH]
When HMI OP3 with layout <<LAYOUT_MISSION3>> presses function key SETTINGS
Then HMI OP3 verifies that popup settings is visible
Then HMI OP3 verifies that the state of cleanPanelMode button is enabled state

Scenario: Autogenerated Scenario 2
Meta:
@TEST_STEP_ACTION: Op1 clicks on the Clean Screen button
@TEST_STEP_REACTION: Clean Screen is visible. 1, 2 and 3 buttons are visible. Button 1 is marked with yellow
@TEST_STEP_REF: [CATS-REF: XaG6]
When HMI OP3 clicks on cleanPanelMode button
Then HMI OP3 verifies that close panel button 1 is visible
Then HMI OP3 verifies that close panel button 2 is visible
Then HMI OP3 verifies that close panel button 3 is visible
Then HMI OP3 verifies that close panel button number 1 is marked yellow

Scenario: Autogenerated Scenario 3
Meta:
@TEST_STEP_ACTION: Op1 clicks on button 3
@TEST_STEP_REACTION: The screen is in the same state as in the step 3
@TEST_STEP_REF: [CATS-REF: uoEq]
When HMI OP3 clicks on close panel button number 3
Then HMI OP3 verifies that close panel button number 1 is marked yellow

Scenario: Autogenerated Scenario 4
Meta:
@TEST_STEP_ACTION: Op1 clicks on button 1
@TEST_STEP_REACTION: Button 1 is marked with green. Button 2 is marked with yellow
@TEST_STEP_REF: [CATS-REF: Pnxt]
When HMI OP3 clicks on close panel button number 1
Then HMI OP3 verifies that close panel button number 1 is marked green
Then HMI OP3 verifies that close panel button number 2 is marked yellow

Scenario: Autogenerated Scenario 5
Meta:
@TEST_STEP_ACTION: Op1 clicks on button 2
@TEST_STEP_REACTION: Button 2 will be marked with green.
@TEST_STEP_REF: [CATS-REF: 6ww8]
When HMI OP3 clicks on close panel button number 2
Then HMI OP3 verifies that close panel button number 1 is marked green
Then HMI OP3 verifies that close panel button number 2 is marked green
Then HMI OP3 verifies that close panel button number 3 is marked yellow

Scenario: Autogenerated Scenario 6
Meta:
@TEST_STEP_ACTION: Op1 clicks on button 3
@TEST_STEP_REACTION: The initial screen is visible for Op1. Settings window is not visible.
@TEST_STEP_REF: [CATS-REF: IzFi]
When HMI OP3 clicks on close panel button number 3
Then HMI OP3 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP3 verifies that popup settings is not visible

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
