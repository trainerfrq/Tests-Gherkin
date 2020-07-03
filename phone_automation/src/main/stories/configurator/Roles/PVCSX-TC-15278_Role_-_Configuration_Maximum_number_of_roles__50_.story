Meta:
@TEST_CASE_VERSION: V24
@TEST_CASE_NAME: Role - Configuration Maximum number of roles (50)
@TEST_CASE_DESCRIPTION:
As a system technician using a Configuration Management page
I want to add 50 roles
So I can verify that 50 roles were added successfully
@TEST_CASE_PRECONDITION:
Layout layoutTest available (Voice-HMI Layout menu - HMI Layouts)
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, when it is possible to configure 50 roles, each role having assign a HMI Layout.
@TEST_CASE_DEVICES_IN_USE: Configurator
@TEST_CASE_ID: PVCSX-TC-15278
@TEST_CASE_GLOBAL_ID: GID-5471237
@TEST_CASE_API_ID: 19406065

Scenario: Preparation step - save missions ids
Given the missions ids for configurator <<xvp.configurator.url>> are saved in list defaultMissions

Scenario: Preparation step - save roles ids and delete roles
Given the roles ids for configurator <<xvp.configurator.url>> are saved in list defaultRoles
Then using <<xvp.configurator.url>> delete roles with ids from list defaultRoles

Scenario: Book profile
Given booked profiles:
| profile | group                  | host       |
| web     | firefox_<<systemName>> | <<CO3_IP>> |

Given defined XVP Configurator:
| key    | profile                    | url                      |
| config | web firefox_<<systemName>> | <<xvp.configurator.url>> |

Scenario: 1. Configurator: The main page of Configuration Management is open
Meta:
@TEST_STEP_ACTION: Configurator: The main page of Configuration Management is open
@TEST_STEP_REACTION: Configurator: Configuration Management page is visible
@TEST_STEP_REF: [CATS-REF: gcCf]
Then configurator management page is visible

Scenario: 2. Configurator: Select 'Missions and Roles' menu
Meta:
@TEST_STEP_ACTION: Configurator: Select 'Missions and Roles' menu
@TEST_STEP_REACTION: Configurator: The following sub-menus are visible - Roles, Roles-Radio configuration, Missions, Template: Frequency Permissions, Template: Radio Settings
@TEST_STEP_REF: [CATS-REF: Tklr]
When selecting Missions and Roles item in main menu
Then Missions and Roles menu item contains following sub-menu items: <<MISSIONS_AND_ROLES_SUB_MENUS>>

Scenario: 3. Configurator: Select 'Roles' sub-menu
Meta:
@TEST_STEP_ACTION: Configurator: Select 'Roles' sub-menu
@TEST_STEP_REACTION: Configurator: Roles page is visible
@TEST_STEP_REF: [CATS-REF: On1F]
When selecting Roles sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Roles

Scenario: 4. Configurator: Click on 'New' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'New' button
@TEST_STEP_REACTION: Configurator: Role Editor page is visible
@TEST_STEP_REF: [CATS-REF: tONs]
When New button is pressed in Roles sub-menu
Then editor page Roles is visible

Scenario: 5. Configurator: Enter - 'RoleTest1' in 'Name' input field, 'RoleTest1' in 'Display name', 'sip:RoleTest1@example.com' in 'Destination'. Select - 'layoutTest' from 'Layout', 'Please select one!' from 'Call Route Selector', 'RoleTest1' from 'Default Source for outgoing calls'
Meta:
@TEST_STEP_ACTION: Configurator: Enter - 'RoleTest1' in 'Name' input field, 'RoleTest1' in 'Display name', 'sip:RoleTest1%40example.com' in 'Destination'; Select - 'layoutTest' from 'Layout', 'Please select one!' from 'Call Route Selector', 'RoleTest1' from 'Default Source for outgoing calls'
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'Destination', 'Layout', 'Call Route Selector', 'Default Source of outgoing calls' are displaying correctly the values selected or filled in. 'Resulting SIP URI' value is displayed according to the selected 'Call Route Selector' and 'Destination' input field.
@TEST_STEP_REF: [CATS-REF: eSGP]
When add a new role with:
| key   | name      | displayName | layout     | callRouteSelector | destination           | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | twr-layout | none              | RoleTest1@example.com | RoleTest1                  |

Then verify role fields contain:
| key   | name      | displayName | layout     | callRouteSelector | destination           | resultingSipUri           |defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | twr-layout | none              | RoleTest1@example.com | sip:RoleTest1@example.com | RoleTest1                 |

Scenario: 6. Configurator: Click on 'Save' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: A pop-up message displays: Successfully saved the role
@TEST_STEP_REF: [CATS-REF: ifpI]
Then Save button is pressed in Roles editor
Then waiting 6 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the role

Scenario: 7 Role RoleTest1 is displayed in Roles list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Role RoleTest1 is displayed in Roles list
@TEST_STEP_REF: [CATS-REF: ZxDu]
Then role RoleTest1 is displayed in Roles list

Scenario: 8. Configurator: Verify that RoleTest1 is by default selected and inserted values are displayed in Role editor
Meta:
@TEST_STEP_ACTION: Configurator: Verify that RoleTest1 is by default selected and inserted values are displayed in Role editor
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'Destination', 'Layout', 'Call Route Selector', 'Default Source of outgoing calls' are displaying correctly the values selected or filled in at step 5.
@TEST_STEP_REF: [CATS-REF: bkDm]
Then verify role fields contain:
| key   | name      | displayName | layout     | callRouteSelector | destination           | resultingSipUri           | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | twr-layout | none              | RoleTest1@example.com | sip:RoleTest1@example.com | RoleTest1                  |

Scenario: 9. Configurator: Repeat steps 4-8 another 49 times (in iteration 2 it is used RoleTest2 instead of RoleTest1, in iteration 3 it is used RoleTest3 and so on)
Meta:
@TEST_STEP_ACTION: Configurator: Repeat steps 4-8 another 49 times (in iteration 2 it is used RoleTest2 instead of RoleTest1, in iteration 3 it is used RoleTest3 and so on)
@TEST_STEP_REACTION: Configurator: Roles page is visible and has 50 items
@TEST_STEP_REF: [CATS-REF: ow6S]
When New button is pressed in Roles sub-menu
Then editor page Roles is visible
When add a new role with:
| key   | name   | displayName   | layout   | callRouteSelector   | destination   | defaultSourceOutgoingCalls   |
| entry | <name> | <displayName> | <layout> | <callRouteSelector> | <destination> | <defaultSourceOutgoingCalls> |

Then verify role fields contain:
| key   | name   | displayName   | layout   | callRouteSelector   | destination   | resultingSipUri   | defaultSourceOutgoingCalls   |
| entry | <name> | <displayName> | <layout> | <callRouteSelector> | <destination> | <resultingSipUri> | <defaultSourceOutgoingCalls> |

Then Save button is pressed in Roles editor
Then waiting 5 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the role
Then role <name> is displayed in Roles list

When select item <name> from Roles sub-menu items list
Then editor page Roles is visible

Then verify role fields contain:
| key   | name   | displayName   | layout   | callRouteSelector   | destination   | resultingSipUri  | defaultSourceOutgoingCalls   |
| entry | <name> | <displayName> | <layout> | <callRouteSelector> | <destination> | <resultingSipUri> | <defaultSourceOutgoingCalls> |

Examples:
| name       | displayName | layout     | callRouteSelector  | destination            | resultingSipUri            | defaultSourceOutgoingCalls |
| RoleTest2  | RoleTest2   | twr-layout | none               | RoleTest2@example.com  | sip:RoleTest2@example.com  | RoleTest2                  |
| RoleTest3  | RoleTest3   | twr-layout | none               | RoleTest3@example.com  | sip:RoleTest3@example.com  | RoleTest3                  |
| RoleTest4  | RoleTest4   | twr-layout | none               | RoleTest4@example.com  | sip:RoleTest4@example.com  | RoleTest4                  |
| RoleTest5  | RoleTest5   | twr-layout | none               | RoleTest5@example.com  | sip:RoleTest5@example.com  | RoleTest5                  |
| RoleTest6  | RoleTest6   | twr-layout | none               | RoleTest6@example.com  | sip:RoleTest6@example.com  | RoleTest6                  |
| RoleTest7  | RoleTest7   | twr-layout | none               | RoleTest7@example.com  | sip:RoleTest7@example.com  | RoleTest7                  |
| RoleTest8  | RoleTest8   | twr-layout | none               | RoleTest8@example.com  | sip:RoleTest8@example.com  | RoleTest8                  |
| RoleTest9  | RoleTest9   | twr-layout | none               | RoleTest9@example.com  | sip:RoleTest9@example.com  | RoleTest9                  |
| RoleTest10 | RoleTest10  | twr-layout | none               | RoleTest10@example.com | sip:RoleTest10@example.com | RoleTest10                 |

Scenario: 9.1 Add new Roles until maximum is reached
When adding 40 test roles to endpoint <<xvp.configurator.url>> for system <<systemName>>

Scenario: 9.2 Refresh page in order to get displayed the new added roles
Then refresh Configurator

Scenario: 9.3 Open Roles sub-menu
When selecting Missions and Roles item in main menu
When selecting Roles sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Roles

Scenario: 10. Configurator: Repeat steps 4 and 5, using RoleTest51 instead of RoleTest1
Meta:
@TEST_STEP_ACTION: Configurator: Repeat steps 4 and 5, using RoleTest51 instead of RoleTest1
@TEST_STEP_REACTION: Configurator: The expected results of steps 4 and 5 are the same, containing RoleTest51 instead of RoleTest1
@TEST_STEP_REF: [CATS-REF: JxGb]
When New button is pressed in Roles sub-menu
Then editor page Roles is visible
When add a new role with:
| key   | name       | displayName  | layout     | callRouteSelector | destination            | defaultSourceOutgoingCalls  |
| entry | RoleTest51 | RoleTest51   | twr-layout | none              | RoleTest51@example.com | RoleTest51                  |

Then verify role fields contain:
| key   | name       | displayName  | layout     | callRouteSelector | destination            | resultingSipUri            |defaultSourceOutgoingCalls |
| entry | RoleTest51 | RoleTest51   | twr-layout | none              | RoleTest51@example.com | sip:RoleTest51@example.com | RoleTest51                |

Scenario: 11. Configurator: Click on 'Save' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: A pop-up message displays: Could not save the role: Maximum number of defined roles (50) reached
@TEST_STEP_REF: [CATS-REF: oyWI]
Then Save button is pressed in Roles editor
Then waiting 1 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the role: Maximum number of defined roles (50) reached

Scenario: 12. Role RoleTest51 is not displayed in Roles list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Role RoleTest51 is not displayed in Roles list
@TEST_STEP_REF: [CATS-REF: zcGM]
Then role RoleTest51 is not displayed in Roles list

Scenario: 13. Configurator: Close pop-up message
Meta:
@TEST_STEP_ACTION: Configurator: Close pop-up message
@TEST_STEP_REACTION: Configurator: Pop-up message is closed
@TEST_STEP_REF: [CATS-REF: segi]
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible

Scenario: 14. Select role RoleTest1
Meta:
@TEST_STEP_ACTION: Configurator: Configurator: Select role RoleTest1
@TEST_STEP_REACTION: Configurator: Configurator: A pop-up window shows saying "You have unsaved changes and are about to leave this page. if you leave, your changes will be discarded". Window has 2 option buttons: "Discard changes" and "Stay on this page"
@TEST_STEP_REF: [CATS-REF: mX1l]
When select item RoleTest1 from Roles sub-menu items list
Then an alert box dialog pops-up with message: <<discardMessage>>

Scenario: 15. Select role RoleTest1
Meta:
@TEST_STEP_ACTION: Configurator: Configurator: Choose to discard changes
@TEST_STEP_REACTION: Configurator: Roles page is visible and has 50 new items
@TEST_STEP_REF: [CATS-REF: KKO1]
When clicking on Discard changes button of Discard alert box dialog

Scenario: 15.1 Refresh page in order
Then list size for Roles is: 50

Scenario: Backend verification - check in roles that new roles were created successfully
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/roles :=> response
Then verifying roles requested response ${response} contains new added maximum number of roles

Scenario: Backend verification - check in phonebook that new roles were created successfully
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/phoneBook?searchPattern=&startIndex=0&itemCount=2147483647&externalEntries=true :=> phoneBookResponse
Then verifying phoneBook requested response ${phoneBookResponse} contains new added maximum number of roles

Scenario: Delete new added roles
When deleting Roles sub-menu item: <name>
Then an alert box dialog pops-up with message: Are you sure you want to delete the role <name>?

When clicking on Yes button of Delete alert box dialog
Then waiting 5 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: The file was successfully deleted.

Examples:
| name       | displayName | layout     | callRouteSelector  | destination            | defaultSourceOutgoingCalls |
| RoleTest1  | RoleTest1   | twr-layout | none               | RoleTest1@example.com  | RoleTest1                  |
| RoleTest2  | RoleTest2   | twr-layout | none               | RoleTest2@example.com  | RoleTest2                  |
| RoleTest3  | RoleTest3   | twr-layout | none               | RoleTest3@example.com  | RoleTest3                  |
| RoleTest4  | RoleTest4   | twr-layout | none               | RoleTest4@example.com  | RoleTest4                  |
| RoleTest5  | RoleTest5   | twr-layout | none               | RoleTest5@example.com  | RoleTest5                  |
| RoleTest6  | RoleTest6   | twr-layout | none               | RoleTest6@example.com  | RoleTest6                  |
| RoleTest7  | RoleTest7   | twr-layout | none               | RoleTest7@example.com  | RoleTest7                  |
| RoleTest8  | RoleTest8   | twr-layout | none               | RoleTest8@example.com  | RoleTest8                  |
| RoleTest9  | RoleTest9   | twr-layout | none               | RoleTest9@example.com  | RoleTest9                  |
| RoleTest10 | RoleTest10  | twr-layout | none               | RoleTest10@example.com | RoleTest10                 |

Scenario: Close Missions and Roles menu
When selecting Missions and Roles item in main menu

Scenario: Clean-up - Delete new created call route configurators and add default call route configurators
Given the roles ids for configurator <<xvp.configurator.url>> are saved in list newRolesIds
Then using <<xvp.configurator.url>> delete roles with ids from list newRolesIds
Then add missions to <<xvp.configurator.url>> using configurators with ids from lists defaultMissions found in path /configuration-files/<<systemName>>/Missions_default/missionconfiguration/
Then add roles to <<xvp.configurator.url>> using configurators with ids from lists defaultRoles found in path /configuration-files/<<systemName>>/Roles_default/roleconfiguration/

Scenario: Clean-up - Refresh Configurator
Then refresh Configurator
