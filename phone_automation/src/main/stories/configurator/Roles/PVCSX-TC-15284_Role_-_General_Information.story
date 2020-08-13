Meta:
@TEST_CASE_VERSION: V7
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

Scenario: Define XVP Configurator page
Given defined XVP Configurator:
| key    | profile                    | url                      |
| config | web firefox_<<systemName>> | <<xvp.configurator.url>> |

Scenario: 1. Configurator: The main page of Configuration Management is open
Meta:
@TEST_STEP_ACTION: Configurator: The main page of Configuration Management is open
@TEST_STEP_REACTION: Configurator: Configuration Management page is visible
@TEST_STEP_REF: [CATS-REF: kwB8]
Then configurator management page is visible

Scenario: 2. Configurator: Select 'Missions and Roles' menu
Meta:
@TEST_STEP_ACTION: Configurator: Select 'Missions and Roles' menu
@TEST_STEP_REACTION: Configurator: The following sub-menus are visible - Roles, Roles-Radio configuration, Missions, Template: Frequency Permissions, Template: Radio Settings
@TEST_STEP_REF: [CATS-REF: Nays]
When selecting Missions and Roles item in main menu
Then Missions and Roles menu item contains following sub-menu items: <<MISSIONS_AND_ROLES_SUB_MENUS>>

Scenario: 3. Configurator: Select 'Roles' sub-menu
Meta:
@TEST_STEP_ACTION: Configurator: Select 'Roles' sub-menu
@TEST_STEP_REACTION: Configurator: Roles page is visible
@TEST_STEP_REF: [CATS-REF: r3LE]
When selecting Roles sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Roles

Scenario: 4. Configurator: Click on 'New' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'New' button
@TEST_STEP_REACTION: Configurator: Role Editor page is visible
@TEST_STEP_REF: [CATS-REF: 04CL]
When New button is pressed in Roles sub-menu
Then editor page Roles is visible

Scenario: 5. Configurator: Enter - 'RoleTest1' in 'Name' input field, 'RoleTest1' in 'Display name', 'Vienna' in 'Location', 'FRQ' in 'Organization', 'A new Role' in 'Comment', 'RoleTest1' in 'Destination'; Select - 'layoutTest' from 'Layout', 'default' from 'Call Route Selector', 'RoleTest1' from 'Default Source for outgoing calls'
Meta:
@TEST_STEP_ACTION: Configurator: Enter - 'RoleTest1' in 'Name' input field, 'RoleTest1' in 'Display name', 'Vienna' in 'Location', 'FRQ' in 'Organization', 'A new Role' in 'Comment', 'RoleTest1' in 'Destination'; Select - 'layoutTest' from 'Layout', 'default' from 'Call Route Selector', 'RoleTest1' from 'Default Source for outgoing calls'
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'Location', 'Organization', 'Comment', 'Destination', 'Layout', 'Call Route Selector', 'Default Source of outgoing calls' are displaying correctly the values selected or filled in. 'Resulting SIP URI' value is displayed according to the selected 'Call Route Selector' and 'Destination' input field.
@TEST_STEP_REF: [CATS-REF: bxcf]
When add a new role with:
| key   | name      | displayName | location | organization | comment    | layout     | callRouteSelector | destination | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | Vienna   | FRQ          | A new Role | twr-layout | default           | RoleTest1   | RoleTest1                  |

Then verify role fields contain:
| key   | name      | displayName | location | organization | comment    | layout     | callRouteSelector | destination | resultingSipUri           | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | Vienna   | FRQ          | A new Role | twr-layout | default           | RoleTest1   | sip:RoleTest1@example.com | RoleTest1                  |

Scenario: 6. Configurator: Click on 'Save' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: A pop-up message displays: Successfully saved the role
@TEST_STEP_REF: [CATS-REF: Rbdn]
Then Save button is pressed in Roles editor
Then waiting 8 seconds for LoadingScreen to disappear

Scenario: 6.1 Verifying pop-up message
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the role

Scenario: 7. Role RoleTest1 is displayed in Roles list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Role RoleTest1 is displayed in Roles list
@TEST_STEP_REF: [CATS-REF: B7He]
Then role RoleTest1 is displayed in Roles list

Scenario: 8. Configurator: Verify that RoleTest1 is by default selected and inserted values are displayed in Role editor
Meta:
@TEST_STEP_ACTION: Configurator: Verify that RoleTest1 is by default selected and inserted values are displayed in Role editor
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'Location', 'Organization', 'Comment', 'Destination', 'Layout', 'Call Route Selector', 'Default Source of outgoing calls' are displaying correctly the values selected or filled in at step 5.
@TEST_STEP_REF: [CATS-REF: Ztzm]
Then verify role fields contain:
| key   | name      | displayName | location | organization | comment    | layout     | callRouteSelector | destination | resultingSipUri           | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | Vienna   | FRQ          | A new Role | twr-layout | default           | RoleTest1   | sip:RoleTest1@example.com | RoleTest1                  |

Scenario: Backend verification - check in roles that new role was created successfully
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/roles :=> response
Then verifying roles requested response ${response} contains roles from table:
| key     | name      |
| entry1  | RoleTest1 |

Scenario: Backend verification - check in phonebook that new role was created successfully
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/phoneBook?searchPattern=&startIndex=0&itemCount=2147483647&externalEntries=true :=> phoneBookResponse
Then verifying phoneBook requested response ${phoneBookResponse} contains roles from table:
| key     | name      |
| entry1  | RoleTest1 |

Scenario: Delete new added role
When deleting Roles sub-menu item: RoleTest1
Then an alert box dialog pops-up with message: Are you sure you want to delete the role RoleTest1?

When clicking on Yes button of Delete alert box dialog
Then waiting 8 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: The file was successfully deleted.

Scenario: Close Missions and Roles menu
When selecting Missions and Roles item in main menu

Scenario: Clean-up - Refresh Configurator
Then refresh Configurator
