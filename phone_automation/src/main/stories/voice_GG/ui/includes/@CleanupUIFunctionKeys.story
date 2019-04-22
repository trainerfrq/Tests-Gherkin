Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: OP1 cleans up function keys if needed
Then HMI OP1 does a clean up for function key CALLFORWARD if the state is Active
Then HMI OP1 does a clean up for function key CALLFORWARD if the state is forwardOngoing
Then HMI OP1 does a clean up for function key LOUDSPEAKER if the state is On

Scenario: OP2 cleans up function keys if needed
Then HMI OP2 does a clean up for function key CALLFORWARD if the state is Active
Then HMI OP2 does a clean up for function key CALLFORWARD if the state is forwardOngoing
Then HMI OP2 does a clean up for function key LOUDSPEAKER if the state is On

Scenario: OP3 cleans up function keys if needed
Then HMI OP3 does a clean up for function key CALLFORWARD if the state is Active
Then HMI OP3 does a clean up for function key CALLFORWARD if the state is forwardOngoing
Then HMI OP3 does a clean up for function key LOUDSPEAKER if the state is On
