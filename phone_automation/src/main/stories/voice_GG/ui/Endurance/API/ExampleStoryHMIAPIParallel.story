Meta:

Narrative:
As a user
I want to perform an action
So that I can achieve a business goal

Scenario: Booking profiles
Given booked profiles:
| profile             | group          | host       | identifier |
| voip/<<systemName>> | <<systemName>> | <<CO3_IP>> | VOIP       |

Scenario: Create sip phone
Given SipContacts group SipContact:
| key        | profile | user-entity | sip-uri        |
| SipContact | VOIP    | 12345       | <<SIP_PHONE2>> |
And phones for SipContact are created

Scenario: Define call source and API URI
When define values in story data:
| name    | value            |
| HMI OP1 | <<HMI1_API.URI>> |
| HMI OP2 | <<HMI2_API.URI>> |
| HMI OP3 | <<HMI3_API.URI>> |

Scenario: Operators change the mission
When the following operators change the current mission to mission from the table:
| hmiOperator | mission            |
| HMI OP1     | <<MISSION_1_NAME>> |
| HMI OP2     | <<MISSION_2_NAME>> |

Scenario: Operators verify that mission change was done successfully
Then verify that the following operators changed the mission successfully:
| hmiOperator | mission            |
| HMI OP1     | <<MISSION_1_NAME>> |
| HMI OP2     | <<MISSION_2_NAME>> |

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
| HMI OP2     | RINGING_PRIO  |

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
| HMI OP1     | RINGING_PRIO  |

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

Scenario: Remove SIP Contact
When SipContact is removed
