Meta: @TEST_CASE_VERSION: V7
@TEST_CASE_NAME: Call Route Selectors - ordered list
@TEST_CASE_DESCRIPTION:
As a system technician using Configuration Management
I want to add 10 Call Route Selectors
So I can verify that by default the order is the order in which the call route selectors are added and that this order can be change according to the user needed
@TEST_CASE_PRECONDITION: Call Route Selectors page, found in Configuration Management, area Global settings - Telephone, has to be empty
@TEST_CASE_PASS_FAIL_CRITERIA: This tested is passed when default order of call route selectors is the order in which the call route selectors are added and this order can be change according to the user needed
@TEST_CASE_DEVICES_IN_USE:
Firefox browser
Configuration Management accessible from the machine where test is run
@TEST_CASE_ID: PVCSX-TC-15310
@TEST_CASE_GLOBAL_ID: GID-5484488
@TEST_CASE_API_ID: 19446095

Scenario: Book profile
Given booked profiles:
| profile | group                  | host       |
| web     | firefox_<<systemName>> | <<CO3_IP>> |

Scenario: Define XVP Configurator page
Given defined XVP Configurator:
| key    | profile                    | url                      |
| config | web firefox_<<systemName>> | <<xvp.configurator.url>> |

Scenario: Call route selectors entries
Given the following call route selectors entries:
| key     | fullName     | displayName | comment            | sipPrefix | sipPostfix | sipDomain      | sipPort |
| entry1  | entry1_name  | entry1      | entry1_comment     | 1         |            | internal.int   | 5060    |
| entry2  | entry2_name  | entry2      | entry2_propriété   |           | 2          | skype.at       | 7645    |
| entry3  | entry3_name  | entry3      | entry3_süßigkeit   | 33        |            | skype.ro       | 9999    |
| entry4  | entry4_name  | entry4      | entry4_doména      |           | 44         | gmail.at       | 1234    |
| entry5  | entry5_name  | entry5      | entry5_acasă       | 555       |            | gmail.ro       | 3456    |
| entry6  | entry6_name  | entry6      | entry6_комментарий |           | 666        | frequentis.frq | 0000    |
| entry7  | entry7_name  | entry7      | entry7_komentár    | 7         | 7          | examples.com   | 5070    |
| entry8  | entry8_name  | entry8      | entry8_comment     | 8         | 8          | examples.com   | 8990    |
| entry9  | entry9_name  | entry9      | entry9_comment     | 99        | 99         | frequentis.frq | 5061    |
| entry10 | entry10_name | entry10     | entry10_comment    | 1         |            | internal.int   | 5060    |

Scenario: 1. System Technician: Opens a Configuration Management page
Meta: @TEST_STEP_ACTION: Configurator: The main page of Configuration Management is open
@TEST_STEP_REACTION: Configurator: Configuration Management page is visible
@TEST_STEP_REF: [CATS-REF: acCu]
Then configurator management page is visible

Scenario: 2. System Technician: Selects Global settings - Telephone menu
Meta: @TEST_STEP_ACTION: Configurator: Select 'Global settings - Telephone' menu
@TEST_STEP_REACTION: Configurator: The following menus are visible: Call Route Selectors, Phone Book, Group Calls and Phone Data
@TEST_STEP_REF: [CATS-REF: PxS3]
When selecting Global settings - Telephone item in main menu
Then Global settings - Telephone menu item contains following sub-menu items: <<GLOBAL_SETTINGS-TELEPHONE_SUB_MENUS>>

Scenario: 3. System Technician: Selects sub-menu Call Route Selectors
Meta: @TEST_STEP_ACTION: Configurator: Select sub-menu 'Call Route Selectors'
@TEST_STEP_REACTION: Configurator: Call Route Selectors page is visible and has 1 item (list can't be empty)
@TEST_STEP_REF: [CATS-REF: Crxb]
When selecting Call Route Selectors sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Call Route Selectors
Then list size for Call Route Selectors is: 1

Scenario: 4. System Technician: Clicks on New button
Meta: @TEST_STEP_ACTION: Configurator: Click on 'New' button
@TEST_STEP_REACTION: Configurator: Call Route Selectors editor page is open
@TEST_STEP_REF: [CATS-REF: xq6e]
When New button is pressed in Call Route Selectors sub-menu
Then editor page Call Route Selectors is visible

Scenario: 5. System Technician: Fills in the following fields: 'Name', 'Display name', 'SIP' area.
Meta: @TEST_STEP_ACTION: Configurator: Fill in the following fields: 'Name', 'Display name', 'SIP' area.
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'SIP' area display correctly the values filled in. In the Example area, the SIP is displayed according to the filled in field: - Prefix field value is inserted in front of "TestUser"text, Postfix field value is insterted after "TestUser"text, Domain field value is inserted after "TestUser"text and Postfix value, with a @ in front, Port value field value is inserted after "TestUser"text, Postfix value and Domain value with : in front.
@TEST_STEP_REF: [CATS-REF: gp7a]
When call route selector editor is filled in with the following values:
| key     | fullName     | displayName | comment            | sipPrefix | sipPostfix | sipDomain      | sipPort |
| entry2  | entry2_name  | entry2      | entry2_propriété   |           | 2          | skype.at       | 7645    |

Scenario: 5.1 Verify the values have been filled in correctly
Then call route selector editor was filled in with the following expected values:
| key     | fullName     | displayName | comment            | sipPrefix | sipPostfix | sipDomain      | sipPort |
| entry2  | entry2_name  | entry2      | entry2_propriété   |           | 2          | skype.at       | 7645    |

Scenario: 6. System Technician: Clicks on Save button
Meta: @TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: A pop-up message is visible in the page and displays message "Successfully saved call route selector'
@TEST_STEP_REF: [CATS-REF: xg84]
Then Save button is pressed in Call Route Selectors editor
Then waiting 5 seconds for LoadingScreen to disappear
Then verifying pop-up displays message: Successfully saved call route selector

Scenario: 7. Call Route Selectors page is visible and has 1 new item
Meta: @TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator:  Call Route Selectors page is visible and has 2 items.
@TEST_STEP_REF: [CATS-REF: fgZe]
Then list size for Call Route Selectors is: 2

Scenario: 8. System Technician: Verifies that Call Route Selectors newest item is by default selected and displayed the correct values.
Meta: @TEST_STEP_ACTION: Configurator: Verify that Call Route Selectors newest item is by default selected and displayed the correct values.
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'SIP' area display correctly the values filled in at step 5. In the Example area, the SIP is displayed according to the filled in field: - Prefix field value is inserted in front of "TestUser"text, Postfix field value is insterted after "TestUser"text, Domain field value is inserted after "TestUser"text and Postfix value, with a @ in front, Port value field value is inserted after "TestUser"text, Postfix value and Domain value with : in front.
@TEST_STEP_REF: [CATS-REF: QsHw]
Then call route selector contains the following expected values:
| key     | fullName     | displayName | comment            | sipPrefix | sipPostfix | sipDomain      | sipPort |
| entry2  | entry2_name  | entry2      | entry2_propriété   |           | 2          | skype.at       | 7645    |
Then in Call Route Selectors list verify that last item is entry2

Scenario: 9. Add 9 call route entries
Meta: @TEST_STEP_ACTION: Configurator: Repeat steps 4 to 8 for 9 times. After each new added call route selector the order is the list is verified
@TEST_STEP_REACTION: Configurator: After each new added call route selector it is verified that the newest item is the last in the list and that the call route selectors order is not affected by the add of a new item.
@TEST_STEP_REF: [CATS-REF: SRCY]
When New button is pressed in Call Route Selectors sub-menu
Then editor page Call Route Selectors is visible
When the values are added in the call route selector editor using entry with <key>
Then call route selector editor was filled in with the expected values from entry with <key>
Then Save button is pressed in Phone Book editor
Then waiting 7 seconds for LoadingScreen to disappear
Then verifying pop-up displays message: Successfully saved the call route selector
Then call route selector contains the expected values from entry with <key>
Then in Call Route Selectors list verify that last item has name from entry <key>

Examples:
| key     |
| entry3  |
| entry4  |
| entry5  |
| entry6  |
| entry7  |
| entry8  |
| entry9  |
| entry10 |

Scenario: System Technician:: Verifies Call Route Selectors list has the expected number of items and the items are in the correct order
Meta: @TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: Call Route Selectors page is visible and has 10 new items. The list has the following order: 1st item, 2nd item,3rd item, 4th item, 5th item, 6th item, 7th item, 8th item, 9th item, 10th item
@TEST_STEP_REF: [CATS-REF: lkQR]
Then list size for Call Route Selectors is: 10
Then in Call Route Selectors list verify that items are in the following order: entry1,entry2,entry3,entry4,entry5,entry6,entry7,entry8,entry9,entry10

Scenario: System Technician: Drags and drop 5th item in the call route selector list and place it on the 3rd position in the list
Meta: @TEST_STEP_ACTION: Configurator: Drag and drop 5th item in the call route selector list and place it on the 3rd position in the list
@TEST_STEP_REACTION: Configurator: 5th item in the call route selector list is placed in the 3rd position. The order of the list changes, as it follows:  1st item, 2nd item,5th item, 3rd item, 4th item, 6th item, 7th item, 8th item, 9th item, 10th item
@TEST_STEP_REF: [CATS-REF: Ieco]
When in Call Route Selectors move item from position 5 to position 3
Then in Call Route Selectors list verify that items are in the following order: entry1,entry2,entry5,entry3,entry4,entry6,entry7,entry8,entry9,entry10

Scenario: 12. System Technician: Selects sub-menu Call Route Selectors
Meta: @TEST_STEP_ACTION: Configurator: Select sub-menu 'Call Route Selectors'
@TEST_STEP_REACTION: Configurator: Call Route Selectors page is visible
@TEST_STEP_REF: [CATS-REF: 0AdL]
When selecting Call Route Selectors sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Call Route Selectors

Scenario: 13. System Technician: Selects sub-menu Call Route Selectors
Meta: @TEST_STEP_ACTION: Configurator: Selects sub-menu 'Call Route Selectors'
@TEST_STEP_REACTION: Configurator: Call Route Selectors page is visible and has 10 items. The items order is the same as the one verified at step 11
@TEST_STEP_REF: [CATS-REF: 6p4U]
Then list size for Call Route Selectors is: 1
Then in Call Route Selectors list verify that items are in the following order: entry1,entry2,entry5,entry3,entry4,entry6,entry7,entry8,entry9,entry10