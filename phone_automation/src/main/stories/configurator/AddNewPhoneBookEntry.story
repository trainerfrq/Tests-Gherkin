Narrative:
As a system engineer
I want to verify that XVP Configurator is available
So I can add a new configuration

Scenario: Book profile
Given booked profiles:
| profile | group                  | host       |
| web     | firefox_<<systemName>> | <<CO3_IP>> |

Scenario: Define XVP Configurator page
Given defined XVP Configurator pages:
| key      | profile                    | url                      |
| config-1 | web firefox_<<systemName>> | <<xvp.configurator.url>> |

Scenario: Verify XVP Configurator main page
Then configurator management page is visible

Scenario: Open Global setting - Telephone configurator
When configurator Global settings - Telephone is selected
Then Global settings - Telephone sub-configurators are visible

Scenario: Open PhoneBook sub-configurator
When sub-configurator Phone Book is selected
Then wait 2 seconds for LoadingScreen to disappear
Then Phone Book tree title is visible

Scenario: Click on new button
When new button is pressed
Then a new phonebook is created with Full Name Ana, Display Name Mary and Destination sip:example
Then wait 5 seconds for LoadingScreen to disappear
Then verify pop-up displays message: Successfully saved the phonebook entry

Scenario: Check phoneBook was created
When configurator Operator Positions is selected
When sub-configurator Diagnostic is selected
Then wait 2 seconds for LoadingScreen to disappear

Scenario: Check jsonFile
Then json file phoneBook contains phone book with Display Name Mary and Destination sip:example

Scenario: Open Phonebook in order to delete the new entry
When sub-configurator Phone Book is selected
Then wait 2 seconds for LoadingScreen to disappear

Scenario: Search for new entry
When write in search box Ana
Then phonebook entry Ana is displayed in results list

Scenario: Delete new phonebook entry
When delete phonebook entry Ana
Then an alert box dialog pops-up with message: Are you sure you want to delete the phone book entry Ana?
When click on yes button of delete alert box dialog
Then wait 5 seconds for LoadingScreen to disappear
Then verify pop-up displays message: The file was successfully deleted.

Scenario: Clean-up - Close Global setting - Telephone configurator
When configurator Global settings - Telephone is selected

Scenario: Clean-up - Close Operator Positions configurator
When configurator Operator Positions is selected
