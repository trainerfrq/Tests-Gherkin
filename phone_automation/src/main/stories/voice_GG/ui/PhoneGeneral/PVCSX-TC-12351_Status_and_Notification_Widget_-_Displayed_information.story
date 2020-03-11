Meta:
@TEST_CASE_VERSION: V10
@TEST_CASE_NAME: Status and Notification Widget - Displayed information
@TEST_CASE_DESCRIPTION: As an operator having 4 missions configured with different layouts and different options for displayed information in Status and Notification Widget
I want to change the mission to each of the configured ones
So I can verify the displayed information about each mission
@TEST_CASE_PRECONDITION: Settings:
Layout Settings of the four missions' layouts
| Displayed Information  | TWR   | GND   | APP   | SUP-TWR  |
|- - - - - - - - - - - - | - - - | - - - | - -  -| - -  - - |
| status bar             | yes   | yes   | yes   | yes      |
| clock                  | no    | no    | yes   | yes      |
| date                   | yes   | no    | yes   | yes      |
| mission                | yes   | yes   | no    | yes      |
| connection status      | yes   | yes   | yes   | no       |

Status Widget settings of the four missions' layouts
| Displayed Information  | TWR   | GND   | APP   | SUP-TWR  |
|- - - - - - - - - - - - | - - - | - - - | - -  -| - -  - - |
| clock                  | no    | no    | yes   | yes      |
| date                   | yes   | no    | yes   | yes      |
| mission                | yes   | yes   | no    | yes      |
| connection status      | yes   | yes   | yes   | no       |

OP1 has TWR mission assigned
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if the HMI displays the following information as configured.
Layout settings:
-status bar
-clock
-date
-mission
-connection status

Status widget:
-clock
-date
-mission
-connection status
@TEST_CASE_DEVICES_IN_USE: OP1, OP2
@TEST_CASE_ID: PVCSX-TC-12351
@TEST_CASE_GLOBAL_ID: GID-5197940
@TEST_CASE_API_ID: 18088496

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Define call queue items
Given the call queue items:
| key     | source      | target      | callType |
| OP1-OP2 | <<OP1_URI>> | <<OP2_URI>> | DA/IDA   |
| OP2-OP1 | <<OP2_URI>> | <<OP1_URI>> | DA/IDA   |

Scenario: Define call history entries
Given the following call history entries:
| key      | remoteDisplayName | callDirection | callConnectionStatus |
| entry1   | <<OP2_NAME>>      | outgoing      | established      |

Scenario: OP1 clears call history list
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key CALLHISTORY
Then HMI OP1 clears Call History list
Then HMI OP1 verifies that call history list contains 0 entries
Then HMI OP1 closes Call History popup window

Scenario: Operator opens Notification Display popup and clears the event list
When HMI OP1 opens Notification Display list
When HMI OP1 selects tab event from notification display popup
When HMI OP1 clears the notification events from list

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: OP1 changes its mission to TWR
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_TWR_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 1. OP1 verifies that date, mission, connection status are visible and clock is not visible in Status bar and Status widget
Meta:
@TEST_STEP_ACTION: OP1 verifies that date, mission, connection status are visible and clock is not visible in Status bar and Status widget
@TEST_STEP_REACTION: Date, mission, connection status are visible and clock is not visible in Status bar and Status widget
@TEST_STEP_REF: [CATS-REF: FsMK]
Then HMI OP1 verifies that section date is visible in the DISPLAY STATUS TWR
Then HMI OP1 verifies that section mission is visible in the DISPLAY STATUS TWR
Then HMI OP1 verifies that section connection is visible in the DISPLAY STATUS TWR
Then HMI OP1 verifies that section clock is not visible in the DISPLAY STATUS TWR

Scenario: 1.1 Verifying Notification Display
Then HMI OP1 verifies that section date is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section mission is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section connection is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section clock is not visible in the NOTIFICATION DISPLAY

Scenario: 2. OP1 changes its mission to GND
Meta:
@TEST_STEP_ACTION: OP1 changes its mission to GND
@TEST_STEP_REACTION: OP1 has GND mission assigned
@TEST_STEP_REF: [CATS-REF: ckJP]
When HMI OP1 with layout <<LAYOUT_TWR>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 3. OP1 verifies that mission, connection status are visible and clock and date are not visible in Status bar and Status widget
Meta:
@TEST_STEP_ACTION: OP1 verifies that mission, connection status are visible and clock and date are not visible in Status bar and Status widget
@TEST_STEP_REACTION: Mission, connection status are visible and clock and date are not visible in SStatus bar and Status widget
@TEST_STEP_REF: [CATS-REF: snTJ]
Then HMI OP1 verifies that section mission is visible in the DISPLAY STATUS GND
Then HMI OP1 verifies that section connection is visible in the DISPLAY STATUS GND
Then HMI OP1 verifies that section clock is not visible in the DISPLAY STATUS GND
Then HMI OP1 verifies that section date is not visible in the DISPLAY STATUS GND

Scenario: 3.1 Verifying Notification Display
Then HMI OP1 verifies that section mission is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section connection is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section clock is not visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section date is not visible in the NOTIFICATION DISPLAY

Scenario: 4. OP1 establishes a call to OP2
Meta:
@TEST_STEP_ACTION: OP1 establishes a call to OP2
@TEST_STEP_REACTION: OP2 has a call from OP1 in calls queue section
@TEST_STEP_REF: [CATS-REF: sOKD]
When HMI OP1 presses DA key OP2(as GND)
Then assign date time value for entry entry1
Then HMI OP1 has the call queue item OP2-OP1 in state out_ringing

Scenario: 4.1 OP2 receives the incoming call
Then HMI OP2 has the call queue item OP1-OP2 in state inc_initiated
Then HMI OP2 has the call queue item OP1-OP2 in the waiting list with name label <<OP1_NAME>>

Scenario: 5. OP1 terminates the call
Meta:
@TEST_STEP_ACTION: OP1 terminates the call
@TEST_STEP_REACTION: The call is terminated for both OP1 and OP2
@TEST_STEP_REF: [CATS-REF: 2n8s]
When HMI OP1 presses DA key OP2(as GND)
Then call duration for entry entry1 is calculated
Then HMI OP1 has in the call queue a number of 0 calls

Scenario: 5.1 Call is terminated also for OP2
Then HMI OP2 has in the call queue a number of 0 calls

Scenario: 6. OP1 checks that date and time are visible for the call to OP2 in Call History list
Meta:
@TEST_STEP_ACTION: OP1 checks that date and time are visible for the call to OP2 in Call History list
@TEST_STEP_REACTION: Date and time are visible for the call to OP2 in Call History list
@TEST_STEP_REF: [CATS-REF: Obzz]
When HMI OP1 with layout <<LAYOUT_GND>> presses function key CALLHISTORY
Then HMI OP1 verifies that call history list contains 1 entries
Then HMI OP1 verifies call history entry number 1 matches entry1
Then HMI OP1 verifies call history entry date format <<dateFormat>> for entry 1 matches date for entry1
Then HMI OP1 verifies call history entry time format <<timeFormat>> for entry 1 matches time for entry1

Scenario: 6.1 OP1 closes Call History popup window
Then HMI OP1 closes Call History popup window

Scenario: 7. OP1 changes its mission to APP
Meta:
@TEST_STEP_ACTION: OP1 changes its mission to APP
@TEST_STEP_REACTION: OP1 has APP mission assigned
@TEST_STEP_REF: [CATS-REF: SVvu]
When HMI OP1 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_APP_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 8. OP1 verifies that clock, date, connection status are visible and mission is not visible in Status bar and Status widget
Meta:
@TEST_STEP_ACTION: OP1 verifies that clock, date, connection status are visible and mission is not visible in Status bar and Status widget
@TEST_STEP_REACTION: Clock, date, connection status are visible and mission is not visible in Status bar and Status widget
@TEST_STEP_REF: [CATS-REF: t8xt]
Then HMI OP1 verifies that section clock is visible in the DISPLAY STATUS APP
Then HMI OP1 verifies that section date is visible in the DISPLAY STATUS APP
Then HMI OP1 verifies that section connection is visible in the DISPLAY STATUS APP
Then HMI OP1 verifies that section mission is not visible in the DISPLAY STATUS APP

Scenario: 8.1 Verifying Notification Display
Then HMI OP1 verifies that section clock is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section date is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section connection is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section mission is not visible in the NOTIFICATION DISPLAY

Scenario: 9. OP1 changes its mission to SUP-TWR
Meta:
@TEST_STEP_ACTION: OP1 changes its mission to SUP-TWR
@TEST_STEP_REACTION: OP1 has SUP-TWR mission assigned
@TEST_STEP_REF: [CATS-REF: J90m]
When HMI OP1 with layout <<LAYOUT_APP>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_SUP-TWR_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 10. OP1 verifies that clock, date, mission are visible and connection status is not visible in Status bar and Status widget
Meta:
@TEST_STEP_ACTION: OP1 verifies that clock, date, mission are visible and connection status is not visible in Status bar and Status widget
@TEST_STEP_REACTION: Clock, date, mission are visible and connection status is not visible in Status bar and Status widget
@TEST_STEP_REF: [CATS-REF: Mlbq]
Then HMI OP1 verifies that section clock is visible in the DISPLAY STATUS SUP-TWR
Then HMI OP1 verifies that section date is visible in the DISPLAY STATUS SUP-TWR
Then HMI OP1 verifies that section mission is visible in the DISPLAY STATUS SUP-TWR
Then HMI OP1 verifies that section connection is not visible in the DISPLAY STATUS SUP-TWR

Scenario: 10.1 Verifying Notification Display
Then HMI OP1 verifies that section clock is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section date is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section mission is visible in the NOTIFICATION DISPLAY
Then HMI OP1 verifies that section connection is not visible in the NOTIFICATION DISPLAY

Scenario: 11. OP1 stops first OP-Voice-Service instance
Meta:
@TEST_STEP_ACTION: OP1 stops first OP-Voice-Service instance
@TEST_STEP_REACTION: OP1 has in Maintenance Panel first connection with status Connecting and the second connection with status ACTIVE
@TEST_STEP_REF: [CATS-REF: J90m]
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost1.story
When HMI OP1 verifies that loading screen is visible
And waiting for 15 seconds

Scenario: 11.1 Verify Notification Display list shows OpVoiceService Failover took place
When HMI OP1 opens Notification Display list
When HMI OP1 selects tab event from notification display popup
Then HMI OP1 verifies that list Event contains on position 0 text OpVoiceService Failover took place

Scenario: 11.2 Close popup window
Then HMI OP1 closes notification popup

Scenario: 11.3 OP1 opens the Maintenance window
When HMI OP1 with layout <<LAYOUT_SUP-TWR>> presses function key SETTINGS
When HMI OP1 clicks on maintenancePanel button
Then HMI OP1 verifies that popup maintenance is visible

Scenario: 11.4 OP1 checks the OP-Voice connections status
Then HMI OP1 verifies that connection number 1 of Op Voice instance <<OPVOICE1_WS.URI>> has status CONNECTING
Then HMI OP1 verifies that connection number 2 of Op Voice instance <<OPVOICE2_WS.URI>> has status ACTIVE

Scenario: 11.5 OP1 closes Maintenance popup window
Then HMI OP1 closes maintenance popup

Scenario: 12. OP1 changes its mission to GND
Meta:
@TEST_STEP_ACTION: OP1 changes its mission to GND
@TEST_STEP_REACTION: OP1 has GND mission assigned
@TEST_STEP_REF: [CATS-REF: J90m]
When HMI OP1 with layout <<LAYOUT_SUP-TWR>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_GND_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: 13. OP1 verifies connections status
Meta:
@TEST_STEP_ACTION: OP1 verifies connections status
@TEST_STEP_REACTION: OP1 has connection status visible with message DEGRADED
@TEST_STEP_REF: [CATS-REF: 1PE9]
Then HMI OP1 verifies that section connection is visible in the DISPLAY STATUS GND
Then HMI OP1 has in the DISPLAY STATUS GND section connection the state DEGRADED

Scenario: 13.1 OP1 verifies connections status in Notification Display
Then HMI OP1 verifies that section connection is visible in the NOTIFICATION DISPLAY
Then HMI OP1 has in the DISPLAY STATUS GND section connection the state DEGRADED

Scenario: OP1 changes its mission to MAN-NIGHT-TACT
When HMI OP1 with layout <<LAYOUT_GND>> presses function key MISSIONS
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: OP1 stops second OP-Voice-Service instance and restarts both OP-Voice-Service instances
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story,
			  voice_GG/includes/StartOpVoiceActiveOnDockerHost1.story,
			  voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP1 has in the NOTIFICATION DISPLAY section connection the state CONNECTED

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
