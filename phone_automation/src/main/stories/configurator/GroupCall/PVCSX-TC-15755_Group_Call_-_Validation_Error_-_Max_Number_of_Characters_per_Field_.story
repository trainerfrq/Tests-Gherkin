Meta:
@TEST_CASE_VERSION: V2
@TEST_CASE_NAME: Group Call - Validation Error - Max Number of Characters per Field 
@TEST_CASE_DESCRIPTION: 
As a system technician using a Configuration Management page
I want to add a new Group Call
AND write &lt;maximum number of characters&gt; characters in 'Name', 'Display name', 'Location', 'Organization', 'Comment' fields
So I can verify that a warning message pops-up after Save, displaying that max number of character was exceeded
@TEST_CASE_PRECONDITION: 
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed, if the system displays a pop-up indication error when trying to Save, after &lt;maximum number of characters&gt; characters are written in Name', 'Display name', 'Location', 'Organization', 'Comment' fields
@TEST_CASE_DEVICES_IN_USE: Configuration Management
@TEST_CASE_ID: PVCSX-TC-15755
@TEST_CASE_GLOBAL_ID: GID-5655920
@TEST_CASE_API_ID: 20093463

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
@TEST_STEP_REF: [CATS-REF: N5b0]
Then configurator management page is visible

Scenario: 2. Configurator: Select 'Global settings - Telephone' menu
Meta:
@TEST_STEP_ACTION: Configurator: Select 'Global settings - Telephone' menu
@TEST_STEP_REACTION: Configurator: The following menus are visible - Call Route Selectors, Phone Book, Group Calls and Phone Data
@TEST_STEP_REF: [CATS-REF: ya4F]
When selecting Global settings - Telephone item in main menu
Then Global settings - Telephone menu item contains following sub-menu items: <<GLOBAL_SETTINGS-TELEPHONE_SUB_MENUS>>

Scenario: 3. Configurator: Select sub-menu 'Group Calls'
Meta:
@TEST_STEP_ACTION: Configurator: Select sub-menu 'Group Calls'
@TEST_STEP_REACTION: Configurator: Group Calls page is visible
@TEST_STEP_REF: [CATS-REF: rX8q]
When selecting Group Calls sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Group Calls

Scenario: 4. Configurator: Click on 'New' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'New' button
@TEST_STEP_REACTION: Configurator: Group Calls Editor page is visible
@TEST_STEP_REF: [CATS-REF: pfmW]
When New button is pressed in Group Calls sub-menu
Then editor page Group Calls is visible

Scenario: 5. Configurator: Write 101 characters in 'Name' input field
Meta:
@TEST_STEP_ACTION: Configurator: Write 101 characters in 'Name' input field
@TEST_STEP_REACTION: Configurator: 101 characters are displayed in 'Name' input field
@TEST_STEP_REF: [CATS-REF: kw6E]
When add a new group call with:
| key   | name                      |
| entry | <<101_CHARACTERS_STRING>> |

Then verify group call fields contain:
| key   | name                      |
| entry | <<101_CHARACTERS_STRING>> |

Scenario: 6. Configurator: Fill in mandatory fields
Meta:
@TEST_STEP_ACTION: Configurator: Fill in mandatory fields
@TEST_STEP_REACTION: Configurator: Mandatory fields are filled in
@TEST_STEP_REF: [CATS-REF: eRSg]
When add a new group call with:
| key   | displayName   | callRouteSelector | destination               |
| entry | GroupCallTest | none              | GroupCallTest@example.com |

Then verify group call fields contain:
| key   | displayName   | callRouteSelector | destination               | resultingSipUri               |
| entry | GroupCallTest | none              | GroupCallTest@example.com | sip:GroupCallTest@example.com |

Scenario: 7. Configurator: Click on 'Save' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: Pop-up message displays "Could not save the groupcall entry: Maximum character length exceeded for field 'name'."
@TEST_STEP_REF: [CATS-REF: yOL9]
Then Save button is pressed in Group Calls editor
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the groupcall entry: Maximum character length exceeded for field 'name'.

Scenario: 8. Configurator: New group call is not displayed in group calls list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: New group call is not displayed in group calls list
@TEST_STEP_REF: [CATS-REF: qAOo]
Then group call <<101_CHARACTERS_STRING>> is not displayed in Group Calls list

Scenario: 9. Configurator: Close pop-up message
Meta:
@TEST_STEP_ACTION: Configurator: Close pop-up message
@TEST_STEP_REACTION: Configurator: Pop-up message is closed
@TEST_STEP_REF: [CATS-REF: UlQ0]
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible

Scenario: 10. Configurator: Write 1 character in input field from step 5
Meta:
@TEST_STEP_ACTION: Configurator: Write 1 character in input field from step 5
@TEST_STEP_REACTION: Configurator: 1 character is displayed in field from step 5
@TEST_STEP_REF: [CATS-REF: q7eO]
Then clear content of Name input field from Group Calls sub menu
When add a new group call with:
| key   | name |
| entry | 1    |

Then verify group call fields contain:
| key   | name |
| entry | 1    |

Scenario: 11. Configurator: Repeat steps 5-10 for 'Display name', 'Location', 'Organization', 'Comment' fields
Meta:
@TEST_STEP_ACTION: Configurator: Repeat steps 5-10 for 'Display name', 'Location', 'Organization', 'Comment' fields
@TEST_STEP_REACTION: Configurator: After each loop, updated group call is not displayed in group call list
@TEST_STEP_REF: [CATS-REF: FMCJ]
Scenario: 11.1.1 Clear 'Display nam'e input field
Then clear content of Display name input field from Group Calls sub menu

Scenario: 11.1.2 Configurator: Write 101 characters in 'Display name' input field
When add a new group call with:
| key   | displayName               |
| entry | <<101_CHARACTERS_STRING>> |

Then verify group call fields contain:
| key   | displayName               |
| entry | <<101_CHARACTERS_STRING>> |

Scenario: 11.1.3 Configurator: Click on 'Save' button
Then Save button is pressed in Group Calls editor
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the groupcall entry: Maximum character length exceeded for field 'displayName'.

Scenario: 11.1.4 Configurator: New group call is not displayed in group calls list
Then group call 1 is not displayed in Group Calls list

Scenario: 11.1.5 Configurator: Close pop-up message
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible

Scenario: 11.1.6 Configurator: Write 1 character in 'Display name' input field
Then clear content of Display name input field from Group Calls sub menu
When add a new group call with:
| key   | displayName |
| entry | 1           |

Then verify group call fields contain:
| key   | displayName |
| entry | 1           |

Scenario: 11.2.1 Clear 'Location' input field
Then clear content of Location input field from Group Calls sub menu

Scenario: 11.2.2 Configurator: Write 101 characters in 'Location' input field
When add a new group call with:
| key   | location                  |
| entry | <<101_CHARACTERS_STRING>> |

Then verify group call fields contain:
| key   | location                  |
| entry | <<101_CHARACTERS_STRING>> |

Scenario: 11.2.3 Configurator: Click on 'Save' button
Then Save button is pressed in Group Calls editor
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the groupcall entry: Maximum character length exceeded for field 'location'.

Scenario: 11.2.4 Configurator: New group call is not displayed in group calls list
Then group call 1 is not displayed in Group Calls list

Scenario: 11.2.5 Configurator: Close pop-up message
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible

Scenario: 11.2.6 Configurator: Write 1 character in 'Location' input field
Then clear content of Location input field from Group Calls sub menu
When add a new group call with:
| key   | location |
| entry | 1           |

Then verify group call fields contain:
| key   | location |
| entry | 1           |

Scenario: 11.3.1 Clear 'Organization' input field
Then clear content of Organization input field from Group Calls sub menu

Scenario: 11.3.2 Configurator: Write 101 characters in 'Organization' input field
When add a new group call with:
| key   | organization              |
| entry | <<101_CHARACTERS_STRING>> |

Then verify group call fields contain:
| key   | organization              |
| entry | <<101_CHARACTERS_STRING>> |

Scenario: 11.3.3 Configurator: Click on 'Save' button
Then Save button is pressed in Group Calls editor
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the groupcall entry: Maximum character length exceeded for field 'organization'.

Scenario: 11.3.4 Configurator: New group call is not displayed in group calls list
Then group call 1 is not displayed in Group Calls list

Scenario: 11.3.5 Configurator: Close pop-up message
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible

Scenario: 11.3.6 Configurator: Write 1 character in 'Organization' input field
Then clear content of Organization input field from Group Calls sub menu
When add a new group call with:
| key   | organization |
| entry | 1            |

Then verify group call fields contain:
| key   | organization |
| entry | 1            |

Scenario: 11.4.1 Clear 'Comment' input field
Then clear content of Comment input field from Group Calls sub menu

Scenario: 11.4.2 Configurator: Write 101 characters in 'Comment' input field
When add a new group call with:
| key   | comment              |
| entry | <<101_CHARACTERS_STRING>> |

Then verify group call fields contain:
| key   | comment              |
| entry | <<101_CHARACTERS_STRING>> |

Scenario: 11.4.3 Configurator: Click on 'Save' button
Then Save button is pressed in Group Calls editor
Then pop-up message is visible
Then verifying pop-up displays message: Could not save the groupcall entry: Maximum character length exceeded for field 'comment'.

Scenario: 11.4.4 Configurator: New group call is not displayed in group calls list
Then group call 1 is not displayed in Group Calls list

Scenario: 11.4.5 Configurator: Close pop-up message
When clicking on close button of pop-up message
Then waiting for 1 second
Then pop-up message is not visible

Scenario: 11.4.6 Configurator: Write 1 character in 'Comment' input field
Then clear content of Comment input field from Group Calls sub menu
When add a new group call with:
| key   | comment |
| entry | 1       |

Then verify group call fields contain:
| key   | comment |
| entry | 1       |

Scenario: 12. Configurator: Write 'GroupCallTest' in 'Name' input field
Meta:
@TEST_STEP_ACTION: Configurator: Write 'GroupCallTest' in 'Name' input field
@TEST_STEP_REACTION: Configurator: 'GroupCallTest' is displayed in 'Name' input field
@TEST_STEP_REF: [CATS-REF: LfrK]
Then clear content of Name input field from Group Calls sub menu
When add a new group call with:
| key   | name          |
| entry | GroupCallTest |

Then verify group call fields contain:
| key   | name          |
| entry | GroupCallTest |

Scenario: 13. Configurator: Click on 'Save' button
Meta:
@TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: A pop-up message displays "Successfully saved the group call entry"
@TEST_STEP_REF: [CATS-REF: 9ty5]
Then Save button is pressed in Group Calls editor
Then waiting 5 seconds for LoadingScreen to disappear

Scenario: 13.1 Verifying pop-up message
Then pop-up message is visible
Then verifying pop-up displays message: Successfully saved the group call entry

Scenario: 14. Configurator: 'GroupCallTest' is disaplyed in group calls list
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: 'GroupCallTest' is disaplyed in group calls list
@TEST_STEP_REF: [CATS-REF: 87vJ]
Then group call GroupCallTest is displayed in Group Calls list

Scenario: 15. Configurator: Verify that "GroupCallTest" is by default selected and inserted values are displayed in Group Call editor
Meta:
@TEST_STEP_ACTION: Configurator: Verify that "GroupCallTest" is by default selected and inserted values are displayed in Group Call editor
@TEST_STEP_REACTION: Configurator: Filled in fields are displaying inserted values
@TEST_STEP_REF: [CATS-REF: y1kV]
Then verify group call fields contain:
| key   | name          | displayName | location | organization | comment | callRouteSelector | destination               | resultingSipUri               |
| entry | GroupCallTest | 1           | 1        | 1            | 1       | none              | GroupCallTest@example.com | sip:GroupCallTest@example.com |

Scenario: Delete new added group call
When deleting Group Calls sub-menu item: <name>
Then an alert box dialog pops-up with message: Are you sure you want to delete the call group <name>?

When clicking on Yes button of Delete alert box dialog
Then waiting 5 seconds for LoadingScreen to disappear
Then pop-up message is visible
Then verifying pop-up displays message: The file was successfully deleted.

Examples:
| name          |
| GroupCallTest |

Scenario: Close Global settings - Telephone menu
When selecting Global settings - Telephone item in main menu

Scenario: Clean-up - Refresh Configurator
Then refresh Configurator

