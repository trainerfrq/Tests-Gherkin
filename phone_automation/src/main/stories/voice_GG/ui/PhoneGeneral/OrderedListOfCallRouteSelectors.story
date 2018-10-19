Narrative:
As an operator
I want to add up to 10 Call Route Selectors
So I can verify that the Call Route Selector List is ordered

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |

Scenario: Define Call Route Selectors
Given the call route selectors:
| key                |
| callRouteSelector0 |
| callRouteSelector1 |
| callRouteSelector2 |
| callRouteSelector3 |
| callRouteSelector4 |
| callRouteSelector5 |
| callRouteSelector6 |
| callRouteSelector7 |
| callRouteSelector8 |
| callRouteSelector9 |
| callRouteSelector10|

Scenario: Get Call Route selector values for operator mission
Then get for callRouteSelector0 the values assigned for Call Route Selector number 0 for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json
Then get for callRouteSelector1 the values assigned for Call Route Selector number 1 for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json
Then get for callRouteSelector2 the values assigned for Call Route Selector number 2 for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json
Then get for callRouteSelector3 the values assigned for Call Route Selector number 3 for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json
Then get for callRouteSelector4 the values assigned for Call Route Selector number 4 for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json
Then get for callRouteSelector5 the values assigned for Call Route Selector number 5 for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json
Then get for callRouteSelector6 the values assigned for Call Route Selector number 6 for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json
Then get for callRouteSelector7 the values assigned for Call Route Selector number 7 for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json
Then get for callRouteSelector8 the values assigned for Call Route Selector number 8 for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json
Then get for callRouteSelector9 the values assigned for Call Route Selector number 9 for mission MAN-NIGHT-TACT from /configuration-files/<<systemName>>/missions.json

Scenario: Caller opens phonebook
When HMI OP1 presses function key PHONEBOOK

Scenario: Verify Call Route Selector List
Then HMI OP1 verifies that call route selector number 0 matches callRouteSelector0
Then HMI OP1 verifies that call route selector number 1 matches callRouteSelector1
Then HMI OP1 verifies that call route selector number 2 matches callRouteSelector2
Then HMI OP1 verifies that call route selector number 3 matches callRouteSelector3
Then HMI OP1 verifies that call route selector number 4 matches callRouteSelector4
Then HMI OP1 verifies that call route selector number 5 matches callRouteSelector5
Then HMI OP1 verifies that call route selector number 6 matches callRouteSelector6
Then HMI OP1 verifies that call route selector number 7 matches callRouteSelector7
Then HMI OP1 verifies that call route selector number 8 matches callRouteSelector8
Then HMI OP1 verifies that call route selector number 9 matches callRouteSelector9

Scenario: Caller closes call history
Then HMI OP1 closes Phone Book window