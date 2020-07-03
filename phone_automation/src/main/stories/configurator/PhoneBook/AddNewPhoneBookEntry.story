Narrative:
As a system engineer
I want to verify that XVP Configurator is available
So I can add a new configuration

Scenario: Book profile
Given booked profiles:
| profile | group                  | host       |
| web     | firefox_<<systemName>> | <<CO3_IP>> |

Scenario: Define XVP Configurator page
Given defined XVP Configurator:
| key    | profile                    | url                      |
| config | web firefox_<<systemName>> | <<xvp.configurator.url>> |

Scenario: Verify XVP Configurator main page
Then configurator management page is visible

Scenario: Open Global setting - Telephone menu
When selecting Global settings - Telephone item in main menu
Then Global settings - Telephone menu item contains following sub-menu items: <<GLOBAL_SETTINGS-TELEPHONE_SUB_MENUS>>

Scenario: Open PhoneBook sub-menu
When selecting Phone Book sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Phone Book

Scenario: Click on new button
When New button is pressed in Phone Book sub-menu
Then editor page Phone Book is visible

Scenario: Add a new phone book entry
When add a phonebook entry with:
| key    | fullName | displayName | location | organization | comment | destination | displayAddon |
| entry  | Ana      | Mary        | Vienna   |              |         | Senegal     |              |

Then verify phonebook entry fields contain:
| key    | fullName | displayName | location | organization | comment | destination | displayAddon |
| entry  | Ana      | Mary        | Vienna   |              |         | Senegal     |              |

Then Save button is pressed in Phone Book editor
Then verify phonebook entry fields contain:
| key    | fullName | displayName | location | organization | comment | destination | displayAddon |
| entry  | Ana      | Mary        | Vienna   |              |         | Senegal     |              |
Then waiting 5 seconds for LoadingScreen to disappear
Then verifying pop-up displays message: Successfully saved the phonebook entry

Scenario: Close Global setting - Telephone menu
When selecting Global settings - Telephone item in main menu

Scenario: Open operator Positions menu
When selecting Operator Positions item in main menu
Then Operator Positions menu item contains following sub-menu items: <<OPERATOR_POSITIONS_SUB_MENUS>>

Scenario: Open Diagnostic sub-menu
When selecting Diagnostic sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear
Then sub-menu title is displaying: Diagnostic

Scenario: Check jsonFile
Then json file phoneBook.json contains phone book with Display Name Mary and Destination Senegal

Scenario: Close operator Positions menu
When selecting Operator Positions item in main menu

Scenario: Open Global setting - Telephone menu
When selecting Global settings - Telephone item in main menu

Scenario: Open Phonebook in order to delete the new entry
When selecting Phone Book sub-menu item
Then waiting 2 seconds for LoadingScreen to disappear

Scenario: Search for the new entry
When writing in Phone Book search box: Ana
Then phonebook entry Ana is displayed in results list after search

Scenario: Delete new phonebook entry
When deleting Phone Book sub-menu item: Ana
Then an alert box dialog pops-up with message: Are you sure you want to delete the phone book entry Ana?

Scenario: Click on alert box button
When clicking on Yes button of Delete alert box dialog
Then waiting 5 seconds for LoadingScreen to disappear
Then verifying pop-up displays message: The file was successfully deleted.

Scenario: Clean-up - Refresh Configurator
Then refresh Configurator

