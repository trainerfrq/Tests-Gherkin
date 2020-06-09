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

Scenario: Call route selectors entries
Given the following call route selectors entries:
| key    | fullName    | displayName | comment | sipPrefix | sipPostfix | sipDomain | sipPort |
| entry1 | Ana         | Mary        | Vienna  | 1         |            | Senegal   |         |
| entry2 | entry2_name | entry2      | Vienna  | 2         |            | Senegal   |         |
| entry3 | entry3_name | entry3      | Vienna  | 3         |            | Senegal   |         |
| entry4 | entry4_name | entry4      | Vienna  | 4         |            | Senegal   |         |

Then try to add call route selectors to https://10.31.205.100/configurations using default configurators from /configuration-files/ClujCATS/CallRouteSelectors_default/callrouteselectorconfiguration/






