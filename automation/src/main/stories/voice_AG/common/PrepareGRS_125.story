Scenario: Booking steps
Given booked profiles:
| profile  | group | host       | Identifier |
| voip/grs | grs   | <<CO1_IP>> | GRS        |

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
| *       | R2S-KeepAlivePeriod     | 200                |
| *       | R2S-KeepAliveMultiplier | 10                 |
| *       | rtphe                   | 1                  |
| *       | sigtime                 | 1                  |
| *       | txrxmode                | TxRx               |
| *       | fid                     | <<BASIC_CALL_FID>> |
| 200     | ptt_rep                 | 0                  |

Given named MEP configuration:
| key   | radio-type | auto-answer | ptt-id | capabilities    | r2s-period | default-header-extension | accept | named-sip-config | named-sdp-config |
| GRS-1 | ED-137B    | true        | 1      | R2S, PCMA, PCMU | 200        | PTT OFF                  | radio  | SipConfig        | SDPConfigRxTx    |

Scenario: VoIP Prerequisites
Given SipContacts group GRS1:
| key | profile  | user-entity                |
| GRS | voip grs | <<BASIC_CALL_GRS.SIP.URI>> |

Given phone GRS1 is created

Scenario: Apply config
Given GRS1 apply GRS-1 configuration
