Narrative:
As a test engineer defining scenarios using a CATS VoIP Endpoint
I want to launch a set of default VoIP Profiles
So that I can use them in subsequent scenarios

Scenario: Prepare CATS Runtime
Given the CATS runtime profileLauncher is available

!-- Given the CATS runtime profileLauncher is available using shared platform resources: D:/CATS/PLAYGROUND/PROJECT/junit/target/platform

Scenario: Launching Profiles via CATS Runtime
Given a <profile> profile is available within <timeout> millis via provided runtime <runtime>
Examples:
| profile | timeout | runtime         |
| voip    | 25000   | profileLauncher |
| voip    | 25000   | profileLauncher |

