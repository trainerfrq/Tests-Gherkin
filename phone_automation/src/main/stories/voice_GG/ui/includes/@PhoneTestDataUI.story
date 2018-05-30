Scenario: Define the DA keys
Given the DA keys:
| source  | target                | id  |
| HMI OP1 | OP2(as OP1)           | 100 |
| HMI OP1 | OP2(as OP3)           | 101 |
| HMI OP1 | OP3(as OP1)           | 102 |
| HMI OP1 | ROLE1(as OP1)         | 105 |
| HMI OP1 | IA - OP2(as OP1)      | 107 |
| HMI OP1 | IA - PHONE2           | 109 |
| HMI OP2 | OP1                   | 110 |
| HMI OP2 | ROLE1(as OP2)         | 112 |
| HMI OP2 | ROLE1(as ROLE2)       | 113 |
| HMI OP2 | ROLE1-ALIAS(as OP2)   | 114 |
| HMI OP2 | ROLE1-ALIAS(as ROLE2) | 115 |
| HMI OP2 | IA - ROLE1            | 117 |
| HMI OP2 | IA - OP1              | 118 |
| HMI OP3 | OP1(as OP3)           | 103 |
| HMI OP3 | IA - OP2(as OP3)      | 108 |