Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: OP1 cleans up function keys if needed
Then HMI OP1 does a clean up for function key PHONEBOOK if the state is active
Then HMI OP1 does a clean up for function key CALLHISTORY if the state is active
Then HMI OP1 does a clean up for function key MISSIONS if the state is active
Then HMI OP1 does a clean up for function key CALLFORWARD if the state is active
Then HMI OP1 does a clean up for function key CALLFORWARD if the state is forwardOngoingState
Then HMI OP1 does a clean up for function key LOUDSPEAKER if the state is on

Scenario: OP2 cleans up function keys if needed
Then HMI OP2 does a clean up for function key PHONEBOOK if the state is active
Then HMI OP2 does a clean up for function key CALLHISTORY if the state is active
Then HMI OP2 does a clean up for function key MISSIONS if the state is active
Then HMI OP2 does a clean up for function key CALLFORWARD if the state is active
Then HMI OP2 does a clean up for function key CALLFORWARD if the state is forwardOngoingState
Then HMI OP2 does a clean up for function key LOUDSPEAKER if the state is on

Scenario: OP3 cleans up function keys if needed
Then HMI OP2 does a clean up for function key PHONEBOOK if the state is active
Then HMI OP2 does a clean up for function key CALLHISTORY if the state is active
Then HMI OP2 does a clean up for function key MISSIONS if the state is active
Then HMI OP2 does a clean up for function key CALLFORWARD if the state is active
Then HMI OP2 does a clean up for function key CALLFORWARD if the state is forwardOngoingState
Then HMI OP2 does a clean up for function key LOUDSPEAKER if the state is on

