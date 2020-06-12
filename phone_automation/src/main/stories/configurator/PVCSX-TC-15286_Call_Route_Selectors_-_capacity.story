Meta: @TEST_CASE_VERSION: V11
@TEST_CASE_NAME: Call Route Selectors - capacity
@TEST_CASE_DESCRIPTION:
As a system technician using Configuration Management
I want to add the maximum number of Call Route Selectors (see Capacity_NumberOfCallRouteSelectors)
So I can verify that they are added correctly in the Call Route Selectors page  and exceeding the maximum number is signalized with an error message for the user
@TEST_CASE_PRECONDITION: Call Route Selectors page, found in Configuration Management, area Global settings - Telephone, has to be empty.
@TEST_CASE_PASS_FAIL_CRITERIA: This test is passed when maximum number of Call Route Selectors (see Capacity_NumberOfCallRouteSelectors) are correctly added in the Call Route Selectors page and exceeding the maximum number is signalized with an error message for the user
																																																																																												@TEST_CASE_DEVICES_IN_USE:
																																																																																												Firefox browser
Configuration Management accessible from the machine where test is run
@TEST_CASE_ID: PVCSX-TC-15286
@TEST_CASE_GLOBAL_ID: GID-5483832
@TEST_CASE_API_ID: 19445055

Scenario: Preparation step - delete call route selectors except one
Given the call route selectors ids for configurator <<xvp.configurator.url>> are saved in list defaultCallRouteSelectors
Then using <<xvp.configurator.url>> delete call route selectors with ids in list defaultCallRouteSelectors except item with <<callRouteSelectorId>>

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
| entry1  | default      | Default     |                    |           |            | example.com    |         |
| entry2  | entry2_name  | entry2      | entry2_propriété   |           | 2          | skype.at       | 7645    |
| entry3  | entry3_name  | entry3      | entry3_süßigkeit   | 33        |            | skype.ro       | 9999    |
| entry4  | entry4_name  | entry4      | entry4_doména      |           | 44         | gmail.at       | 1234    |
| entry5  | entry5_name  | entry5      | entry5_acasă       | 555       |            | gmail.ro       | 3456    |
| entry6  | entry6_name  | entry6      | entry6_комментарий |           | 666        | frequentis.frq | 0001    |
| entry7  | entry7_name  | entry7      | entry7_komentár    | 7         | 7          | examples.com   | 5070    |
| entry8  | entry8_name  | entry8      | entry8_comment     | 8         | 8          | examples.com   | 8990    |
| entry9  | entry9_name  | entry9      | entry9_comment     | 99        | 99         | frequentis.frq | 5061    |
| entry10 | entry10_name | entry10     | entry10_comment    | 1         |            | internal.int   | 5060    |
| entry11 | entry11_name | entry11     | entry11_comment    |           | 2          | skype.at       | 7645    |
| entry12 | entry12_name | entry12     | entry12_comment    | 33        |            | skype.ro       | 9999    |
| entry13 | entry13_name | entry13     | entry13_comment    |           | 44         | gmail.at       | 1234    |
| entry14 | entry14_name | entry14     | entry14_comment    | 555       |            | gmail.ro       | 3456    |
| entry15 | entry15_name | entry15     | entry15_comment    |           | 666        | frequentis.frq | 0001    |
| entry16 | entry16_name | entry16     | entry16_comment    | 7         | 7          | examples.com   | 5070    |
| entry17 | entry17_name | entry17     | entry17_comment    | 8         | 8          | examples.com   | 8990    |
| entry18 | entry18_name | entry18     | entry18_comment    | 99        | 99         | frequentis.frq | 5061    |
| entry19 | entry19_name | entry19     | entry19_comment    | 8         | 8          | examples.com   | 8990    |
| entry20 | entry20_name | entry20     | entry20_comment    | 99        | 99         | frequentis.frq | 5061    |

Scenario: 1. Verify Configuration Management page is visible
Meta: @TEST_STEP_ACTION: Configurator: The main page of Configuration Management is open
@TEST_STEP_REACTION: Configurator: The Configuration Management page is visible
@TEST_STEP_REF: [CATS-REF: mt6X]
Then configurator management page is visible

Scenario: 2. Configurator: Select Global settings - Telephone menu
Meta: @TEST_STEP_ACTION: Configurator: Select 'Global settings - Telephone' menu
@TEST_STEP_REACTION: Configurator: The following menus are visible - Call Route Selectors, Phone Book, Group Calls and Phone Data
@TEST_STEP_REF: [CATS-REF: lyL0]
When selecting Global settings - Telephone item in main menu
Then Global settings - Telephone menu item contains following sub-menu items: <<GLOBAL_SETTINGS-TELEPHONE_SUB_MENUS>>

Scenario: 3. Configurator: select sub-menu Call Route Selectors
Meta: @TEST_STEP_ACTION: Configurator: Select sub-menu 'Call Route Selectors'
@TEST_STEP_REACTION: Configurator: Call Route Selectors page is visible and has 1 item (list can't be empty)
@TEST_STEP_REF: [CATS-REF: IfXE]
When selecting Call Route Selectors sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Call Route Selectors
Then list size for Call Route Selectors is: 1

Scenario: 4. Configurator: Click on New button
Meta: @TEST_STEP_ACTION: Configurator: Click on 'New' button
@TEST_STEP_REACTION: Configurator: Call Route Selectors editor page is open and the following fields areas are visible: Name, Display name, Comment, SIP area, Example area
@TEST_STEP_REF: [CATS-REF: qRB7]
When New button is pressed in Call Route Selectors sub-menu
Then editor page Call Route Selectors is visible

Scenario: 5. Configurator: Fills in the following fields: 'Name', 'Display name', 'SIP' area. Note: SIP area can be fill in in an aleatory way: all fields (Prefix, Postfix, Domain, Port) or just one field or just 2 fields or just 3 fields
Meta: @TEST_STEP_ACTION: Configurator: Fill in the following fields: 'Name', 'Display name', 'SIP' area. Note: SIP area can be fill in in an aleatory way: all fields (Prefix, Postfix, Domain, Port) or just one field or just 2 fields or just 3 fields
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'SIP' area displays correctly the values filled in. In the Example area, the SIP is displayed according to the filled in field: - Prefix field value is inserted in front of "TestUser"text, Postfix field value is insterted after "TestUser"text, Domain field value is inserted after "TestUser"text and Postfix value, with a @ in front, Port value field value is inserted after "TestUser"text, Postfix value and Domain value with : in front.
@TEST_STEP_REF: [CATS-REF: LG1x]
When call route selector editor is filled in with the following values:
| key    | fullName    | displayName | comment          | sipPrefix | sipPostfix | sipDomain | sipPort |
| entry2 | entry2_name | entry2      | entry2_propriété |           | 2          | skype.at  | 7645    |

Scenario: Verify the values have been filled in correctly
Then call route selector editor was filled in with the following expected values:
| key    | fullName    | displayName | comment          | sipPrefix | sipPostfix | sipDomain | sipPort |
| entry2 | entry2_name | entry2      | entry2_propriété |           | 2          | skype.at  | 7645    |

Scenario: 6. Configurator: Clicks on Save button
Meta: @TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: Call Route Selectors page is visible and has 1 new item.
@TEST_STEP_REF: [CATS-REF: sqwI]
Then Save button is pressed in Call Route Selectors editor
Then waiting 10 seconds for LoadingScreen to disappear

Scenario: 7. A pop-up message is visible in the page and displays message "Successfully saved call route selector'
Meta: @TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Configurator: A pop-up message is visible in the page and displays message "Successfully saved the call route selector'
@TEST_STEP_REF: [CATS-REF: tglR]
Then verifying pop-up displays message: Successfully saved the call route selector
Then list size for Call Route Selectors is: 2

Scenario: 8. Configurator: Verifies that Call Route Selectors newest item is by default selected and displayed the correct values.

Meta: @TEST_STEP_ACTION: Configurator: Verify that 'Call Route Selectors' list newest item is by default selected and correct values are displayed
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'SIP' area displays correctly the values filled in at step 5. In the Example area, the SIP is displayed according to the filled in field: - Prefix field value is inserted in front of "TestUser"text, Postfix field value is inserted after "TestUser"text, Domain field value is inserted after "TestUser"text and Postfix value, with a @ in front, Port value field value is inserted after "TestUser"text, Postfix value and Domain value with : in front.
@TEST_STEP_REF: [CATS-REF: 8dFJ]
Then call route selector contains the following expected values:
| key    | fullName    | displayName | comment          | sipPrefix | sipPostfix | sipDomain | sipPort |
| entry2 | entry2_name | entry2      | entry2_propriété |           | 2          | skype.at  | 7645    |

Scenario: 9. Configurator: Repeats steps 4 to 8 for 19 times
Meta: @TEST_STEP_ACTION: Configurator: Repeat steps 4 to 8 for 19 times
@TEST_STEP_REACTION: Configurator: Call Route Selectors page is visible and has 20 new items
@TEST_STEP_REF: [CATS-REF: ABBs]
When New button is pressed in Call Route Selectors sub-menu
Then editor page Call Route Selectors is visible
When the values are added in the call route selector editor using entry with <key>
Then call route selector editor was filled in with the expected values from entry with <key>
Then Save button is pressed in Call Route Selectors editor
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
| entry11 |
| entry12 |
| entry13 |
| entry14 |
| entry15 |
| entry16 |
| entry17 |
| entry18 |
| entry19 |
| entry20 |

Scenario: 10. Configurator: Repeat steps 4 and 5
Meta: @TEST_STEP_ACTION: Configurator: Repeat steps 4 and 5
@TEST_STEP_REACTION: Configurator: 'Name', 'Display name', 'SIP' area displays correctly the values filled in
@TEST_STEP_REF: [CATS-REF: igIi]
When New button is pressed in Call Route Selectors sub-menu
Then editor page Call Route Selectors is visible
When call route selector editor is filled in with the following values:
| key     | fullName     | displayName | comment           | sipPrefix | sipPostfix | sipDomain | sipPort |
| entry21 | entry21_name | entry21     | entry21_propriété |           | 21         | skype.at  | 7645    |
Then Save button is pressed in Phone Book editor
Then waiting 10 seconds for LoadingScreen to disappear

Scenario: 11. Configurator: Click on 'Save' button
Meta: @TEST_STEP_ACTION: Configurator: Click on 'Save' button
@TEST_STEP_REACTION: Configurator: A pop-up message is visible in the page and displays message "Could not saved call route selector. Maximum number of defined call route selectors (20) reached'
@TEST_STEP_REF: [CATS-REF: WxcC]
Then verifying pop-up displays message: Could not saved call route selector. Maximum number of defined call route selectors (20) reached
Then list size for Call Route Selectors is: 20

Scenario: 12. Configurator: Select a 'Call Route Selectors' item
Meta: @TEST_STEP_ACTION: Configurator: Select a 'Call Route Selectors' item
@TEST_STEP_REACTION: Configurator: A pop-up window shows saying "You have unsaved changes and are about to leave this page. if you leave, your changes will be discarded". Window has 2 option buttons: "Discard changes" and "Stay on this page"
@TEST_STEP_REF: [CATS-REF: 52k8]
When selecting Call Route Selectors sub-menu entry: entry10

Scenario: 13. Configurator: Choose to discard changes
Meta: @TEST_STEP_ACTION: Configurator: Choose to discard changes
@TEST_STEP_REACTION: Configurator: Call Route Selectors page is visible and has 20 new items
@TEST_STEP_REF: [CATS-REF: tY97]
Then list size for Call Route Selectors is: 20

Scenario: Backend verification - call route selectors order
Then using <<xvp.configurator.url>> verify that call route selectors order sent to the Op Voice service as in the below table:
| key     | fullName     | displayName | comment            | sipPrefix | sipPostfix | sipDomain      | sipPort |
| entry1  | default      | Default     |                    |           |            | example.com    |         |
| entry2  | entry2_name  | entry2      | entry2_propriété   |           | 2          | skype.at       | 7645    |
| entry3  | entry3_name  | entry3      | entry3_süßigkeit   | 33        |            | skype.ro       | 9999    |
| entry4  | entry4_name  | entry4      | entry4_doména      |           | 44         | gmail.at       | 1234    |
| entry5  | entry5_name  | entry5      | entry5_acasă       | 555       |            | gmail.ro       | 3456    |
| entry6  | entry6_name  | entry6      | entry6_комментарий |           | 666        | frequentis.frq | 0001    |
| entry7  | entry7_name  | entry7      | entry7_komentár    | 7         | 7          | examples.com   | 5070    |
| entry8  | entry8_name  | entry8      | entry8_comment     | 8         | 8          | examples.com   | 8990    |
| entry9  | entry9_name  | entry9      | entry9_comment     | 99        | 99         | frequentis.frq | 5061    |
| entry10 | entry10_name | entry10     | entry10_comment    | 1         |            | internal.int   | 5060    |
| entry11 | entry11_name | entry11     | entry11_comment    |           | 2          | skype.at       | 7645    |
| entry12 | entry12_name | entry12     | entry12_comment    | 33        |            | skype.ro       | 9999    |
| entry13 | entry13_name | entry13     | entry13_comment    |           | 44         | gmail.at       | 1234    |
| entry14 | entry14_name | entry14     | entry14_comment    | 555       |            | gmail.ro       | 3456    |
| entry15 | entry15_name | entry15     | entry15_comment    |           | 666        | frequentis.frq | 0001    |
| entry16 | entry16_name | entry16     | entry16_comment    | 7         | 7          | examples.com   | 5070    |
| entry17 | entry17_name | entry17     | entry17_comment    | 8         | 8          | examples.com   | 8990    |
| entry18 | entry18_name | entry18     | entry18_comment    | 99        | 99         | frequentis.frq | 5061    |
| entry19 | entry19_name | entry19     | entry19_comment    | 8         | 8          | examples.com   | 8990    |
| entry20 | entry20_name | entry20     | entry20_comment    | 99        | 99         | frequentis.frq | 5061    |

Scenario: Clean-up - Delete new created call route configurators and add default call route configurators
Given the call route selectors ids for configurator <<xvp.configurator.url>> are saved in list newCallRouteSelectors
Then using <<xvp.configurator.url>> delete call route selectors with ids in list newCallRouteSelectors except item with <<callRouteSelectorId>>
Then add call route selectors to <<xvp.configurator.url>> using configurators with ids from list defaultCallRouteSelectors found in path /configuration-files/<<systemName>>/CallRouteSelectors_default/callrouteselectorconfiguration/
