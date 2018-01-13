Scenario:Make a TxRx call to Frequency service which will trigger a TxRx call to GRS.
@REQUIREMENTS:GID-1316706

Scenario: Booking steps
Given booked profiles:
| profile | group | host      | identifier |
| voip    | opv   | <<CO1_IP>> | OPV        |

Scenario: Create ED-137B compliant Radio configuration
Given the SIP header configuration named SipConfig:
| context | header-name  | header-value                                                              |
| *       | Subject      | radio                                                                     |
| *       | Allow        | INVITE, ACK, BYE, CANCEL, INFO, UPDATE, REFER, NOTIFY, SUBSCRIBE, OPTIONS |
| *       | Max-Forwards | 70                                                                        |
| *       | WG67-Version | radio.01                                                                  |
| INVITE  | Expires      | 120                                                                       |
| INVITE  | Priority     | normal                                                                    |
| 200     | Expires      | 120                                                                       |
| 200     | Priority     | normal                                                                    |

Given the SDP media description configuration named SDPConfigRxTx:
| context | attribute-name          | attribute-value    |
| *       | type                    | Radio-TxRx         |
| *       | R2S-KeepAlivePeriod     | 200                |
| *       | R2S-KeepAliveMultiplier | 10                 |
| *       | rtphe                   | 1                  |
| *       | sigtime                 | 1                  |
| *       | txrxmode                | TxRx               |
| *       | fid                     | <<BASIC_CALL_FID>> |
| 200     | ptt_rep                 | 0                  |

Given named MEP configuration:
| key   | radio-type | auto-answer | ptt-id | capabilities    | r2s-period | default-header-extension | accept | named-sip-config | named-sdp-config |
| OPV-1 | ED-137B    | true        | 1      | R2S, PCMA, PCMU | 200        | PTT OFF                  | radio  | SipConfig        | SDPConfigRxTx    |

Scenario: VoIP Prerequisites
Given SipContacts group RADIOS1:
| key | profile | user-entity |
| OPV | OPV     | opv_cats    |

Given phones for RADIOS1 are created

Scenario: Apply config
Given RADIOS1 apply OPV-1 configuration

Scenario: Make Call
When RADIOS1 calls SIP URI <<BASIC_CALL_FRQ-SVC.SIP.URI>>
Then RADIOS1 DialogState is CONFIRMED within 100 ms
Then GRS1 DialogState is CONFIRMED within 100 ms

Scenario: End call
When RADIOS1 terminate calls
Then RADIOS1 DialogState is TERMINATED within 100 ms
