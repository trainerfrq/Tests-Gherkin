Scenario: Booking profiles
Given booked profiles:
| profile   | group  | host       |
| websocket | hmi    | <<CO1_IP>> |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri        | text-buffer-size |
| WS_Config-1 | <<OPVOICE1_WS.URI>>  | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| key | profile-name | websocket-config-name |
| WS1 | WEBSOCKET 1  | WS_Config-1           |

Scenario: Associate with OPVoiceSvc
Then start recording on named websocket WS1 with a buffer size of 1
When using the websocket WS1 the message named assocReq is sent as is with time stamp associateTime

Scenario:Send Establish Request
When using the websocket WS1 the message named callEstablishReq is sent as is with time stamp callEstablishTime
Then using the websocket WS1 websocket message is received and validated against the expected message callStatusInd and "callId": in the message saved as namedCallId

Scenario: Clear call
Given the callClearReq is defined with variable namedCallId as {header: {correlationId: 0dac38fc-9d10-4def-ba0d-45d2c2dcb5bf},body: { callClearRequest: {callId:namedCallId}}}
When using the websocket WS1 the message named callClearReq is sent as is with time stamp callClearTime

