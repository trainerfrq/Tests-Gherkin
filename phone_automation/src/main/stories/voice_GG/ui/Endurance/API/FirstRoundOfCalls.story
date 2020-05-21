Scenario: Operators start calls
When HMI operators initiate calls to the following targets:
| hmiOperator | target          |
| HMI OP1     | <<ROLE_2_NAME>> |
Then wait for 1 seconds

Scenario: Operators verify call state on DA key
Then HMI operators verify that DA keys have the expected status:
| hmiOperator | target          | status        |
| HMI OP1     | <<ROLE_2_NAME>> | OUTGOING_PRIO |
| HMI OP2     | <<ROLE_1_NAME>> | RINGING_PRIO  |

Scenario: Operators verify call state on call queue
Then HMI operators verify that call queues have the expected status:
| hmiOperator | status        |
| HMI OP1     | OUTGOING_PRIO |

Scenario: Operators answer calls
When HMI operators answer the following calls:
| hmiOperator | target          |
| HMI OP2     | <<ROLE_1_NAME>> |
Then wait for 1 seconds

Scenario: Operators verify call state on call queue
Then HMI operators verify that call queues have the expected status:
| hmiOperator | status             |
| HMI OP1     | ESTABLISHED_DUPLEX |
| HMI OP2     | ESTABLISHED_DUPLEX |

Scenario: Operators terminate calls
When HMI operators terminate the following calls:
| hmiOperator | target          |
| HMI OP1     | <<ROLE_2_NAME>> |
Then wait for 1 seconds

Scenario: Operators verify call state on call queue
Then HMI operators verify that call queues have the expected status:
| hmiOperator | status     |
| HMI OP1     | TERMINATED |
| HMI OP2     | TERMINATED |
Then wait for 2 seconds

Scenario: Operators start calls
When HMI operators initiate calls to the following targets:
| hmiOperator | target          |
| HMI OP2     | <<ROLE_1_NAME>> |
Then wait for 1 seconds

Scenario: Operators verify call state on DA key
Then HMI operators verify that DA keys have the expected status:
| hmiOperator | target          | status        |
| HMI OP2     | <<ROLE_1_NAME>> | OUTGOING_PRIO |
| HMI OP1     | <<ROLE_2_NAME>> | RINGING_PRIO  |

Scenario: Operators verify call state on call queue
Then HMI operators verify that call queues have the expected status:
| hmiOperator | status        |
| HMI OP2     | OUTGOING_PRIO |

Scenario: Operators answer calls
When HMI operators answer the following calls:
| hmiOperator | target          |
| HMI OP1     | <<ROLE_2_NAME>> |
Then wait for 1 seconds

Scenario: Operators verify call state on call queue
Then HMI operators verify that call queues have the expected status:
| hmiOperator | status             |
| HMI OP2     | ESTABLISHED_DUPLEX |
| HMI OP1     | ESTABLISHED_DUPLEX |

Scenario: Operators terminate calls
When HMI operators terminate the following calls:
| hmiOperator | target          |
| HMI OP2     | <<ROLE_1_NAME>> |
Then wait for 1 seconds

Scenario: Operators verify call state on call queue
Then HMI operators verify that call queues have the expected status:
| hmiOperator | status     |
| HMI OP2     | TERMINATED |
| HMI OP1     | TERMINATED |
Then wait for 2 seconds

Scenario: Operators start call from phone book
When HMI operators start a call from phone book to:
| hmiOperator | target   |
| HMI OP1     | Madoline |
Then wait for 1 seconds

Scenario: Operators verify call state on call queue
Then HMI operators verify that call queues have the expected status:
| hmiOperator | status   |
| HMI OP1     | OUTGOING |

Scenario: Externals callee answer calls
When SipContact answers incoming calls
Then wait for 2 seconds

Scenario: Operators verify call state on call queue
Then HMI operators verify that call queues have the expected status:
| hmiOperator | status      |
| HMI OP1     | ESTABLISHED |

Scenario: Operator terminates calls
When SipContact terminates calls
Then wait for 2 seconds

Scenario: Operators verify call state on call queue
Then HMI operators verify that call queues have the expected status:
| hmiOperator | status      |
| HMI OP1     | TERMINATED |
