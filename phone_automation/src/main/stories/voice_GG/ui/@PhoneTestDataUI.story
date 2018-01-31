Scenario: Define the DA keys
Given the DA keys:
| source | target | id  |
| OP1    | OP2    | 700 |
| OP2    | OP1    | 702 |

Scenario: Booking profiles
Given booked profiles:
| profile | group | host       | identifier |
| javafx  | hmi   | <<CO1_IP>> | OP1        |
| javafx  | hmi   | <<CO2_IP>> | OP2        |
