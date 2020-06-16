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

Scenario: Define XVP Configurator page
Given defined XVP Configurator:
| key    | profile                    | url                      |
| config | web firefox_<<systemName>> | <<xvp.configurator.url>> |
Then configurator management page is visible

Scenario: System Technician: Click on Missions and Roles menu
When selecting Missions and Roles item in main menu
Then Missions and Roles menu item contains following sub-menu items: <<MISSIONS_AND_ROLES_SUB_MENUS>>

Scenario: System Technician: Click on Roles sub-menu
When selecting Roles sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Roles

Scenario: Add roles until Maximum Number of Roles is reached
When New button is pressed in Roles sub-menu
Then editor page Roles is visible
When add a new role with:
| key   | name   | displayName   | location   | organization   | comment   | notes   | layout   | callRouteSelector   | destination   | defaultSourceOutgoingCalls   | defaultSipPriority   |
| entry | <name> | <displayName> | <location> | <organization> | <comment> | <notes> | <layout> | <callRouteSelector> | <destination> | <defaultSourceOutgoingCalls> | <defaultSipPriority> |

Then verify role fields contain:
| key   | name   | displayName   | location   | organization   | comment   | notes   | layout   | callRouteSelector   | destination   | defaultSourceOutgoingCalls   | defaultSipPriority   |
| entry | <name> | <displayName> | <location> | <organization> | <comment> | <notes> | <layout> | <callRouteSelector> | <destination> | <defaultSourceOutgoingCalls> | <defaultSipPriority> |

Then Save button is pressed in Roles editor
Then waiting 5 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the role
Then role <name> is displayed in Roles list

When select item <name> from Roles sub-menu items list
Then editor page Roles is visible

Then verify role fields contain:
| key   | name   | displayName   | location   | organization   | comment   | notes   | layout   | callRouteSelector   | destination   | defaultSourceOutgoingCalls   | defaultSipPriority   |
| entry | <name> | <displayName> | <location> | <organization> | <comment> | <notes> | <layout> | <callRouteSelector> | <destination> | <defaultSourceOutgoingCalls> | <defaultSipPriority> |

Examples:
| name       | displayName | location | organization | comment | notes | layout     | callRouteSelector  | destination            | defaultSourceOutgoingCalls | defaultSipPriority |
| RoleTest1  | RoleTest1   |          |              |         |       | twr-layout | none               | RoleTest1@example.com  | RoleTest1                  |                    |
| RoleTest2  | RoleTest2   |          |              |         |       | twr-layout | none               | RoleTest2@example.com  | RoleTest2                  |                    |
| RoleTest3  | RoleTest3   |          |              |         |       | twr-layout | none               | RoleTest3@example.com  | RoleTest3                  |                    |
| RoleTest4  | RoleTest4   |          |              |         |       | twr-layout | none               | RoleTest4@example.com  | RoleTest4                  |                    |
| RoleTest5  | RoleTest5   |          |              |         |       | twr-layout | none               | RoleTest5@example.com  | RoleTest5                  |                    |
| RoleTest6  | RoleTest6   |          |              |         |       | twr-layout | none               | RoleTest6@example.com  | RoleTest6                  |                    |
| RoleTest7  | RoleTest7   |          |              |         |       | twr-layout | none               | RoleTest7@example.com  | RoleTest7                  |                    |
| RoleTest8  | RoleTest8   |          |              |         |       | twr-layout | none               | RoleTest8@example.com  | RoleTest8                  |                    |
| RoleTest9  | RoleTest9   |          |              |         |       | twr-layout | none               | RoleTest9@example.com  | RoleTest9                  |                    |
| RoleTest10 | RoleTest10  |          |              |         |       | twr-layout | none               | RoleTest10@example.com | RoleTest10                 |                    |
| RoleTest11 | RoleTest11  |          |              |         |       | twr-layout | none               | RoleTest11@example.com | RoleTest11                 |                    |
| RoleTest12 | RoleTest12  |          |              |         |       | twr-layout | none               | RoleTest12@example.com | RoleTest12                 |                    |
| RoleTest13 | RoleTest13  |          |              |         |       | twr-layout | none               | RoleTest13@example.com | RoleTest13                 |                    |
| RoleTest14 | RoleTest14  |          |              |         |       | twr-layout | none               | RoleTest14@example.com | RoleTest14                 |                    |
| RoleTest15 | RoleTest15  |          |              |         |       | twr-layout | none               | RoleTest15@example.com | RoleTest15                 |                    |
| RoleTest16 | RoleTest16  |          |              |         |       | twr-layout | none               | RoleTest16@example.com | RoleTest16                 |                    |
| RoleTest17 | RoleTest17  |          |              |         |       | twr-layout | none               | RoleTest17@example.com | RoleTest17                 |                    |
| RoleTest18 | RoleTest18  |          |              |         |       | twr-layout | none               | RoleTest18@example.com | RoleTest18                 |                    |
| RoleTest19 | RoleTest19  |          |              |         |       | twr-layout | none               | RoleTest19@example.com | RoleTest19                 |                    |
| RoleTest20 | RoleTest20  |          |              |         |       | twr-layout | none               | RoleTest20@example.com | RoleTest20                 |                    |
| RoleTest21 | RoleTest21  |          |              |         |       | twr-layout | none               | RoleTest21@example.com | RoleTest21                 |                    |
| RoleTest22 | RoleTest22  |          |              |         |       | twr-layout | none               | RoleTest22@example.com | RoleTest22                 |                    |
| RoleTest23 | RoleTest23  |          |              |         |       | twr-layout | none               | RoleTest23@example.com | RoleTest23                 |                    |
| RoleTest24 | RoleTest24  |          |              |         |       | twr-layout | none               | RoleTest24@example.com | RoleTest24                 |                    |
| RoleTest25 | RoleTest25  |          |              |         |       | twr-layout | none               | RoleTest25@example.com | RoleTest25                 |                    |
| RoleTest26 | RoleTest26  |          |              |         |       | twr-layout | none               | RoleTest26@example.com | RoleTest26                 |                    |

Scenario: Add one more role after Maximum Number of Roles was reached
When New button is pressed in Roles sub-menu
Then editor page Roles is visible
When add a new role with:
| key   | name             | displayName      | location | organization | comment | notes | layout     | callRouteSelector | destination                  | defaultSourceOutgoingCalls | defaultSipPriority |
| entry | RoleTestAboveMax | RoleTestAboveMax |          |              |         |       | twr-layout | none              | RoleTestAboveMax@example.com | RoleTestAboveMax           |                    |

Then verify role fields contain:
| key   | name             | displayName      | location | organization | comment | notes | layout     | callRouteSelector | destination                  | defaultSourceOutgoingCalls | defaultSipPriority |
| entry | RoleTestAboveMax | RoleTestAboveMax |          |              |         |       | twr-layout | none              | RoleTestAboveMax@example.com | RoleTestAboveMax           |                    |

Then Save button is pressed in Roles editor
Then waiting 1 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the role: Maximum number of defined roles (<<MAX_NUMBER_OF_ROLES>>) reached
Then role RoleTestAboveMax is not displayed in Roles list
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible

Scenario: GET all roles from server and check for added roles
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/roles :=> response
Then verifying roles requested response ${response} contains roles <<ROLES_LIST>> and new added roles

Scenario: GET all phone book entries and check for added roles
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/phoneBook?searchPattern=&startIndex=0&itemCount=2147483647&externalEntries=true :=> phoneBookResponse
Then verifying phoneBook requested response ${phoneBookResponse} contains roles <<ROLES_LIST>> and new added roles

Scenario: Discard unsaved changes
When select item RoleTest1 from Roles sub-menu items list
Then an alert box dialog pops-up with message: You have unsaved changes and are about to leave this page. If you leave, your changes will be discarded
When clicking on Discard changes button of Discard alert box dialog

Scenario: Delete new added roles
When deleting Roles sub-menu item: <name>
Then an alert box dialog pops-up with message: Are you sure you want to delete the role <name>?

When clicking on Yes button of Delete alert box dialog
Then waiting 5 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: The file was successfully deleted.

Examples:
| name       | displayName | location | organization | comment | notes | layout     | callRouteSelector  | destination            | defaultSourceOutgoingCalls | defaultSipPriority |
| RoleTest1  | RoleTest1   |          |              |         |       | twr-layout | none               | RoleTest1@example.com  | RoleTest1                  |                    |
| RoleTest2  | RoleTest2   |          |              |         |       | twr-layout | none               | RoleTest2@example.com  | RoleTest2                  |                    |
| RoleTest3  | RoleTest3   |          |              |         |       | twr-layout | none               | RoleTest3@example.com  | RoleTest3                  |                    |
| RoleTest4  | RoleTest4   |          |              |         |       | twr-layout | none               | RoleTest4@example.com  | RoleTest4                  |                    |
| RoleTest5  | RoleTest5   |          |              |         |       | twr-layout | none               | RoleTest5@example.com  | RoleTest5                  |                    |
| RoleTest6  | RoleTest6   |          |              |         |       | twr-layout | none               | RoleTest6@example.com  | RoleTest6                  |                    |
| RoleTest7  | RoleTest7   |          |              |         |       | twr-layout | none               | RoleTest7@example.com  | RoleTest7                  |                    |
| RoleTest8  | RoleTest8   |          |              |         |       | twr-layout | none               | RoleTest8@example.com  | RoleTest8                  |                    |
| RoleTest9  | RoleTest9   |          |              |         |       | twr-layout | none               | RoleTest9@example.com  | RoleTest9                  |                    |
| RoleTest10 | RoleTest10  |          |              |         |       | twr-layout | none               | RoleTest10@example.com | RoleTest10                 |                    |
| RoleTest11 | RoleTest11  |          |              |         |       | twr-layout | none               | RoleTest11@example.com | RoleTest11                 |                    |
| RoleTest12 | RoleTest12  |          |              |         |       | twr-layout | none               | RoleTest12@example.com | RoleTest12                 |                    |
| RoleTest13 | RoleTest13  |          |              |         |       | twr-layout | none               | RoleTest13@example.com | RoleTest13                 |                    |
| RoleTest14 | RoleTest14  |          |              |         |       | twr-layout | none               | RoleTest14@example.com | RoleTest14                 |                    |
| RoleTest15 | RoleTest15  |          |              |         |       | twr-layout | none               | RoleTest15@example.com | RoleTest15                 |                    |
| RoleTest16 | RoleTest16  |          |              |         |       | twr-layout | none               | RoleTest16@example.com | RoleTest16                 |                    |
| RoleTest17 | RoleTest17  |          |              |         |       | twr-layout | none               | RoleTest17@example.com | RoleTest17                 |                    |
| RoleTest18 | RoleTest18  |          |              |         |       | twr-layout | none               | RoleTest18@example.com | RoleTest18                 |                    |
| RoleTest19 | RoleTest19  |          |              |         |       | twr-layout | none               | RoleTest19@example.com | RoleTest19                 |                    |
| RoleTest20 | RoleTest20  |          |              |         |       | twr-layout | none               | RoleTest20@example.com | RoleTest20                 |                    |
| RoleTest21 | RoleTest21  |          |              |         |       | twr-layout | none               | RoleTest21@example.com | RoleTest21                 |                    |
| RoleTest22 | RoleTest22  |          |              |         |       | twr-layout | none               | RoleTest22@example.com | RoleTest22                 |                    |
| RoleTest23 | RoleTest23  |          |              |         |       | twr-layout | none               | RoleTest23@example.com | RoleTest23                 |                    |
| RoleTest24 | RoleTest24  |          |              |         |       | twr-layout | none               | RoleTest24@example.com | RoleTest24                 |                    |
| RoleTest25 | RoleTest25  |          |              |         |       | twr-layout | none               | RoleTest25@example.com | RoleTest25                 |                    |
| RoleTest26 | RoleTest26  |          |              |         |       | twr-layout | none               | RoleTest26@example.com | RoleTest26                 |                    |

Scenario: Close Missions and Roles menu
When selecting Missions and Roles item in main menu

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: configurator/Roles/@RolesCleanup.story
Then waiting until the cleanup is done

!-- approach cu rest endpoint pt scriere a maxim-1 roluri si pt clean-up
