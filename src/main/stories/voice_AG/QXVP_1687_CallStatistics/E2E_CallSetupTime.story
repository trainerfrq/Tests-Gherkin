Scenario: Trigger a frequency selection which will establish an A/G call with 100ms in 95% of all cases
@REQUIREMENTS:GID-1675520

Scenario: Booking profiles
Given booked profiles:
| profile      | group  | host       |
| websocket    | hmi    | <<CO1_IP>> |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-1 | <<OPVOICE1_WS.URI>>  | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| key | profile-name | websocket-config-name |
| WS1   | WEBSOCKET 1  | WS_Config-1         |

Scenario: Associate with OPVoiceSvc
Then start recording on named websocket WS1 with a buffer size of 1
When using the websocket WS1 the message named assocReq1 is sent as is with time stamp associateTime

Scenario: Keyin on Frq
When using the websocket WS1 the message named RxTxKeyinReq is sent as is with time stamp keyInTime
Then using the websocket WS1 websocket message is received and validated against the expected message RxTxAck with time stamp RxTxAckTime
Then wait for 2 seconds
Then GRS1 DialogState is CONFIRMED within 100 ms

Scenario: keyout on Frq
Then start recording on named websocket WS1 with a buffer size of 1
When using the websocket WS1 the message named keyoutReq is sent as is with time stamp keyoutTime
Then GRS1 DialogState is TERMINATED within 100 ms
And using the websocket WS1 websocket message is received and validated against the expected message ByeAck with time stamp ByeAckTime

Scenario: CATS call History
When getting call detail recording for SIP contacts: GRS1
Then SIP Contact 125 in SIP group GRS1 has setupTime in nanos CallSetupTime
And SIP Contact 125 in SIP group GRS1 has establishedTime in nanos  CallEstablishmentTime
And SIP Contact 125 in SIP group GRS1 has terminatedTime in nanos CallTerminationTime

Scenario: Calculate and save the delay
Then calculated CallSetupMessageDelay from nanos RxTxAckTime to keyInTime is within 100 ms and saved to DB cats.ag.e2e.delays.setupMessageDelay
And calculated CallSetupDelay from nanos CallSetupTime to keyInTime is within 100 ms and saved to DB cats.ag.e2e.delays.callsetupDelay
And calculated CallTerminationMessageDelay from nanos ByeAckTime to keyoutTime is within 100 ms and saved to DB cats.ag.e2e.delays.terminationMessageDelay
And calculated CallTerminationDelay from nanos CallTerminationTime to keyoutTime is within 100 ms and saved to DB cats.ag.e2e.delays.callterminationDelay

Scenario: Cleanup
When using the websocket WS1 the message named disAssocReq is sent as is with time stamp disassociateTime
