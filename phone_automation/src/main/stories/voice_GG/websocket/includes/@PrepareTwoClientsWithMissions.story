Scenario: Booking profiles
Given booked profiles:
| profile   | group          | host       |
| websocket | <<systemName>> | <<CO3_IP>> |

Scenario: Open Web Socket Client connections
Given named the websocket configurations:
| named       | websocket-uri       | text-buffer-size |
| WS_Config-1 | <<OPVOICE1_WS.URI>> | 1000             |
| WS_Config-2 | <<OPVOICE2_WS.URI>> | 1000             |

Scenario: Open Web Socket Client connections
Given applied the websocket configuration:
| key | profile-name | websocket-config-name |
| WS1 | WEBSOCKET 1  | WS_Config-1           |
| WS2 | WEBSOCKET 1  | WS_Config-2           |

Scenario: Create the message buffers for missions
When WS1 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer1
When WS1 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer1
When WS2 opens the message buffer for message type missionsAvailableIndication named MissionsAvailableIndicationBuffer2
When WS2 opens the message buffer for message type missionChangedIndication named MissionChangedIndicationBuffer2

Scenario: Caller client associates with Op Voice Service
When WS1 associates with Op Voice Service using opId op03 and appId app1
Then WS1 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer1 and names the availableMissionIds1
Then WS1 receives mission changed indication on message buffer named MissionChangedIndicationBuffer1 and names missionId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Callee client associates with Op Voice Service
When WS2 associates with Op Voice Service using opId op04 and appId app2
Then WS2 receives missions available indication on message buffer named MissionsAvailableIndicationBuffer2 and names the availableMissionIds2
And WS2 receives mission changed indication on message buffer named MissionChangedIndicationBuffer2 and names missionId2
Then WS2 confirms mission change completed for mission missionId2

Scenario: Caller client changes its mission
When WS1 chooses mission with index 0 from available missions named availableMissionIds1 and names missionIdToChange1
Then WS1 receives mission changed indication on buffer named MissionChangedIndicationBuffer1 equal to missionIdToChange1 and names missionId1 and roleId1
Then WS1 confirms mission change completed for mission missionId1

Scenario: Callee client changes its mission
When WS2 chooses mission with index 1 from available missions named availableMissionIds2 and names missionIdToChange2
Then WS2 receives mission changed indication on buffer named MissionChangedIndicationBuffer2 equal to missionIdToChange2 and names missionId2  and roleId2
Then WS2 confirms mission change completed for mission missionId2

Scenario: Delete the message buffers for missions
When the named websocket WS1 removes the message buffer named MissionsAvailableIndicationBuffer1
When the named websocket WS1 removes the message buffer named MissionChangedIndicationBuffer1
When the named websocket WS2 removes the message buffer named MissionsAvailableIndicationBuffer2
When the named websocket WS2 removes the message buffer named MissionChangedIndicationBuffer2
