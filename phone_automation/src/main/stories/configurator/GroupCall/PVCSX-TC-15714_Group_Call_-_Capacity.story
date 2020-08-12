Meta:
@TEST_CASE_VERSION: V3
@TEST_CASE_NAME: Group Call - Capacity
@TEST_CASE_DESCRIPTION: 
As a system technician using Configuration Management
I want to add the maximum number of Group Calls (see Capacity_NumberOfGroupCallsPerSystem)
So I can verify that they are added correctly in the Group Calls page and exceeding the maximum number is signalized with an error message for the user
@TEST_CASE_PRECONDITION: Group Calls page, found in Configuration Management, area Global settings - Telephone, has to be empty.
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed when maximum number of Group Calls (see Capacity_NumberOfGroupCallsPerSystem) are correctly added in the Group Calls page and exceeding the maximum number is signalized with an error message for the user
@TEST_CASE_DEVICES_IN_USE: 
Firefox browser
Configuration Management accessible from the machine where test is run
@TEST_CASE_ID: PVCSX-TC-15714
@TEST_CASE_GLOBAL_ID: GID-5649736
@TEST_CASE_API_ID: 20078260

Scenario: Preparation step - save roles ids
Given the roles ids for configurator <<xvp.configurator.url>> are saved in list defaultRoles

Scenario: Preparation step - delete Group Calls
Then replace existing group calls from <<xvp.configurator.url>> using an empty group calls file found in path /configuration-files/<<systemName>>/GroupCalls/Empty_GroupCalls/

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
@TEST_STEP_REF: [CATS-REF: tECk]
Then configurator management page is visible

Scenario: 2. Configurator: Select 'Global settings - Telephone' menu
Meta:
@TEST_STEP_ACTION: Configurator: Select 'Global settings - Telephone' menu
@TEST_STEP_REACTION: Configurator: The following menus are visible - Call Route Selectors, Phone Book, Group Calls and Phone Data
@TEST_STEP_REF: [CATS-REF: YcVO]
When selecting Global settings - Telephone item in main menu
Then Global settings - Telephone menu item contains following sub-menu items: <<GLOBAL_SETTINGS-TELEPHONE_SUB_MENUS>>

Scenario: 3. Configurator: Select sub-menu 'Group Calls'
Meta:
@TEST_STEP_ACTION: Configurator: Select sub-menu 'Group Calls'
@TEST_STEP_REACTION: Configurator: Group Calls page is visible
@TEST_STEP_REF: [CATS-REF: IFuA]
When selecting Group Calls sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Group Calls

Scenario: 4. Configurator: Click on 'New' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'New' button
@TEST_STEP_REACTION: Configurator: Group Calls Editor page is visible
@TEST_STEP_REF: [CATS-REF: 6NNw]
When New button is pressed in Group Calls sub-menu
Then editor page Group Calls is visible

Scenario: 5. Configurator: Fill in the following fields: 'Name', 'Display name', 'Destination' area.
Meta:
@TEST_STEP_ACTION: Configurator: Fill in the following fields: 'Name', 'Display name', 'Destination' area.
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'Destination', are displaying correctly the values selected or filled in. 'Resulting SIP URI' value is displayed according to the selected 'Call Route Selector' and 'Destination' input field.
@TEST_STEP_REF: [CATS-REF: Vj0H]
When add a new group call with:
| key   | name           | displayName      | callRouteSelector | destination                |
| entry | GroupCallTest1 | GroupCallTest1   | none              | GroupCallTest1@example.com |

Then verify group call fields contain:
| key   | name           | displayName    | callRouteSelector | destination                | resultingSipUri                |
| entry | GroupCallTest1 | GroupCallTest1 | none              | GroupCallTest1@example.com | sip:GroupCallTest1@example.com |

Scenario: 6. Configurator: Click on 'Save' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: A pop-up message displays "Successfully saved the group call entry"
@TEST_STEP_REF: [CATS-REF: A5eE]
Then Save button is pressed in Group Calls editor
Then waiting 7 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the group call entry

Scenario: 7. Configurator: Group Calls page is visible and has 1 new item.
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Group Calls page is visible and has 1 new item.
@TEST_STEP_REF: [CATS-REF: fx6x]
Then list size for Group Calls is: 1
Then group call GroupCallTest1 is displayed in Group Calls list

Scenario: 8. Configurator: Verify that 'Group calls' list newest item is by default selected and correct values are displayed
Meta:
@TEST_STEP_ACTION: Configurator: Verify that 'Group calls' list newest item is by default selected and correct values are displayed
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'Destination' are displaying correctly the values selected or filled in at step 5.
@TEST_STEP_REF: [CATS-REF: VgnC]
Then verify group call fields contain:
| key   | name           | displayName      | callRouteSelector | destination                | resultingSipUri                |
| entry | GroupCallTest1 | GroupCallTest1   | none              | GroupCallTest1@example.com | sip:GroupCallTest1@example.com |

Scenario: 9. Configurator: Repeat steps 4 to 8 for (Capacity_NumberOfGroupCallsPerSystem-1) times
Meta:
@TEST_STEP_ACTION: Configurator: Repeat steps 4 to 8 for (Capacity_NumberOfGroupCallsPerSystem-1) times
@TEST_STEP_REACTION: Configurator: Group Calls page is visible and has Capacity_NumberOfGroupCallsPerSystem new items
@TEST_STEP_REF: [CATS-REF: NdZQ]
Scenario: 9.1 Deleting existing group calls
Then replace existing group calls from <<xvp.configurator.url>> using an empty group calls file found in path /configuration-files/<<systemName>>/GroupCalls/Empty_GroupCalls/

Scenario: 9.2 Adding 90 group calls using REST
Then add 90 group calls to <<xvp.configurator.url>> using configured file found in path /configuration-files/<<systemName>>/GroupCalls/Preconfigured_GroupCalls/

Scenario: 9.3 Refresh page to get displayed the new added group calls
Then refresh Configurator

Scenario: 9.4 Open Group Calls sub-menu
When selecting Global settings - Telephone item in main menu
When selecting Group Calls sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Group Calls

Scenario: 9.5 Adding group calls until maximum is reached
When New button is pressed in Group Calls sub-menu
Then editor page Group Calls is visible

When add a new group call with:
| key   | name   | displayName   | callRouteSelector   | destination   |
| entry | <name> | <displayName> | <callRouteSelector> | <destination> |

Then verify group call fields contain:
| key   | name   | displayName   | callRouteSelector   | destination   | resultingSipUri   |
| entry | <name> | <displayName> | <callRouteSelector> | <destination> | <resultingSipUri> |

Then Save button is pressed in Group Calls editor
Then waiting 7 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the group call entry
Then group call <name> is displayed in Group Calls list

When select item <name> from Group Calls sub-menu items list
Then editor page Group Calls is visible

Then verify group call fields contain:
| key   | name   | displayName   | callRouteSelector   | destination   | resultingSipUri   |
| entry | <name> | <displayName> | <callRouteSelector> | <destination> | <resultingSipUri> |

Examples:
| name             | displayName      | callRouteSelector | destination                  | resultingSipUri                  |
| GroupCallTest91  | GroupCallTest91  | none              | GroupCallTest91@example.com  | sip:GroupCallTest91@example.com  |
| GroupCallTest92  | GroupCallTest92  | none              | GroupCallTest92@example.com  | sip:GroupCallTest92@example.com  |
| GroupCallTest93  | GroupCallTest93  | none              | GroupCallTest93@example.com  | sip:GroupCallTest93@example.com  |
| GroupCallTest94  | GroupCallTest94  | none              | GroupCallTest94@example.com  | sip:GroupCallTest94@example.com  |
| GroupCallTest95  | GroupCallTest95  | none              | GroupCallTest95@example.com  | sip:GroupCallTest95@example.com  |
| GroupCallTest96  | GroupCallTest96  | none              | GroupCallTest96@example.com  | sip:GroupCallTest96@example.com  |
| GroupCallTest97  | GroupCallTest97  | none              | GroupCallTest97@example.com  | sip:GroupCallTest97@example.com  |
| GroupCallTest98  | GroupCallTest98  | none              | GroupCallTest98@example.com  | sip:GroupCallTest98@example.com  |
| GroupCallTest99  | GroupCallTest99  | none              | GroupCallTest99@example.com  | sip:GroupCallTest99@example.com  |
| GroupCallTest100 | GroupCallTest100 | none              | GroupCallTest100@example.com | sip:GroupCallTest100@example.com |

Scenario: 10. Configurator: Repeat steps 4 and 5
Meta:
@TEST_STEP_ACTION: Configurator: Repeat steps 4 and 5
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'Destination' are displaying correctly the values filled in
@TEST_STEP_REF: [CATS-REF: a15K]
When New button is pressed in Group Calls sub-menu
Then editor page Group Calls is visible
When add a new group call with:
| key   | name             | displayName      | callRouteSelector | destination                  |
| entry | GroupCallTest101 | GroupCallTest101 | none              | GroupCallTest101@example.com |

Then verify group call fields contain:
| key   | name             | displayName      | callRouteSelector | destination                  | resultingSipUri                  |
| entry | GroupCallTest101 | GroupCallTest101 | none              | GroupCallTest101@example.com | sip:GroupCallTest101@example.com |

Scenario: 11. Configurator: Click on 'Save' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: A pop-up message displays "Could not save the groupcall entry: The maximum number of group calls 100 is exceeded"
@TEST_STEP_REF: [CATS-REF: Yq4r]
Then Save button is pressed in Group Calls editor
Then waiting 5 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the groupcall entry: The maximum number of group calls 100 is exceeded

Scenario: 12. Configurator: Close pop-up message
Meta:
@TEST_STEP_ACTION: Configurator: Close pop-up message
@TEST_STEP_REACTION: Configurator: Pop-up message is closed
@TEST_STEP_REF: [CATS-REF: aFt9]
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible


Scenario: 13. Configurator: Select a 'Group Call' item
Meta:
@TEST_STEP_ACTION: Configurator: Select a 'Group Call' item
@TEST_STEP_REACTION: Configurator: Configurator: A pop-up window shows saying "You have unsaved changes and are about to leave this page. if you leave, your changes will be discarded". Window has 2 option buttons: "Discard changes" and "Stay on this page"
@TEST_STEP_REF: [CATS-REF: 5t1l]
When select item GroupCallTest1 from Group Calls sub-menu items list
Then an alert box dialog pops-up with message: <<discardMessage>>

Scenario: 14. Configurator: Choose to discard changes
Meta:
@TEST_STEP_ACTION: Configurator: Choose to discard changes
@TEST_STEP_REACTION: Configurator: Group Calls page is visible and has Capacity_NumberOfGroupCallsPerSystem new items
@TEST_STEP_REF: [CATS-REF: yejB]
When clicking on Discard changes button of Discard alert box dialog
Then list size for Group Calls is: 101

Scenario: Backend verification - check in Group Calls that new Group Calls were created successfully
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/groupcalls :=> response
Then verifying group calls requested response ${response} contains new added maximum number of group calls

Scenario: Delete new added Group Calls
When deleting Group Calls sub-menu item: <name>
Then an alert box dialog pops-up with message: Are you sure you want to delete the call group <name>?

When clicking on Yes button of Delete alert box dialog
Then waiting 7 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: The file was successfully deleted.

Examples:
| name            | displayName     | callRouteSelector | destination                 | resultingSipUri                 |
| GroupCallTest1  | GroupCallTest1  | none              | GroupCallTest1@example.com  | sip:GroupCallTest1@example.com  |
| GroupCallTest2  | GroupCallTest2  | none              | GroupCallTest2@example.com  | sip:GroupCallTest2@example.com  |
| GroupCallTest3  | GroupCallTest3  | none              | GroupCallTest3@example.com  | sip:GroupCallTest3@example.com  |
| GroupCallTest4  | GroupCallTest4  | none              | GroupCallTest4@example.com  | sip:GroupCallTest4@example.com  |
| GroupCallTest5  | GroupCallTest5  | none              | GroupCallTest5@example.com  | sip:GroupCallTest5@example.com  |
| GroupCallTest6  | GroupCallTest6  | none              | GroupCallTest6@example.com  | sip:GroupCallTest6@example.com  |
| GroupCallTest7  | GroupCallTest7  | none              | GroupCallTest7@example.com  | sip:GroupCallTest7@example.com  |
| GroupCallTest8  | GroupCallTest8  | none              | GroupCallTest8@example.com  | sip:GroupCallTest8@example.com  |
| GroupCallTest9  | GroupCallTest9  | none              | GroupCallTest9@example.com  | sip:GroupCallTest9@example.com  |
| GroupCallTest10 | GroupCallTest10 | none              | GroupCallTest10@example.com | sip:GroupCallTest10@example.com |

Scenario: Close Global settings - Telephone
When selecting Global settings - Telephone item in main menu

Scenario: Clean-up - Add default group calls and roles into configurator
Then add default group calls to <<xvp.configurator.url>> using default group calls file found in path /configuration-files/<<systemName>>/GroupCalls/Default_GroupCalls/
Then add roles to <<xvp.configurator.url>> using configurators with ids from lists defaultRoles found in path /configuration-files/<<systemName>>/Roles_default/roleconfiguration/

Scenario: Clean-up - Refresh Configurator
Then refresh Configurator
Then waiting for 2 seconds

Scenario: Open Group Calls sub-menu
When selecting Global settings - Telephone item in main menu
When selecting Group Calls sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Group Calls

Scenario: Select group call item
When select item TestGroupCall from Group Calls sub-menu items list

Scenario: Save in order to send modifications to the other configurators
Then press Save button when no changes were done
Then waiting 5 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the group call entry

Scenario: Close Global settings - Telephone
When selecting Global settings - Telephone item in main menu

Scenario: Clean-up - Refresh Configurator
Then refresh Configurator
