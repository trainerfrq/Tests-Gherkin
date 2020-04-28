Meta:

Narrative:
As a user
I want to perform an action
So that I can achieve a business goal

Scenario: Define call source and API URI
When define values in story data:
| name    | value            |
| HMI OP1 | <<HMI1_API.URI>> |
| HMI OP2 | <<HMI2_API.URI>> |
| HMI OP3 | <<HMI3_API.URI>> |

Scenario: scenario description
When HMI OP1 changes (via POST request) current mission to mission WEST-EXEC
When HMI OP1 presses (via POST request) DA key role1

