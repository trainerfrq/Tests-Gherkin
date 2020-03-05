Narrative:
As a test engineer defining scenarios using a CATS VoIP Endpoint
I want to launch a set of default VoIP Profiles
So that I can use them in subsequent scenarios

Scenario: Prepare CATS Runtime
Given the CATS runtime profileLauncher is available

Scenario: Launching Web Profiles via CATS Runtime
Given a <profile> profile is available within <timeout> millis via provided runtime <runtime>

Examples:
| profile     | timeout | runtime         |
| web/firefox | 100000  | profileLauncher |
