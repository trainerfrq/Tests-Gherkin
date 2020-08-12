Meta:
@TEST_CASE_VERSION: V7
@TEST_CASE_NAME: Role - Validation Errors
@TEST_CASE_DESCRIPTION: 
As a system technician surfing on Configuration Management page
I want to add a new Role leaving required fields empty
So I can verify that a warning message is displayed next to required empty fields
@TEST_CASE_PRECONDITION: 
Layout layoutTest available (Voice-HMI Layout menu -&gt; HMI Layouts)
Call Route Selector default available (Global settings - Telephone menu -&gt; Call Route Selectors) with:	Name: default	Display name: Default	Domain: example.com
Role RoleTest1 available (Missions and Roles menu -&gt; Roles) with:	Name: RoleTest1	Display name: RoleTest1	Layout: layoutTest	Resulting SIP URI: sip:RoleTest1@example.com	Default Source for outgoing calls: RoleTest1
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, if the system indicates validation errors and the reasons of the errors for the targeted fields
@TEST_CASE_DEVICES_IN_USE: Configurator
@TEST_CASE_ID: PVCSX-TC-15285
@TEST_CASE_GLOBAL_ID: GID-5480718
@TEST_CASE_API_ID: 19436592

Scenario: Book profile
Given booked profiles:
| profile | group                  | host       |
| web     | firefox_<<systemName>> | <<CO3_IP>> |

Given defined XVP Configurator:
| key    | profile                    | url                      |
| config | web firefox_<<systemName>> | <<xvp.configurator.url>> |

Scenario: Precondition - Add RoleTest1
When selecting Missions and Roles item in main menu
When selecting Roles sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
When New button is pressed in Roles sub-menu
Then editor page Roles is visible
When add a new role with:
| key   | name      | displayName | layout     | callRouteSelector | destination | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | twr-layout | default           | RoleTest1   | RoleTest1                  |

Then verify role fields contain:
| key   | name      | displayName | layout     | callRouteSelector | destination | resultingSipUri           | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | twr-layout | default           | RoleTest1   | sip:RoleTest1@example.com | RoleTest1                  |

Then Save button is pressed in Roles editor
Then waiting 8 seconds for LoadingScreen to disappear
When selecting Missions and Roles item in main menu

Scenario: 1. Configurator: The main page of Configuration Management is open
Meta:
@TEST_STEP_ACTION: Configurator: The main page of Configuration Management is open
@TEST_STEP_REACTION: Configurator: Configuration Management page is visible
@TEST_STEP_REF: [CATS-REF: DykO]
Then configurator management page is visible

Scenario: 2. Configurator: Select 'Missions and Roles' menu
Meta:
@TEST_STEP_ACTION: Configurator: Select 'Missions and Roles' menu
@TEST_STEP_REACTION: Configurator: The following sub-menus are visible - Roles, Roles-Radio configuration, Missions, Template: Frequency Permissions, Template: Radio Settings
@TEST_STEP_REF: [CATS-REF: q83V]
When selecting Missions and Roles item in main menu
Then Missions and Roles menu item contains following sub-menu items: <<MISSIONS_AND_ROLES_SUB_MENUS>>

Scenario: 3. Configurator: Select 'Roles' sub-menu
Meta:
@TEST_STEP_ACTION: Configurator: Select 'Roles' sub-menu
@TEST_STEP_REACTION: Configurator: Roles page is visible
@TEST_STEP_REF: [CATS-REF: oy7M]
When selecting Roles sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Roles

Scenario: 4. Configurator: Click on 'New' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'New' button
@TEST_STEP_REACTION: Configurator: Role Editor page is visible
@TEST_STEP_REF: [CATS-REF: BhBP]
When New button is pressed in Roles sub-menu
Then editor page Roles is visible

Scenario: 5. Configurator: Click on 'Save' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: Warning 'The field is required' is displayed for input fields: 'Name', 'Display name', 'Destination' and drop downs: 'Layout', 'Default Source for outgoing calls'
@TEST_STEP_REF: [CATS-REF: hZv5]
Then Save button is pressed in Roles editor
Then warning message <<REQUIRED_FIELD_MESSAGE>> is displayed for field Name from Roles editor
Then warning message <<REQUIRED_FIELD_MESSAGE>> is displayed for field Display name from Roles editor
Then warning message <<REQUIRED_FIELD_MESSAGE>> is displayed for field Layout from Roles editor
Then warning message <<REQUIRED_FIELD_MESSAGE>> is displayed for field Destination from Roles editor
Then warning message <<REQUIRED_FIELD_MESSAGE>> is displayed for field Default Source for outgoing calls from Roles editor

Scenario: 6. Configurator: Enter - 'RoleTest1' in 'Name' input field, 'RoleTest1' in 'Display name', 'RoleTest1' in 'Destination'; Select - 'layoutTest' from 'Layout', 'default' from 'Call Route Selector', 'RoleTest1' from 'Default Source for outgoing calls'
Meta:
@TEST_STEP_ACTION: Configurator: Enter - 'RoleTest1' in 'Name' input field, 'RoleTest1' in 'Display name', 'RoleTest1' in 'Destination'; Select - 'layoutTest' from 'Layout', 'default' from 'Call Route Selector', 'RoleTest1' from 'Default Source for outgoing calls'
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'Destination', 'Layout', 'Call Route Selector', 'Default Source of outgoing calls' are displaying correctly the values selected or filled in. 'Resulting SIP URI' value is displayed according to the selected 'Call Route Selector' and 'Destination' input field.
@TEST_STEP_REF: [CATS-REF: jVAl]
When add a new role with:
| key   | name      | displayName | layout     | callRouteSelector | destination | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | twr-layout | default           | RoleTest1   | RoleTest1                  |

Then verify role fields contain:
| key   | name      | displayName | layout     | callRouteSelector | destination | resultingSipUri           | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | twr-layout | default           | RoleTest1   | sip:RoleTest1@example.com | RoleTest1                  |

Scenario: 7. Configurator: Click on 'Save' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: A pop-up message displays: Could not save the role: Role name must be unique
@TEST_STEP_REF: [CATS-REF: 0Zpx]
Then Save button is pressed in Roles editor
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the role: Role name must be unique

Scenario: 8. Role RoleTest1 is not displayed twice in Roles list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: ConfiguratorBrowser: Role RoleTest1 is not displayed twice in Roles list
@TEST_STEP_REF: [CATS-REF: 99E2]
Then list size for Roles is: 26

Scenario: 9. Configurator: Close pop-up message
Meta:
@TEST_STEP_ACTION: Configurator: Close pop-up message
@TEST_STEP_REACTION: Configurator: Pop-up message is closed
@TEST_STEP_REF: [CATS-REF: HCUc]
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible

Scenario: 9.1 Clear Name input field
Then clear content of Name input field from Roles sub menu

Scenario: 10. Configurator: Enter RoleTest2 in Name input field
Meta:
@TEST_STEP_ACTION: Configurator: Enter RoleTest2 in Name input field
@TEST_STEP_REACTION: Configurator: RoleTest2 is displayed in Name and Default Source for outgoing calls
@TEST_STEP_REF: [CATS-REF: kh62]
When update a role with:
| key   | name      |
| entry | RoleTest2 |

Then verify role fields contain:
| key   | name      | defaultSourceOutgoingCalls |
| entry | RoleTest2 | RoleTest2                  |

Scenario: 11. Configurator: Click on 'Save' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: A pop-up message displays: Successfully saved the role
@TEST_STEP_REF: [CATS-REF: Lwna]
Then Save button is pressed in Roles editor
Then waiting 8 seconds for LoadingScreen to disappear

Scenario: 11.1 Verifying pop-up message
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the role

Scenario: 12. Role RoleTest2 is displayed in Roles list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Role RoleTest2 is displayed in Roles list
@TEST_STEP_REF: [CATS-REF: g4KY]
Then role RoleTest2 is displayed in Roles list

Scenario: 13. Configurator: Verify that RoleTest2 is by default selected and inserted values are displayed in Role editor
Meta:
@TEST_STEP_ACTION: Configurator: Verify that RoleTest2 is by default selected and inserted values are displayed in Role editor
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'Destination', 'Layout', 'Call Route Selector', 'Default Source of outgoing calls' are displaying correctly the values selected or filled in at step 5 with modifications from step 10.
@TEST_STEP_REF: [CATS-REF: R8fm]
Then verify role fields contain:
| key   | name      | displayName | layout     | callRouteSelector | destination | resultingSipUri           | defaultSourceOutgoingCalls |
| entry | RoleTest2 | RoleTest1   | twr-layout | default           | RoleTest1   | sip:RoleTest1@example.com | RoleTest2                  |

Scenario: Backend verification - check in roles that new roles were created successfully
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/roles :=> response
Then verifying roles requested response ${response} contains roles from table:
| key     | name      |
| entry1  | RoleTest1 |
| entry1  | RoleTest2 |

Scenario: Backend verification - check in phonebook that new roles were created successfully
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/phoneBook?searchPattern=&startIndex=0&itemCount=2147483647&externalEntries=true :=> phoneBookResponse
Then verifying phoneBook requested response ${phoneBookResponse} contains roles from table:
| key     | name      |
| entry1  | RoleTest1 |
| entry1  | RoleTest2 |

Scenario: Delete new added roles
When deleting Roles sub-menu item: <name>
Then an alert box dialog pops-up with message: Are you sure you want to delete the role <name>?

When clicking on Yes button of Delete alert box dialog
Then waiting 8 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: The file was successfully deleted.

Examples:
| name       | displayName | layout     | callRouteSelector  | destination            | defaultSourceOutgoingCalls |
| RoleTest1  | RoleTest1   | twr-layout | none               | RoleTest1@example.com  | RoleTest1                  |
| RoleTest2  | RoleTest1   | twr-layout | none               | RoleTest1@example.com  | RoleTest2                  |

Scenario: Close Missions and Roles menu
When selecting Missions and Roles item in main menu

Scenario: Clean-up - Refresh Configurator
Then refresh Configurator
