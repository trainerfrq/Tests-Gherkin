Meta:
@TEST_CASE_VERSION: V15
@TEST_CASE_NAME: Role - Configuration Maximum number of roles (50)
@TEST_CASE_DESCRIPTION: 
As a system technician surfing on Configuration Management page
I want to add 50 roles
So I can verify that 50 roles were added successfully
@TEST_CASE_PRECONDITION: 
- A new layout, called layoutTest, is created in HMI Layouts, under Voice-HMI Layout menu
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, when it is possible to configure 50 roles, each role having assign a HMI Layout.
@TEST_CASE_DEVICES_IN_USE: A computer with a browser installed, connected to a network with access to Configuration Management page.
@TEST_CASE_ID: PVCSX-TC-15278
@TEST_CASE_GLOBAL_ID: GID-5471237
@TEST_CASE_API_ID: 19406065

Scenario: Book profile
Given booked profiles:
| profile | group                  | host       |
| web     | firefox_<<systemName>> | <<CO3_IP>> |

Scenario: System Technician: Open a Configuration Management page
Meta:
@TEST_STEP_ACTION: System Technician: Open a Configuration Management page
@TEST_STEP_REACTION: Browser: Configuration Management page is visible
@TEST_STEP_REF: [CATS-REF: gcCf]
Given defined XVP Configurator:
| key    | profile                    | url                      |
| config | web firefox_<<systemName>> | <<xvp.configurator.url>> |
Then configurator management page is visible

Scenario: System Technician: Click on Missions and Roles menu
Meta:
@TEST_STEP_ACTION: System Technician: Click on Missions and Roles menu
@TEST_STEP_REACTION: Browser: Sub menus: Roles, Roles-Radio configuration, Missions, Template: Frequency Permissions, Template: Radio Settings are visible
@TEST_STEP_REF: [CATS-REF: Tklr]
When selecting Missions and Roles item in main menu
Then Missions and Roles menu item contains following sub-menu items: <<MISSIONS_AND_ROLES_SUB_MENUS>>


Scenario: System Technician: Click on Roles sub-menu
Meta:
@TEST_STEP_ACTION: System Technician: Click on Roles sub-menu
@TEST_STEP_REACTION: Browser: Roles page is visible
@TEST_STEP_REF: [CATS-REF: On1F]
When selecting Roles sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Roles

Scenario: System Technician: Click on New button
Meta:
@TEST_STEP_ACTION: System Technician: Click on New button
@TEST_STEP_REACTION: Browser: Role Editor page is visible
@TEST_STEP_REF: [CATS-REF: tONs]
When New button is pressed in Roles sub-menu
Then editor page Roles is visible

Scenario: System Technician: Enter RoleTest1 in Name input field
Meta:
@TEST_STEP_ACTION: System Technician: Enter RoleTest1 in Name input field
@TEST_STEP_REACTION: Browser: RoleTest1 is displayed in Name input field
@TEST_STEP_REF: [CATS-REF: eSGP]
When add a new role with:
| key   | name      | displayName | location | organization | comment | notes | layout     | callRouteSelector  | destination               | defaultSourceOutgoingCalls | defaultSipPriority |
| entry | RoleTest1 | RoleTest1   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest1@example.com | RoleTest1                  |                    |

Then verify role fields contain:
| key   | name      | displayName | location | organization | comment | notes | layout     | callRouteSelector  | destination               | defaultSourceOutgoingCalls | defaultSipPriority |
| entry | RoleTest1 | RoleTest1   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest1@example.com | RoleTest1                  |                    |

Scenario: System Technician: Press save button
Meta:
@TEST_STEP_ACTION: System Technician: Press save button
@TEST_STEP_REACTION: Browser: A pop-up message displays: Successfully saved the role
@TEST_STEP_REF: [CATS-REF: ifpI]
Then Save button is pressed in Roles editor
Then verifying pop-up displays message: Successfully saved the role
Then role RoleTest1 is displayed in Roles list

Scenario: System Technician: Click on RoleTest1 from Roles list
Meta:
@TEST_STEP_ACTION: System Technician: Click on RoleTest1 from Roles list
@TEST_STEP_REACTION: Browser: Role editor page is visible
@TEST_STEP_REF: [CATS-REF: xd5i]
When select item RoleTest1 from Roles sub-menu items list
Then editor page Roles is visible

Scenario: System Technician: Verify Name input field displays RoleTest1
Meta:
@TEST_STEP_ACTION: System Technician: Verify Name input field displays RoleTest1
@TEST_STEP_REACTION: Browser: Name input field displays RoleTest1
@TEST_STEP_REF: [CATS-REF: 3y3L]
Then verify role fields contain:
| key   | name      | displayName | location | organization | comment | notes | layout     | callRouteSelector  | destination               | defaultSourceOutgoingCalls | defaultSipPriority |
| entry | RoleTest1 | RoleTest1   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest1@example.com | RoleTest1                  |                    |


Examples:
| name       | displayName | location | organization | comment | notes | layout     | callRouteSelector  | destination                | defaultSourceOutgoingCalls | defaultSipPriority |
| RoleTest1  | RoleTest1   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest1@example.com  | RoleTest1                  |                    |
| RoleTest2  | RoleTest2   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest2@example.com  | RoleTest2                  |                    |
| RoleTest3  | RoleTest3   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest3@example.com  | RoleTest3                  |                    |
| RoleTest4  | RoleTest4   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest4@example.com  | RoleTest4                  |                    |
| RoleTest5  | RoleTest5   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest5@example.com  | RoleTest5                  |                    |
| RoleTest6  | RoleTest6   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest6@example.com  | RoleTest6                  |                    |
| RoleTest7  | RoleTest7   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest7@example.com  | RoleTest7                  |                    |
| RoleTest8  | RoleTest8   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest8@example.com  | RoleTest8                  |                    |
| RoleTest9  | RoleTest9   |          |              |         |       | layoutTest | Please select one! | sip:RoleTest9@example.com  | RoleTest9                  |                    |
| RoleTest10 | RoleTest10  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest10@example.com | RoleTest10                 |                    |
| RoleTest11 | RoleTest11  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest11@example.com | RoleTest11                 |                    |
| RoleTest12 | RoleTest12  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest12@example.com | RoleTest12                 |                    |
| RoleTest13 | RoleTest13  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest13@example.com | RoleTest13                 |                    |
| RoleTest14 | RoleTest14  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest14@example.com | RoleTest14                 |                    |
| RoleTest15 | RoleTest15  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest15@example.com | RoleTest15                 |                    |
| RoleTest16 | RoleTest16  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest16@example.com | RoleTest16                 |                    |
| RoleTest17 | RoleTest17  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest17@example.com | RoleTest17                 |                    |
| RoleTest18 | RoleTest18  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest18@example.com | RoleTest18                 |                    |
| RoleTest19 | RoleTest19  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest19@example.com | RoleTest19                 |                    |
| RoleTest20 | RoleTest20  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest20@example.com | RoleTest20                 |                    |
| RoleTest21 | RoleTest21  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest21@example.com | RoleTest21                 |                    |
| RoleTest22 | RoleTest22  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest22@example.com | RoleTest22                 |                    |
| RoleTest23 | RoleTest23  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest23@example.com | RoleTest23                 |                    |
| RoleTest24 | RoleTest24  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest24@example.com | RoleTest24                 |                    |
| RoleTest25 | RoleTest25  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest25@example.com | RoleTest25                 |                    |
| RoleTest26 | RoleTest26  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest26@example.com | RoleTest26                 |                    |
| RoleTest27 | RoleTest27  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest27@example.com | RoleTest27                 |                    |
| RoleTest28 | RoleTest28  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest28@example.com | RoleTest28                 |                    |
| RoleTest29 | RoleTest29  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest29@example.com | RoleTest29                 |                    |
| RoleTest30 | RoleTest30  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest30@example.com | RoleTest30                 |                    |
| RoleTest31 | RoleTest31  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest31@example.com | RoleTest31                 |                    |
| RoleTest32 | RoleTest32  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest32@example.com | RoleTest32                 |                    |
| RoleTest33 | RoleTest33  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest33@example.com | RoleTest33                 |                    |
| RoleTest34 | RoleTest34  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest34@example.com | RoleTest34                 |                    |
| RoleTest35 | RoleTest35  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest35@example.com | RoleTest35                 |                    |
| RoleTest36 | RoleTest36  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest36@example.com | RoleTest36                 |                    |
| RoleTest37 | RoleTest37  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest37@example.com | RoleTest37                 |                    |
| RoleTest38 | RoleTest38  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest38@example.com | RoleTest38                 |                    |
| RoleTest39 | RoleTest39  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest39@example.com | RoleTest39                 |                    |
| RoleTest40 | RoleTest40  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest40@example.com | RoleTest40                 |                    |
| RoleTest41 | RoleTest41  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest41@example.com | RoleTest41                 |                    |
| RoleTest42 | RoleTest42  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest42@example.com | RoleTest42                 |                    |
| RoleTest43 | RoleTest43  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest43@example.com | RoleTest43                 |                    |
| RoleTest44 | RoleTest44  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest44@example.com | RoleTest44                 |                    |
| RoleTest45 | RoleTest45  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest45@example.com | RoleTest45                 |                    |
| RoleTest46 | RoleTest46  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest46@example.com | RoleTest46                 |                    |
| RoleTest47 | RoleTest47  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest47@example.com | RoleTest47                 |                    |
| RoleTest48 | RoleTest48  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest48@example.com | RoleTest48                 |                    |
| RoleTest49 | RoleTest49  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest49@example.com | RoleTest49                 |                    |
| RoleTest50 | RoleTest50  |          |              |         |       | layoutTest | Please select one! | sip:RoleTest50@example.com | RoleTest50                 |                    |

Scenario: System Technician: Repeat steps 4-19 another 49 times (in iteration 2 it is used RoleTest2 instead of RoleTest1, in iteration 3 it is used RoleTest3 and so on)
Meta:
@TEST_STEP_ACTION: System Technician: Repeat steps 4-19 another 49 times (in iteration 2 it is used RoleTest2 instead of RoleTest1, in iteration 3 it is used RoleTest3 and so on)
@TEST_STEP_REACTION: Browser: The expected results of steps 4-19 are the same (with the difference that in iteration 2, RoleTest1 is replaced with RoleTest2 and so on)
@TEST_STEP_REF: [CATS-REF: ow6S]
!-- insert steps here!!!


Scenario: Scroll down into Roles page
Meta:
@TEST_STEP_ACTION: System Technician: Scroll down into Roles page
@TEST_STEP_REACTION: Browser: Roles from RoleTest1 to RoleTest50 are displayed
@TEST_STEP_REF: [CATS-REF: evA4]
!-- insert steps here!!!



Scenario: System Technician: Repeat steps 4-11 once again, using RoleTest51 instead of RoleTest1
Meta:
@TEST_STEP_ACTION: System Technician: Repeat steps 4-11 once again, using RoleTest51 instead of RoleTest1
@TEST_STEP_REACTION: Browser: The expected results of steps 4-11 are the same, containing RoleTest51 instead of RoleTest1
@TEST_STEP_REF: [CATS-REF: JxGb]
!-- insert steps here!!!



Scenario: System Technician: Press save button
Meta:
@TEST_STEP_ACTION: System Technician: Press save button
@TEST_STEP_REACTION: Browser: A pop-up message displays: Could not save the role: Maximum number of defined roles (50) reached
@TEST_STEP_REF: [CATS-REF: oyWI]
!-- insert steps here!!!



Scenario: System Technician: Press save button
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: 
Browser: Role RoleTest51 is not displayed in Roles list
@TEST_STEP_REF: [CATS-REF: zcGM]
!-- insert steps here!!!



Scenario: System Technician: Access address &lt;Configuration Management page&gt;/op-voice-service/roles (example: https://10.31.205.100/configurations/op-voice-service/roles
Meta:
@TEST_STEP_ACTION: System Technician: Access address &lt;Configuration Management page&gt;/op-voice-service/roles (example: https://10.31.205.100/configurations/op-voice-service/roles
@TEST_STEP_REACTION: Browser: A page with Roles in JSON format is visible
@TEST_STEP_REF: [CATS-REF: V2Tm]
!-- insert steps here!!!



Scenario: System Technician: Verify roles RoleTest1 to RoleTest50 are displayed containing inserted information
Meta:
@TEST_STEP_ACTION: System Technician: Verify roles RoleTest1 to RoleTest50 are displayed containing inserted information
@TEST_STEP_REACTION: Browser: Roles RoleTest1 to RoleTest50 are displayed containing inserted information
@TEST_STEP_REF: [CATS-REF: 0127]
!-- insert steps here!!!



Scenario: Acces address
Meta:
@TEST_STEP_ACTION: 
System Technician: Acces address &lt;Configuration Management page&gt;/op-voice-service/phoneBook?searchPattern=&amp;startIndex=0&amp;itemCount=2147483647&amp;externalEntries=true
(example: https://10.31.205.100/configurations/op-voice-service/phoneBook?searchPattern=&amp;startIndex=0&amp;itemCount=2147483647&amp;externalEntries=true)
@TEST_STEP_REACTION: Browser: A page with Phone Book entries in JSON (collapsed) format is visible
@TEST_STEP_REF: [CATS-REF: pfUq]
!-- insert steps here!!!



Scenario: System Technician: Change from JSON tab to Raw Data tab of the displayed page
Meta:
@TEST_STEP_ACTION: System Technician: Change from JSON tab to Raw Data tab of the displayed page
@TEST_STEP_REACTION: Browser: The page displays data into a raw text manner
@TEST_STEP_REF: [CATS-REF: JgMt]
!-- insert steps here!!!



Scenario: System Technician: Verify roles RoleTest1 to RoleTest50 are displayed containing inserted information (Ctrl+F search function can be used, searching for name of each role)
Meta:
@TEST_STEP_ACTION: System Technician: Verify roles RoleTest1 to RoleTest50 are displayed containing inserted information (Ctrl+F search function can be used, searching for name of each role)
@TEST_STEP_REACTION: Browser: Roles RoleTest1 to RoleTest50 are displayed containing inserted information
@TEST_STEP_REF: [CATS-REF: pS2k]
!-- insert steps here!!!



