Meta:
@TEST_CASE_VERSION: V4
@TEST_CASE_NAME: Role - General Information
@TEST_CASE_DESCRIPTION: 
As a system technician surfing on Configuration Management page
I want to create a new Role, configuring general information
So I can verify that the Role was created successfully with general information configured
@TEST_CASE_PRECONDITION: 
Layout layoutTest available (Voice-HMI Layout menu -&gt; HMI Layouts)
Call Route Selector default available (Global settings - Telephone menu -&gt; Call Route Selectors) with:	Name: default	Display name: Default	Domain: example.com
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, when it is possible to create a new Role, configuring following general information fields:	Name	Display Name	Location	Organization	Comment
@TEST_CASE_DEVICES_IN_USE: Configurator
@TEST_CASE_ID: PVCSX-TC-15284
@TEST_CASE_GLOBAL_ID: GID-5480703
@TEST_CASE_API_ID: 19436498

Scenario: Book profile
Given booked profiles:
| profile | group                  | host       |
| web     | firefox_<<systemName>> | <<CO3_IP>> |

Scenario: 1. System Technician: Open a Configuration Management page.
Meta:
@TEST_STEP_ACTION: System Technician: Open a Configuration Management page.
@TEST_STEP_REACTION: Configurator: Configuration Management page is visible
@TEST_STEP_REF: [CATS-REF: kwB8]
Given defined XVP Configurator:
| key    | profile                    | url                      |
| config | web firefox_<<systemName>> | <<xvp.configurator.url>> |
Then configurator management page is visible

Scenario: 2. System Technician: Click on Missions and Roles menu
Meta:
@TEST_STEP_ACTION: System Technician: Click on Missions and Roles menu
@TEST_STEP_REACTION: Configurator: Sub menus: Roles, Roles-Radio configuration, Missions, Template: Frequency Permissions, Template: Radio Settings are visible
@TEST_STEP_REF: [CATS-REF: Nays]
When selecting Missions and Roles item in main menu
Then Missions and Roles menu item contains following sub-menu items: <<MISSIONS_AND_ROLES_SUB_MENUS>>

Scenario: 3. System Technician: Click on Roles sub-menu
Meta:
@TEST_STEP_ACTION: System Technician: Click on Roles sub-menu
@TEST_STEP_REACTION: Configurator: Roles page is visible
@TEST_STEP_REF: [CATS-REF: r3LE]
When selecting Roles sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Roles

Scenario: 4. System Technician: Click on New button
Meta:
@TEST_STEP_ACTION: System Technician: Click on New button
@TEST_STEP_REACTION: Configurator: Role Editor page is visible
@TEST_STEP_REF: [CATS-REF: 04CL]
When New button is pressed in Roles sub-menu
Then editor page Roles is visible

Scenario: 5. Add new Role
Meta:
@TEST_STEP_ACTION: System Technician: Enter new Role details
@TEST_STEP_REACTION: Configurator: New Role details are displayed
@TEST_STEP_REF: [CATS-REF: bxcf]
When add a new role with:
| key   | name      | displayName | location | organization | comment    | layout     | callRouteSelector | destination | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | Vienna   | FRQ          | A new Role | twr-layout | default           | RoleTest1   | RoleTest1                  |

Then verify role fields contain:
| key   | name      | displayName | location | organization | comment    | layout     | callRouteSelector | destination | resultingSipUri           | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | Vienna   | FRQ          | A new Role | twr-layout | default           | RoleTest1   | sip:RoleTest1@example.com | RoleTest1                  |

Scenario: 6. System Technician: Press save button
Meta:
@TEST_STEP_ACTION: System Technician: Press save button
@TEST_STEP_REACTION: Configurator: A pop-up message displays: Successfully saved the role
@TEST_STEP_REF: [CATS-REF: Rbdn]
Then Save button is pressed in Roles editor
Then waiting 5 seconds for LoadingScreen to disappear

Scenario: 6.1 Verifying pop-up message
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the role

Scenario: 6.2 Verifying new Role is displayed in Roles list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Role RoleTest1 is displayed in Roles list
@TEST_STEP_REF: [CATS-REF: B7He]
Then role RoleTest1 is displayed in Roles list

Scenario: 7. System Technician: Click on RoleTest1 from Roles list
Meta:
@TEST_STEP_ACTION: System Technician: Click on RoleTest1 from Roles list
@TEST_STEP_REACTION: Configurator: Role editor page is visible
@TEST_STEP_REF: [CATS-REF: Ztzm]
When select item RoleTest1 from Roles sub-menu items list
Then editor page Roles is visible

Scenario: 8. Verifying added Role data
Meta:
@TEST_STEP_ACTION: System Technician: Verify added Role fields
@TEST_STEP_REACTION: Configurator: Added Role fields display inserted values
@TEST_STEP_REF: [CATS-REF: 0RvB]
Then verify role fields contain:
| key   | name      | displayName | location | organization | comment    | layout     | callRouteSelector | destination | resultingSipUri           | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | Vienna   | FRQ          | A new Role | twr-layout | default           | RoleTest1   | sip:RoleTest1@example.com | RoleTest1                  |

Scenario: 9 GET all roles from server and check for added role
Meta:
@TEST_STEP_ACTION: System Technician: Access address <Configuration Management page IP>/configurations/op-voice-service/roles and check for RoleTest1
@TEST_STEP_REACTION: Configurator: A page with Roles in JSON format is visible and RoleTest1 is displayed containing inserted information
@TEST_STEP_REF: [CATS-REF: ULaF]
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/roles :=> response
Then verifying roles requested response ${response} contains roles <<ROLES_LIST>> and role RoleTest1

Scenario: 10. GET all phone book entries and check for added role
Meta:
@TEST_STEP_ACTION: System Technician: Access address <Configuration Management page IP>/configurations/op-voice-service/phoneBook?searchPattern=&startIndex=0&itemCount=2147483647&externalEntries=true and check for RoleTest1
@TEST_STEP_REACTION: Configurator: A page with Phone Book entries in JSON format is visible and RoleTest1 is displayed containing inserted information
@TEST_STEP_REF: [CATS-REF: jZ0R]
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/phoneBook?searchPattern=&startIndex=0&itemCount=2147483647&externalEntries=true :=> phoneBookResponse
Then verifying phoneBook requested response ${phoneBookResponse} contains roles <<ROLES_LIST>> and role RoleTest1

Scenario: Delete new added role
When deleting Roles sub-menu item: RoleTest1
Then an alert box dialog pops-up with message: Are you sure you want to delete the role RoleTest1?

When clicking on Yes button of Delete alert box dialog
Then waiting 5 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: The file was successfully deleted.

Scenario: Close Missions and Roles menu
When selecting Missions and Roles item in main menu

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: configurator/Roles/@RolesCleanup.story
Then waiting until the cleanup is done
