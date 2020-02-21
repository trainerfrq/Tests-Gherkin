!--For this cleanup to work, you will need to make a Mission cleanup before

Scenario: OP1 cleans up monitoring calls, if is the case
Then HMI OP1 with layout <<LAYOUT_MISSION1>> terminates active monitoring calls displayed on function key MONITORING

Scenario: OP2 cleans up monitoring calls, if is the case
Then HMI OP2 with layout <<LAYOUT_MISSION2>> terminates active monitoring calls displayed on function key MONITORING

Scenario: OP3 cleans up monitoring calls, if is the case
Then HMI OP3 with layout <<LAYOUT_MISSION3>> terminates active monitoring calls displayed on function key MONITORING
