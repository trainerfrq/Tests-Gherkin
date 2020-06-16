Meta:
@TEST_CASE_VERSION: V5
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
Then waiting 5 seconds for LoadingScreen to disappear
When selecting Missions and Roles item in main menu

Scenario: 1. System Technician: Open a Configuration Management page.
Meta:
@TEST_STEP_ACTION: System Technician: Open a Configuration Management page.
@TEST_STEP_REACTION: Configurator: Configuration Management page is visible
@TEST_STEP_REF: [CATS-REF: DykO]
Then configurator management page is visible

Scenario: 2. System Technician: Click on Missions and Roles menu
Meta:
@TEST_STEP_ACTION: System Technician: Click on Missions and Roles menu
@TEST_STEP_REACTION: Configurator: Sub menus: Roles, Roles-Radio configuration, Missions, Template: Frequency Permissions, Template: Radio Settings are visible
@TEST_STEP_REF: [CATS-REF: q83V]
When selecting Missions and Roles item in main menu
Then Missions and Roles menu item contains following sub-menu items: <<MISSIONS_AND_ROLES_SUB_MENUS>>

Scenario: 3. System Technician: Click on Roles sub-menu
Meta:
@TEST_STEP_ACTION: System Technician: Click on Roles sub-menu
@TEST_STEP_REACTION: Configurator: Roles page is visible
@TEST_STEP_REF: [CATS-REF: oy7M]
When selecting Roles sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Roles

Scenario: 4. System Technician: Click on New button
Meta:
@TEST_STEP_ACTION: System Technician: Click on New button
@TEST_STEP_REACTION: Configurator: Role Editor page is visible
@TEST_STEP_REF: [CATS-REF: BhBP]
When New button is pressed in Roles sub-menu
Then editor page Roles is visible

Scenario: 5. Click on Save button
Meta:
@TEST_STEP_ACTION: System Technician: Click on Save button
@TEST_STEP_REACTION: Configurator: Warning -The field is required- is displayed for Name input field
@TEST_STEP_REF: [CATS-REF: hZv5]
Then Save button is pressed in Roles editor
Then warning message The field is required! is displayed for field Name from Roles editor

Scenario: 5.1 Click on Save button
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Warning -The field is required- is displayed for Display name input field
@TEST_STEP_REF: [CATS-REF: jCdC]
Then warning message The field is required! is displayed for field Display name from Roles editor

Scenario: 5.2 Click on Save button
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Warning -The field is required- is displayed for Layout drop down
@TEST_STEP_REF: [CATS-REF: f7n4]
Then warning message The field is required! is displayed for field Layout from Roles editor

Scenario: 5.3 Click on Save button
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Warning -The field is required- is displayed for Destination input field
@TEST_STEP_REF: [CATS-REF: 5WNK]
Then warning message The field is required! is displayed for field Destination from Roles editor

Scenario: 5.4 Click on Save button
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Warning -The field is required- is displayed for Default Source for outgoing calls drop-down
@TEST_STEP_REF: [CATS-REF: vaxD]
Then warning message The field is required! is displayed for field Default Source for outgoing calls from Roles editor

Scenario: 6. Add new Role
Meta:
@TEST_STEP_ACTION: System Technician: Enter new Role details
@TEST_STEP_REACTION: CConfigurator: New Role details are displayed
@TEST_STEP_REF: [CATS-REF: jVAl]
When add a new role with:
| key   | name      | displayName | layout     | callRouteSelector | destination | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | twr-layout | default           | RoleTest1   | RoleTest1                  |

Then verify role fields contain:
| key   | name      | displayName | layout     | callRouteSelector | destination | resultingSipUri           | defaultSourceOutgoingCalls |
| entry | RoleTest1 | RoleTest1   | twr-layout | default           | RoleTest1   | sip:RoleTest1@example.com | RoleTest1                  |


Scenario: 7. System Technician: Press save button
Meta:
@TEST_STEP_ACTION: System Technician: Press save button
@TEST_STEP_REACTION: Configurator: A pop-up message displays: Could not save the role: Role name must be unique
@TEST_STEP_REF: [CATS-REF: 0Zpx]
Then Save button is pressed in Roles editor
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the role: Role name must be unique


Scenario: 7.1 System Technician: Press save button
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Role RoleTest1 is not displayed twice in Roles list
@TEST_STEP_REF: [CATS-REF: 99E2]
Then role RoleTest1 is displayed in Roles list


Scenario: 8. System Technician: Close pop-up message
Meta:
@TEST_STEP_ACTION: System Technician: Close pop-up message
@TEST_STEP_REACTION: Configurator: Pop-up message is closed
@TEST_STEP_REF: [CATS-REF: HCUc]
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible

Scenario: 8.1 Clear Name input field
Then clear content of Name input field from Roles sub menu

Scenario: 9. System Technician: Enter RoleTest2 in Name input field
Meta:
@TEST_STEP_ACTION: System Technician: Enter RoleTest2 in Name input field
@TEST_STEP_REACTION: Configurator: RoleTest2 is displayed in Name input field and Default Source for outgoing calls
@TEST_STEP_REF: [CATS-REF: kh62]
When update a role with:
| key   | name      |
| entry | RoleTest2 |

Then verify role fields contain:
| key   | name      | defaultSourceOutgoingCalls |
| entry | RoleTest2 | RoleTest2                  |


Scenario: 10. System Technician: Press save button
Meta:
@TEST_STEP_ACTION: System Technician: Press save button
@TEST_STEP_REACTION: Configurator: A pop-up message displays: Successfully saved the role
@TEST_STEP_REF: [CATS-REF: Lwna]
Then Save button is pressed in Roles editor
Then waiting 5 seconds for LoadingScreen to disappear

Scenario: 10.1 Verifying pop-up message
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the role

Scenario: 10.2 System Technician: Press save button
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Role RoleTest2 is displayed in Roles list
@TEST_STEP_REF: [CATS-REF: g4KY]
Then role RoleTest2 is displayed in Roles list


Scenario: 11. System Technician: Click on RoleTest2 from Roles list
Meta:
@TEST_STEP_ACTION: System Technician: Click on RoleTest2 from Roles list
@TEST_STEP_REACTION: Configurator: Role editor page is visible
@TEST_STEP_REF: [CATS-REF: R8fm]
When select item RoleTest2 from Roles sub-menu items list
Then editor page Roles is visible


Scenario: 12. Verifying added Role data
Meta:
@TEST_STEP_ACTION: System Technician: Verify added Role fields
@TEST_STEP_REACTION: Configurator: Added Role fields display inserted values
@TEST_STEP_REF: [CATS-REF: n00J]
Then verify role fields contain:
| key   | name      | displayName | layout     | callRouteSelector | destination | resultingSipUri           | defaultSourceOutgoingCalls |
| entry | RoleTest2 | RoleTest1   | twr-layout | default           | RoleTest1   | sip:RoleTest1@example.com | RoleTest2                  |



!-- Scenario: Autogenerated Scenario 34
!-- Meta:
!-- @TEST_STEP_ACTION: System Technician: Access address <Configuration Management page IP>/configurations/op-voice-service/roles and check for RoleTest1 and RoleTest2
!-- @TEST_STEP_REACTION: Configurator: A page with Roles in JSON format is visible. RoleTest1 and RoleTest2 are displayed containing inserted information
!-- @TEST_STEP_REF: [CATS-REF: LtZK]
!-- When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/roles :=> response
!-- Then verifying roles requested response ${response} contains roles <<ROLES_LIST>> and role RoleTest2


!-- Scenario: Autogenerated Scenario 36
!-- Meta:
!-- @TEST_STEP_ACTION:
!-- System Technician: Acces address <Configuration Management page IP>/configurations/op-voice-service/phoneBook?searchPattern=&startIndex=0&itemCount=2147483647&externalEntries=true and check for RoleTest1 and RoleTest2
!-- @TEST_STEP_REACTION: Configurator: A page with Phone Book entries in JSON (collapsed) format is visible. RoleTest1 and RoleTest2 are displayed containing inserted information
!-- @TEST_STEP_REF: [CATS-REF: gjxI]
!-- When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/phoneBook?searchPattern=&startIndex=0&itemCount=2147483647&externalEntries=true :=> phoneBookResponse
!-- Then verifying phoneBook requested response ${phoneBookResponse} contains roles <<ROLES_LIST>> and role RoleTest1

