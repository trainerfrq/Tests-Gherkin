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
When select Global settings - Telephone item in main menu
Then Global settings - Telephone menu item contains following sub-menu items: <<GLOBAL_SETTINGS-TELEPHONE_SUB_MENUS>>

Scenario: Open PhoneBook sub-menu
When select Phone Book sub-menu item
Then wait 2 seconds for LoadingScreen to disappear
Then sub-menu title is visible displaying: Phone Book

Scenario: Click on new button
When New button is pressed in Phone Book sub-menu
Then editor page Phone Book is visible

Scenario: Enter entry details
When add or update phonebook entry with:
| key    | fullName | displayName | location | organization | comment | destination | displayAddon |
| entry  | Ana      | Mary        | Vienna   | FRQ          | -       | Senegal     | -            |

Then verify phonebook entry fields contain:
| key    | fullName | displayName | location | organization | comment | destination | displayAddon |
| entry  | Ana      | Mary        | Vienna   | FRQ          | -       | Senegal     | -            |

Then Save button is pressed in Phone Book editor
Then wait 5 seconds for LoadingScreen to disappear
Then verify pop-up displays message: Successfully saved the phonebook entry

Scenario: Close Global setting - Telephone menu
When select Global settings - Telephone item in main menu

Scenario: Open operator Positions menu
When select Operator Positions item in main menu
Then Operator Positions menu item contains following sub-menu items: <<OPERATOR_POSITIONS_SUB_MENUS>>

Scenario: Open Diagnostic sub-menu
When select Diagnostic sub-menu item
Then wait 2 seconds for LoadingScreen to disappear
Then sub-menu title is visible displaying: Diagnostic

Scenario: Check jsonFile
Then json file phoneBook.json contains phone book with Display Name Mary and Destination sip:example

Scenario: Close operator Positions menu
When select Operator Positions item in main menu

Scenario: Open Global setting - Telephone menu
When select Global settings - Telephone item in main menu

Scenario: Open Phonebook in order to delete the new entry
When select Phone Book sub-menu item
Then wait 2 seconds for LoadingScreen to disappear

Scenario: Search for the new entry
When write in Phone Book search box: Ana
Then phonebook entry Ana is displayed in results list after search

Scenario: Delete new phonebook entry
When delete phonebook entry Ana
Then an alert box dialog pops-up with message: Are you sure you want to delete the phone book entry Ana?

Scenario: Click on alert box button
When click on Yes button of Delete alert box dialog
Then wait 5 seconds for LoadingScreen to disappear
Then verify pop-up displays message: The file was successfully deleted.

Scenario: Clean-up - Close Global setting - Telephone menu
When select Global settings - Telephone item in main menu

