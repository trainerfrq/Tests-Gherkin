Scenario: Define call queue items
Given the call queue items:
| key         | source         | target        | callType |
| OP1-OP2-1   | <<ROLE1_URI>>  | <<ROLE2_URI>> | DA/IDA   |
| OP2-OP1-1   | <<ROLE2_URI>>  |               | DA/IDA   |
| OP1-OP2-2   | <<ROLE1_URI>>  |               | DA/IDA   |
| OP2-OP1-2   | <<ROLE2_URI>>  | <<ROLE1_URI>> | DA/IDA   |
| OP1-Callee1 | <<SIP_PHONE2>> |               | DA/IDA   |
| OP2-Callee2 | <<SIP_PHONE5>> |               | DA/IDA   |