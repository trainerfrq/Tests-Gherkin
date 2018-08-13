Narrative:
As a system engineer
I want to verify that XVP Configurator is available
So I can verify the existing configuration of the system

Scenario: Book profile
Given booked profiles:
| profile   | group | host       |
| web/chrome       | any   | <anyhost>  |

Scenario: Define XVP Configurator page
Given defined XVP Configurator pages:
|key      | profile            |url                     |
|config-1 | web/chrome any     |<<xvp.configurator.url>>|

Scenario: Verify XVP Configurator main page
Given all expected elements are visible on the XVP Configurator main page
And XVP Configurator shows version 0.10.0-SNAPSHOT and user User
When Applications item is selected
And configuration versions panel is verified and found empty
Then add a new configuration




