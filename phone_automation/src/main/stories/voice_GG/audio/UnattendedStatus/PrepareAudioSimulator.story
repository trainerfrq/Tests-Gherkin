Scenario: Verify profiles
When verify profiles:
| hostIp     | profile                        | nr |
| <<CO3_IP>> | websocket/audio_<<systemName>> | 1  |

Given booked profiles:
| profile   | group                | host       | identifier |
| websocket | audio_<<systemName>> | <<CO3_IP>> |            |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri     | text-buffer-size |
| WS_Config-1 | <<WS-Server.URI>> | 1000             |

Scenario: Open Web Socket Client connections
Given applied the named websocket configuration:
| profile-name | websocket-config-name |
| WEBSOCKET 1  | WS_Config-1           |

Scenario: Connect headsets
Then WS1 sends changed event request - connect headsets
And waiting for 1 second
