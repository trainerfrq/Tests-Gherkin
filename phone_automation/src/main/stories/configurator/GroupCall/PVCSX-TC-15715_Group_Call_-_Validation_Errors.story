Meta:
@TEST_CASE_VERSION: V8
@TEST_CASE_NAME: Group Call - Validation Errors
@TEST_CASE_DESCRIPTION:
As a system technician using a Configuration Management page
I want to add a new Group Call leaving required fields empty
So I can verify that a warning message is displayed next to required empty fields
@TEST_CASE_PRECONDITION: Group Call "GroupCallTest1" available with:	Name: GroupCallTest1	Display name: GroupCallTest1	Resulting SIP URI: sip:GroupCallTest1@example.com
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, if the system indicates validation errors and the reasons of the errors for the targeted fields
@TEST_CASE_DEVICES_IN_USE: Configuration Management
@TEST_CASE_ID: PVCSX-TC-15715
@TEST_CASE_GLOBAL_ID: GID-5649747
@TEST_CASE_API_ID: 20078384

Scenario: Book profile
Given booked profiles:
| profile | group                  | host       |
| web     | firefox_<<systemName>> | <<CO3_IP>> |

Scenario: Define XVP Configurator page
Given defined XVP Configurator:
| key    | profile                    | url                      |
| config | web firefox_<<systemName>> | <<xvp.configurator.url>> |

Scenario: Precondition - Add GroupCallTest1
When selecting Global settings - Telephone item in main menu
When selecting Group Calls sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
When New button is pressed in Group Calls sub-menu
Then editor page Group Calls is visible
When add a new group call with:
| key   | name           | displayName      | callRouteSelector | destination                |
| entry | GroupCallTest1 | GroupCallTest1   | none              | GroupCallTest1@example.com |

Then verify group call fields contain:
| key   | name           | displayName    | callRouteSelector | destination                | resultingSipUri                |
| entry | GroupCallTest1 | GroupCallTest1 | none              | GroupCallTest1@example.com | sip:GroupCallTest1@example.com |

Then Save button is pressed in Group Calls editor
Then waiting 7 seconds for LoadingScreen to disappear
When selecting Global settings - Telephone item in main menu

Scenario: 1. Configurator: The main page of Configuration Management is open
Meta:
@TEST_STEP_ACTION: Configurator: The main page of Configuration Management is open
@TEST_STEP_REACTION: Configurator: Configuration Management page is visible
@TEST_STEP_REF: [CATS-REF: 2UeP]
Then configurator management page is visible

Scenario: 2. Configurator: Select "Global settings - Telephone" menu
Meta:
@TEST_STEP_ACTION: Configurator: Select "Global settings - Telephone" menu
@TEST_STEP_REACTION: Configurator: The following menus are visible - Call Route Selectors, Phone Book, Group Calls and Phone Data
@TEST_STEP_REF: [CATS-REF: yt4b]
When selecting Global settings - Telephone item in main menu
Then Global settings - Telephone menu item contains following sub-menu items: <<GLOBAL_SETTINGS-TELEPHONE_SUB_MENUS>>

Scenario: 3. Configurator: Select sub-menu "Group Calls"
Meta:
@TEST_STEP_ACTION: Configurator: Select sub-menu "Group Calls"
@TEST_STEP_REACTION: Configurator: Group Calls page is visible
@TEST_STEP_REF: [CATS-REF: NlOF]
When selecting Group Calls sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Group Calls

Scenario: 4. Configurator: Click on "New" button
Meta:
@TEST_STEP_ACTION: Configurator: Click on "New" button
@TEST_STEP_REACTION: Configurator: Group Calls Editor page is visible
@TEST_STEP_REF: [CATS-REF: lR7U]
When New button is pressed in Group Calls sub-menu
Then editor page Group Calls is visible

Scenario: 5. Configurator: Click on "Save" button
Meta:
@TEST_STEP_ACTION: Configurator: Click on "Save" button
@TEST_STEP_REACTION: Configurator: Warning "The field is required" is displayed for input fields: "Name", "Display name" and "Destination".
@TEST_STEP_REF: [CATS-REF: K0YL]
Then Save button is pressed in Group Calls editor
Then warning message <<REQUIRED_FIELD_MESSAGE>> is displayed for field Name from Group Calls editor
Then warning message <<REQUIRED_FIELD_MESSAGE>> is displayed for field Display name from Group Calls editor
Then warning message <<REQUIRED_FIELD_MESSAGE>> is displayed for field Destination from Group Calls editor

Scenario: 6. Configurator: Fill in "GroupCallTest1" in "Name" input field, "GroupCallTest1" in "Display name" input field and "sip:GroupCallTest1-at-example.com" in "Destination" input field.
Meta:
@TEST_STEP_ACTION: Configurator: Fill in "GroupCallTest1" in "Name" input field, "GroupCallTest1" in "Display name" input field and "sip:GroupCallTest1-at-example.com" in "Destination" input field.
@TEST_STEP_REACTION: Configurator: "Name", "Display name", "Destination", are displaying correctly the values filled in. "Resulting SIP URI" value is displayed according to the selected "Call Route Selector" and "Destination" input field.
@TEST_STEP_REF: [CATS-REF: 9Gd4]
When add a new group call with:
| key   | name           | displayName      | callRouteSelector | destination                |
| entry | GroupCallTest1 | GroupCallTest1   | none              | GroupCallTest1@example.com |

Then verify group call fields contain:
| key   | name           | displayName    | callRouteSelector | destination                | resultingSipUri                |
| entry | GroupCallTest1 | GroupCallTest1 | none              | GroupCallTest1@example.com | sip:GroupCallTest1@example.com |

Scenario: 7. Configurator: Click on "Save" button
Meta:
@TEST_STEP_ACTION: Configurator: Click on "Save" button
@TEST_STEP_REACTION:  Configurator: A pop-up message displays "Could not save the groupcall entry: Group call name must be unique."
@TEST_STEP_REF: [CATS-REF: zt95]
Then Save button is pressed in Group Calls editor
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the groupcall entry: Group call name must be unique.

Scenario: 8. Configurator: Group Call "GroupCallTest1" is not displayed twice in Group Calls list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Group Call "GroupCallTest1" is not displayed twice in Group Calls list
@TEST_STEP_REF: [CATS-REF: k43S]
Then list size for Group Calls is: 3

Scenario: 9. Configurator: Close pop-up message
Meta:
@TEST_STEP_ACTION: Configurator: Close pop-up message
@TEST_STEP_REACTION:  Configurator: Pop-up message is closed
@TEST_STEP_REF: [CATS-REF: Cpu7]
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible

Scenario: 9.1 Clear Name input field
Then clear content of Name input field from Group Calls sub menu

Scenario: 10. Configurator: Enter "GroupCallTest2" in "Name" input field
Meta:
@TEST_STEP_ACTION: Configurator: Enter "GroupCallTest2" in "Name" input field
@TEST_STEP_REACTION: Configurator: "GroupCallTest2" is displayed in "Name" input field
@TEST_STEP_REF: [CATS-REF: kXLJ]
When update a group call with:
| key   | name           |
| entry | GroupCallTest2 |

Then verify group call fields contain:
| key   | name           |
| entry | GroupCallTest2 |

Scenario: 11. Configurator: Click on "Save" button
Meta:
@TEST_STEP_ACTION: Configurator: Click on "Save" button
@TEST_STEP_REACTION: Configurator: A pop-up message displays "Successfully saved the group call entry"
@TEST_STEP_REF: [CATS-REF: mA46]
Then Save button is pressed in Group Calls editor
Then waiting 7 seconds for LoadingScreen to disappear

Scenario: 11.1 Verifying pop-up message
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the group call entry

Scenario: 12. Group Call "GroupCallTest2" is displayed in Group Calls list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Group Call GroupCallTest2 is displayed in Group Calls list
@TEST_STEP_REF: [CATS-REF: g4KY]
Then group call GroupCallTest2 is displayed in Group Calls list

Scenario: 13. Configurator: Verify that "GroupCallTest2" is by default selected and inserted values are displayed in Group Call editor
Meta:
@TEST_STEP_ACTION: Configurator: Verify that "GroupCallTest2" is by default selected and inserted values are displayed in Group Call editor
@TEST_STEP_REACTION: Configurator: "Name", "Display name", "Destination" are displaying correctly the values filled in at step 5 with modifications from step 10.
@TEST_STEP_REF: [CATS-REF: Tb1O]
Then verify group call fields contain:
| key   | name           | displayName    | callRouteSelector | destination                | resultingSipUri                |
| entry | GroupCallTest2 | GroupCallTest1 | none              | GroupCallTest1@example.com | sip:GroupCallTest1@example.com |

Scenario: Backend verification - check in Group Calls that new Group Calls were created successfully
When issuing http GET request to endpoint <<configurationMngEndpoint>> and path configurations/op-voice-service/groupcalls :=> response
Then verifying group calls requested response ${response} contains group calls from table:
| key     | name           |
| entry1  | GroupCallTest1 |
| entry1  | GroupCallTest2 |

Scenario: Delete new added group calls
When deleting Group Calls sub-menu item: <name>
Then an alert box dialog pops-up with message: Are you sure you want to delete the call group <name>?

When clicking on Yes button of Delete alert box dialog
Then waiting 7 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: The file was successfully deleted.

Examples:
| name            | displayName      | callRouteSelector  | destination                |
| GroupCallTest1  | GroupCallTest1   | none               | GroupCallTest1@example.com |
| GroupCallTest2  | GroupCallTest2   | none               | GroupCallTest2@example.com |

Scenario: Close Global settings - Telephone menu
When selecting Global settings - Telephone item in main menu

Scenario: Clean-up - Refresh Configurator
Then refresh Configurator
