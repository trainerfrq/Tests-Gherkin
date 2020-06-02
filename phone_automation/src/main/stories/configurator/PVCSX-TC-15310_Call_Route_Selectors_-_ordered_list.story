Meta: @TEST_CASE_VERSION: V5
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

Scenario: 1. System Technician: Opens a Configuration Management page
Meta: @TEST_STEP_ACTION: System Technician: Opens a Configuration Management page
@TEST_STEP_REACTION: Configuration Management page is visible
@TEST_STEP_REF: [CATS-REF: acCu]
Then configurator management page is visible

Scenario: 2. System Technician: Selects Global settings - Telephone menu
Meta: @TEST_STEP_ACTION: System Technician: Selects Global settings - Telephone menu
@TEST_STEP_REACTION: The following menus are visible: Call Route Selectors, Phone Book, Group Calls and Phone Data
@TEST_STEP_REF: [CATS-REF: PxS3]
When selecting Global settings - Telephone item in main menu
Then Global settings - Telephone menu item contains following sub-menu items: <<GLOBAL_SETTINGS-TELEPHONE_SUB_MENUS>>

Scenario: 3. System Technician: Selects sub-menu Call Route Selectors
Meta: @TEST_STEP_ACTION: System Technician: Selects sub-menu Call Route Selectors
@TEST_STEP_REACTION: Call Route Selectors page is visible and has 0 items
@TEST_STEP_REF: [CATS-REF: Crxb]
When selecting Call Route Selectors sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Call Route Selectors
Then list size for Call Route Selectors is: 19

Scenario: 4. System Technician: Clicks on New button
Meta: @TEST_STEP_ACTION: System Technician: Clicks on New button
@TEST_STEP_REACTION: Call Route Selectors editor page is open
@TEST_STEP_REF: [CATS-REF: xq6e]
When New button is pressed in Call Route Selectors sub-menu
Then editor page Call Route Selectors is visible

Scenario: 5. System Technician: Fills in the following fields: Name, Display name, SIP area.
Meta: @TEST_STEP_ACTION: System Technician: Fills in the following fields: Name, Display name, SIP area.
@TEST_STEP_REACTION: Name, Display name, SIP area display correctly the values filled in. In the Example area, the SIP is displayed according to the filled in field: - Prefix field value is inserted in front of "TestUser"text, Postfix field value is insterted after "TestUser"text, Domain field value is inserted after "TestUser"text and Postfix value, with a @ in front, Port value field value is inserted after "TestUser"text, Postfix value and Domain value with : in front.
@TEST_STEP_REF: [CATS-REF: gp7a]
When call route selector editor is filled in with the following values:
| key   | fullName | displayName | comment | sipPrefix | sipPostfix | sipDomain | sipPort |
| entry | Ana      | Mary        | Vienna  |           |            | Senegal   |         |

Scenario: Verify the values have been filled in correctly
Then call route selector editor was filled in with the following expected values:
| key   | fullName | displayName | comment | sipPrefix | sipPostfix | sipDomain | sipPort | sipResult |
| entry | Ana      | Mary        | Vienna  |           |            | Senegal   |         |           |

Scenario: 6. System Technician: Clicks on Save button
Meta: @TEST_STEP_ACTION: System Technician: Clicks on Save button
@TEST_STEP_REACTION: A pop-up message is visible in the page and displays message "Successfully saved call route selector'
@TEST_STEP_REF: [CATS-REF: xg84]
Then Save button is pressed in Phone Book editor
Then waiting 5 seconds for LoadingScreen to disappear
Then verifying pop-up displays message: Successfully saved call route selector

Scenario: 7. Call Route Selectors page is visible and has 1 new item
Meta: @TEST_STEP_ACTION: -
@TEST_STEP_REACTION:  Call Route Selectors page is visible and has 1 new item.
@TEST_STEP_REF: [CATS-REF: fgZe]
Then list size for Call Route Selectors is: 20

Scenario: 8. System Technician: Verifies that Call Route Selectors newest item is by default selected and displayed the correct values.

Meta: @TEST_STEP_ACTION: System Technician: Verifies that Call Route Selectors newest item is by default selected and displayed the correct values.
@TEST_STEP_REACTION: Name, Display name, SIP area display correctly the values filled in at step 5. In the Example area, the SIP is displayed according to the filled in field: - Prefix field value is inserted in front of "TestUser"text, Postfix field value is insterted after "TestUser"text, Domain field value is inserted after "TestUser"text and Postfix value, with a @ in front, Port value field value is inserted after "TestUser"text, Postfix value and Domain value with : in front.
@TEST_STEP_REF: [CATS-REF: QsHw]
Then call route selector contains the following expected values:
| key   | fullName | displayName | comment | sipPrefix | sipPostfix | sipDomain | sipPort | sipResult |
| entry | Ana      | Mary        | Vienna  |           |            | Senegal   |         |           |

Scenario: 9. Add 9 call route entries
Meta: @TEST_STEP_ACTION: System Technician: Repeats steps 4 to 8 for 9 times. After each new added call route selector the order is the list is verified
@TEST_STEP_REACTION: Call Route Selectors page is visible and has 10 new items
@TEST_STEP_REF: [CATS-REF: SRCY]
Then for Call Route Selectors list scroll until item Ana is visible
Then for Call Route Selectors list item Ana is selected



Scenario: Autogenerated Scenario 10
Meta: @TEST_STEP_ACTION: -
@TEST_STEP_REACTION: After each new added call route selector it is verified that the newest item is the last in the list and that the call route selectors order is not affected by the add of a new item. At the end the list will have the following order: 1st item, 2nd item,3rd item, 4th item, 5th item, 6th item, 7th item, 8th item, 9th item, 10th item
@TEST_STEP_REF: [CATS-REF: lkQR]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 11
Meta: @TEST_STEP_ACTION: System Technician: Drags and drop 3rd item in the call route selector list and place it to the top of the list
@TEST_STEP_REACTION: 3rd item in the call route selector list is placed at the top. The order of the list changes, as it follows:  3rd item,1st item,2nd item,4th item,5th item,6th item,7th item,8th item,9th item,10th item
@TEST_STEP_REF: [CATS-REF: Ieco]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 12
Meta: @TEST_STEP_ACTION: System Technician: Selects sub-menu Call Route Selectors
@TEST_STEP_REACTION: Call Route Selectors page is visible
@TEST_STEP_REF: [CATS-REF: 0AdL]
!-- insert steps here!!!



Scenario: Autogenerated Scenario 13
Meta: @TEST_STEP_ACTION: System Technician: Selects sub-menu Call Route Selectors
@TEST_STEP_REACTION: Call Route Selectors page is visible and has 10 items. The items order is the same as the one verified at step 11
@TEST_STEP_REF: [CATS-REF: 6p4U]
!-- insert steps here!!!