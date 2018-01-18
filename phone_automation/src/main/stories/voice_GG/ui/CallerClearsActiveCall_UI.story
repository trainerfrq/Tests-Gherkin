Scenario: Booking profiles
Given booked profiles:
| profile | group | host       |
| javafx  | hmi   | <<CO1_IP>> |

Scenario: Test scenario
Given the test scenario using the profile javafx hmi

