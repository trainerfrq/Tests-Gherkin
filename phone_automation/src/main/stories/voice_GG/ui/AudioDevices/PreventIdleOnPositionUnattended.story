Narrative:
As an operator having configured "Idle on Position Unattended" set to enabled
I want to click the "Stay operational" button
So I can verify that Idle status is prevented

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |

Scenario: "Position Unattended" as warning state in Notification Bar

Scenario: Op1 receives warning message:"Position is unattended: all handsets/headsets are unplugged!" "Position goes into Idle state in <xx> seconds"- 662

Scenario: Op2 does not receive warning message (idle -disabled)

Scenario: Op1 click "Stay operational" button - 663

Scenario: Check event log

Scenario: "Position Unattended" as warning state in Notification Bar

Scenario: Check if calls can be made

Scenario: Check event log

