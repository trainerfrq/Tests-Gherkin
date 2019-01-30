
Narrative:
As an operator having configured "Idle on Position Unattended" set to enabled
I want to wait the time span for the Warning message has expired without any user interaction
So I can verify that Idle status is activated

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: Stop audio-app on cwp1
GivenStories: voice_GG/includes/StopAudioAppOnCWP1.story
Then waiting for 10 seconds

Scenario: "Position Unattended" as warning state in Notification Bar
Then HMI OP1 has a notification that shows Unattended

Scenario: Op1 wait for 10 sec
Then waiting for 10 seconds

Scenario: Verify Idle Popup text display
Then HMI OP1 verifies that idle popup is visible and contains the text: Position is in Idle state: all handsets/headsets are unplugged!
Then HMI OP1 verifies that idle popup is visible and contains the text: Connect a handset or headset to continue.

Scenario: Check that no call can be made
Given HMI OP1 has the DA key OP2(as OP1) disabled
Given HMI OP1 has the DA key OP3(as OP1) disabled

Scenario: Check that interaction with settings and maintenance is allowed


Scenario: Check event log

Scenario: ...maybe restart audio-app and choose to stay operational
