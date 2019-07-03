Scenario: Define the DA keys
Given the DA keys:
| source  | target                | id  |
| HMI OP1 | OP2(as OP1)           | 100 |
| HMI OP1 | OP2(as OP3)           | 101 |
| HMI OP1 | OP3(as OP1)           | 102 |
| HMI OP1 | ROLE1(as OP1)         | 105 |
| HMI OP1 | IA - OP2(as OP1)      | 107 |
| HMI OP1 | IA - PHONE2           | 109 |
| HMI OP1 | OP3                   | 111 |
| HMI OP2 | OP1                   | 110 |
| HMI OP2 | OP3                   | 111 |
| HMI OP2 | ROLE1(as OP2)         | 112 |
| HMI OP2 | ROLE1(as ROLE2)       | 113 |
| HMI OP2 | ROLE1-ALIAS(as OP2)   | 114 |
| HMI OP2 | ROLE1-ALIAS(as ROLE2) | 115 |
| HMI OP2 | IA - ROLE1            | 117 |
| HMI OP2 | IA - OP1              | 118 |
| HMI OP2 | IA - OP2              | 119 |
| HMI OP2 | OP1-mission           | 120 |
| HMI OP2 | IA - OP3              | 121 |
| HMI OP3 | OP1(as OP3)           | 103 |
| HMI OP3 | OP2(as OP3)           | 101 |
| HMI OP3 | IA - OP2(as OP3)      | 108 |

Scenario: Define grid widget keys
Given the grid widget keys:
| source  | id            |
| HMI OP1 | 1559721399523 |
| HMI OP2 | 1559732038213 |
| HMI OP3 | 1559721399523 |

Scenario: Define function keys
Given the function keys:
| key           | id                       |
| PHONEBOOK     | f1                       |
| CALLHISTORY   | f2                       |
| MISSIONS      | f3                       |
| CALLFORWARD   | f4                       |
| LOUDSPEAKER   | f5                       |
| SETTINGS      | 1561462433938            |
| AUDIOSETTINGS | volumeControlPanelSymbol |


Scenario: Define status key
Given the status key:
| source  | key            | id      |
| HMI OP1 | DISPLAY STATUS | status1 |
| HMI OP2 | DISPLAY STATUS | status1 |
| HMI OP3 | DISPLAY STATUS | status1 |

Scenario: Define call route selectors
Given the call route selectors:
| key       | id      |
| Default   | default |
| None      | none    |
| FrqUser   | frqUser |
| Gmail     | gmail   |
| Admin     | admin   |
| Super     | super   |
| Student   | student |
| Professor | prof    |
| Medic     | medic   |
| Mail      | mail    |

