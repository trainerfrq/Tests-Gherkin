Scenario: OP1 cleans up function keys if needed
Then HMI OP1 with layout <<LAYOUT_MISSION1>> does a clean up for function key EDIT if the state is active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> does a clean up for function key CALLHISTORY if the state is active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> does a clean up for function key CALLFORWARD if the state is active
Then HMI OP1 with layout <<LAYOUT_MISSION1>> does a clean up for function key CALLFORWARD if the state is forwardOngoingState
Then HMI OP1 with layout <<LAYOUT_MISSION1>> does a clean up for function key MONITORING if the state is monitoringOnGoing
Then HMI OP1 with layout <<LAYOUT_MISSION1>> does a clean up for function key LOUDSPEAKER if the state is on

Scenario: OP2 cleans up function keys if needed
Then HMI OP2 with layout <<LAYOUT_MISSION2>> does a clean up for function key EDIT if the state is active
Then HMI OP2 with layout <<LAYOUT_MISSION2>> does a clean up for function key CALLHISTORY if the state is active
Then HMI OP2 with layout <<LAYOUT_MISSION2>> does a clean up for function key CALLFORWARD if the state is active
Then HMI OP2 with layout <<LAYOUT_MISSION2>> does a clean up for function key CALLFORWARD if the state is forwardOngoingState
Then HMI OP2 with layout <<LAYOUT_MISSION2>> does a clean up for function key MONITORING if the state is monitoringOnGoing
Then HMI OP2 with layout <<LAYOUT_MISSION2>> does a clean up for function key LOUDSPEAKER if the state is on

Scenario: OP3 cleans up function keys if needed
Then HMI OP3 with layout <<LAYOUT_MISSION3>> does a clean up for function key EDIT if the state is active
Then HMI OP3 with layout <<LAYOUT_MISSION3>> does a clean up for function key CALLHISTORY if the state is active
Then HMI OP3 with layout <<LAYOUT_MISSION3>> does a clean up for function key CALLFORWARD if the state is active
Then HMI OP3 with layout <<LAYOUT_MISSION3>> does a clean up for function key CALLFORWARD if the state is forwardOngoingState
Then HMI OP3 with layout <<LAYOUT_MISSION3>> does a clean up for function key MONITORING if the state is monitoringOnGoing
Then HMI OP3 with layout <<LAYOUT_MISSION3>> does a clean up for function key LOUDSPEAKER if the state is on

