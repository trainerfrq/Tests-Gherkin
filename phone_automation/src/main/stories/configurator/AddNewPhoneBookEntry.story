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
Then wait for 10 seconds
!-- Then add a new configuration
!-- Then configurator management page is visible
When configurator Global settings - Telephone is selected
!-- Then Global settings - Telephone sub-configurators are visible

When sub-configurator Phone Book is selected
!-- Then Phone Book page is visible

When new button is pressed

!-- Then a new phone is created with Full Name Ana, Display Name Mary and Destination sip:example




