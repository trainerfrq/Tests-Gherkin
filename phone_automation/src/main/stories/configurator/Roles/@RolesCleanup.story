Scenario: Run on failure
Then discard changes if discard alert box is visible
When clicking on close button of pop-up message if message is visible

Scenario: Open Missions and Roles menu if not open
Then click on Missions and Roles menu if Roles sub-menu is not visible

Scenario: Select Missions sub-menu
When selecting Missions sub-menu item
Then discard changes if discard alert box is visible
Then waiting 1 second for LoadingScreen to disappear

Scenario: Select Roles sub-menu
When selecting Roles sub-menu item
Then waiting 1 second for LoadingScreen to disappear

Scenario: Delete Roles if they have been added
When deleting item <name> from Roles sub-menu if visible

Examples:
| name       | displayName | location | organization | comment | notes | layout     | callRouteSelector  | destination            | defaultSourceOutgoingCalls | defaultSipPriority |
| RoleTest1  | RoleTest1   |          |              |         |       | twr-layout | none               | RoleTest1@example.com  | RoleTest1                  |                    |
| RoleTest2  | RoleTest2   |          |              |         |       | twr-layout | none               | RoleTest2@example.com  | RoleTest2                  |                    |
| RoleTest3  | RoleTest3   |          |              |         |       | twr-layout | none               | RoleTest3@example.com  | RoleTest3                  |                    |
| RoleTest4  | RoleTest4   |          |              |         |       | twr-layout | none               | RoleTest4@example.com  | RoleTest4                  |                    |
| RoleTest5  | RoleTest5   |          |              |         |       | twr-layout | none               | RoleTest5@example.com  | RoleTest5                  |                    |
| RoleTest6  | RoleTest6   |          |              |         |       | twr-layout | none               | RoleTest6@example.com  | RoleTest6                  |                    |
| RoleTest7  | RoleTest7   |          |              |         |       | twr-layout | none               | RoleTest7@example.com  | RoleTest7                  |                    |
| RoleTest8  | RoleTest8   |          |              |         |       | twr-layout | none               | RoleTest8@example.com  | RoleTest8                  |                    |
| RoleTest9  | RoleTest9   |          |              |         |       | twr-layout | none               | RoleTest9@example.com  | RoleTest9                  |                    |
| RoleTest10 | RoleTest10  |          |              |         |       | twr-layout | none               | RoleTest10@example.com | RoleTest10                 |                    |
| RoleTest11 | RoleTest11  |          |              |         |       | twr-layout | none               | RoleTest11@example.com | RoleTest11                 |                    |
| RoleTest12 | RoleTest12  |          |              |         |       | twr-layout | none               | RoleTest12@example.com | RoleTest12                 |                    |
| RoleTest13 | RoleTest13  |          |              |         |       | twr-layout | none               | RoleTest13@example.com | RoleTest13                 |                    |
| RoleTest14 | RoleTest14  |          |              |         |       | twr-layout | none               | RoleTest14@example.com | RoleTest14                 |                    |
| RoleTest15 | RoleTest15  |          |              |         |       | twr-layout | none               | RoleTest15@example.com | RoleTest15                 |                    |
| RoleTest16 | RoleTest16  |          |              |         |       | twr-layout | none               | RoleTest16@example.com | RoleTest16                 |                    |
| RoleTest17 | RoleTest17  |          |              |         |       | twr-layout | none               | RoleTest17@example.com | RoleTest17                 |                    |
| RoleTest18 | RoleTest18  |          |              |         |       | twr-layout | none               | RoleTest18@example.com | RoleTest18                 |                    |
| RoleTest19 | RoleTest19  |          |              |         |       | twr-layout | none               | RoleTest19@example.com | RoleTest19                 |                    |
| RoleTest20 | RoleTest20  |          |              |         |       | twr-layout | none               | RoleTest20@example.com | RoleTest20                 |                    |
| RoleTest21 | RoleTest21  |          |              |         |       | twr-layout | none               | RoleTest21@example.com | RoleTest21                 |                    |
| RoleTest22 | RoleTest22  |          |              |         |       | twr-layout | none               | RoleTest22@example.com | RoleTest22                 |                    |
| RoleTest23 | RoleTest23  |          |              |         |       | twr-layout | none               | RoleTest23@example.com | RoleTest23                 |                    |
| RoleTest24 | RoleTest24  |          |              |         |       | twr-layout | none               | RoleTest24@example.com | RoleTest24                 |                    |
| RoleTest25 | RoleTest25  |          |              |         |       | twr-layout | none               | RoleTest25@example.com | RoleTest25                 |                    |
| RoleTest26 | RoleTest26  |          |              |         |       | twr-layout | none               | RoleTest26@example.com | RoleTest26                 |                    |
| RoleTestAboveMax | RoleTestAboveMax |          |              |         |       | twr-layout | none              | RoleTestAboveMax@example.com | RoleTestAboveMax           |                    |

Scenario: Close Missions and Roles menu
When selecting Missions and Roles item in main menu
