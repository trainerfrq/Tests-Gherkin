Meta:
@TEST_CASE_VERSION: V20
@TEST_CASE_NAME: DisplayedTechnicalOpInformationFailover
@TEST_CASE_DESCRIPTION: As an operator having a running HMI machine 
I want to stop the OP-Voice-Service instances and open the Maintenance window
So I can verify the information regarding the connections and OP-Voice-HMI version
@TEST_CASE_PRECONDITION: Mission assigned with the following settings:
Layout settings:
- show status bar: yes
- show connection status: yes

Status widget settings:
- show connection status: yes

-OP-Voice service instance 1 of OP1 is ACTIVE
-OP-Voice service instance 2 of OP1 is PASSIVE
@TEST_CASE_PASS_FAIL_CRITERIA: The test is passed if the Maintenance window displays:
- Number of connected OP-Voice connections
- Status and IP of the OP-Voice connections
- Current HMI version
@TEST_CASE_DEVICES_IN_USE: OP1
@TEST_CASE_ID: PVCSX-TC-11724
@TEST_CASE_GLOBAL_ID: GID-5121757
@TEST_CASE_API_ID: 17163584

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: OP1 opens Notification Display popup and clears the event list
When HMI OP1 opens Notification Display list
When HMI OP1 selects tab event from notification display popup
When HMI OP1 clears the notification events from list

Scenario: Close popup window
Then HMI OP1 closes notification popup

Scenario: 1. OP1 stops OP-Voice-Service instance 1
Meta:
@TEST_STEP_ACTION: OP1 stops OP-Voice-Service instance 1
@TEST_STEP_REACTION: HMI displays DEGRADED in Notification and Status display.
@TEST_STEP_REF: [CATS-REF: fvoy]
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost1.story
When HMI OP1 verifies that loading screen is visible
And waiting for 15 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state DEGRADED
Then HMI OP1 has in the NOTIFICATION DISPLAY section connection the state DEGRADED

Scenario: 1.1 Verify Notification Display list shows OpVoiceService Failover took place
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Event list contains: OpVoiceService Failover took place
@TEST_STEP_REF: [CATS-REF: PPoe]
When HMI OP1 opens Notification Display list
When HMI OP1 selects tab event from notification display popup
Then HMI OP1 verifies that list Event contains on position 0 text OpVoiceService Failover took place

Scenario: 1.2 Close popup window
Then HMI OP1 closes notification popup

Scenario: 2. OP1 opens the Maintenance window
Meta:
@TEST_STEP_ACTION: OP1 opens the Maintenance window
@TEST_STEP_REACTION: Maintenance window is open
@TEST_STEP_REF: [CATS-REF: aqNq]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
When HMI OP1 clicks on maintenancePanel button
Then HMI OP1 verifies that popup maintenance is visible

Scenario: 3. OP1 checks the number of "Expected connections"
Meta:
@TEST_STEP_ACTION: OP1 checks the number of "Expected connections"
@TEST_STEP_REACTION: The number of "Expected connections" is 2
@TEST_STEP_REF: [CATS-REF: a9v1]
Then HMI OP1 verifies that the number of expecting connections is 2

Scenario: 4. OP1 checks the number of "Available connections"
Meta:
@TEST_STEP_ACTION: OP1 checks the number of "Available connections"
@TEST_STEP_REACTION: The number of "Available connections" is 2
@TEST_STEP_REF: [CATS-REF: 4kl1]
Then HMI OP1 verifies that the number of available connections is 2

Scenario: 5. OP1 checks the OP-Voice connections IPs and connectivity status
Meta:
@TEST_STEP_ACTION: OP1 checks the OP-Voice connections IPs and connectivity status
@TEST_STEP_REACTION: The OP-Voice connections IPs are displayed
@TEST_STEP_REF: [CATS-REF: qzQI]

Scenario: 5.1 Check first instance status and IP
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Connection 1 displays CONNECTING
@TEST_STEP_REF: [CATS-REF: 11p0]
Then HMI OP1 verifies that connection number 1 of Op Voice instance <<OPVOICE1_WS.URI>> has status CONNECTING

Scenario: 5.2 Check second instance status and IP
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Connection 2 displays ACTIVE
@TEST_STEP_REF: [CATS-REF: mnA1]
Then HMI OP1 verifies that connection number 2 of Op Voice instance <<OPVOICE2_WS.URI>> has status ACTIVE

Scenario: 6. OP1 checks Voice-HMI version
Meta:
@TEST_STEP_ACTION: OP1 checks Voice-HMI version
@TEST_STEP_REACTION: Current Voice-HMI version is displayed
@TEST_STEP_REF: [CATS-REF: xX2x]
Then HMI OP1 verifies that version of OP-Voice-HMI version is the same with the version from /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: 7. OP1 stops OP-Voice-Service instance 2
Meta:
@TEST_STEP_ACTION: OP1 stops OP-Voice-Service instance 2
@TEST_STEP_REACTION: HMI displays DISCONNECTED in Notification and Status display.
@TEST_STEP_REF: [CATS-REF: Vgig]
GivenStories: voice_GG/includes/KillOpVoiceActiveOnDockerHost2.story
Then HMI OP1 has a notification that shows Connection loss to OpVoice service
When HMI OP1 verifies that loading screen is visible
Then HMI OP1 has in the DISPLAY STATUS section connection the state DISCONNECTED
Then HMI OP1 has in the NOTIFICATION DISPLAY section connection the state DISCONNECTED

Scenario: 7.1 Verify Notification Display list shows Connection loss to OpVoice service
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Notification Display shows message: Connection loss to OpVoice
@TEST_STEP_REF: [CATS-REF: Due7]
When HMI OP1 opens Notification Display list
Then HMI OP1 verifies that list State contains text Connection loss to OpVoice service
Then HMI OP1 closes notification popup

Scenario: 8. OP1 opens the Maintenance window
Meta:
@TEST_STEP_ACTION: OP1 opens the Maintenance window
@TEST_STEP_REACTION: Maintenance window is open
@TEST_STEP_REF: [CATS-REF: uR6n]
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key SETTINGS
When HMI OP1 clicks on maintenancePanel button
Then HMI OP1 verifies that popup maintenance is visible

Scenario: 9. OP1 checks the number of "Expected connections"
Meta:
@TEST_STEP_ACTION:  OP1 checks the number of "Expected connections"
@TEST_STEP_REACTION: The number of "Expected connections" is 2
@TEST_STEP_REF: [CATS-REF: Ones]
Then HMI OP1 verifies that the number of expecting connections is 2

Scenario: 10. OP1 checks the number of "Available connections"
Meta:
@TEST_STEP_ACTION:  OP1 checks the number of "Available connections"
@TEST_STEP_REACTION: The number of "Available connections" is 2
@TEST_STEP_REF: [CATS-REF: Ones]
Then HMI OP1 verifies that the number of available connections is 2

Scenario: 11. OP1 checks the OP-Voice connections IPs and connectivity status
Meta:
@TEST_STEP_ACTION: OP1 checks the OP-Voice connections IPs and connectivity status
@TEST_STEP_REACTION: The OP-Voice connections IPs are displayed
@TEST_STEP_REF: [CATS-REF: UGUH]

Scenario: 11.1 Check first instance status and IP
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Connection 1 displays CONNECTING
@TEST_STEP_REF: [CATS-REF: 1234]
Then HMI OP1 verifies that connection number 1 of Op Voice instance <<OPVOICE1_WS.URI>> has status CONNECTING

Scenario: 11.2 Check second instance status and IP
Meta:
@TEST_STEP_ACTION: -
@TEST_STEP_REACTION: Connection 2 displays CONNECTING
@TEST_STEP_REF: [CATS-REF: qp5v]
Then HMI OP1 verifies that connection number 2 of Op Voice instance <<OPVOICE2_WS.URI>> has status CONNECTING

Scenario: 12. OP1 checks Voice-HMI version
Meta:
@TEST_STEP_ACTION: OP1 checks Voice-HMI version
@TEST_STEP_REACTION: Displayed Voice-HMI version is the desired one
@TEST_STEP_REF: [CATS-REF: xX2x]
Then HMI OP1 verifies that version of OP-Voice-HMI version is the same with the version from /configuration-files/<<systemName>>/voice-hmi-service-docker-image.json

Scenario: 12.1 OP1 closes the Maintenance window
Then HMI OP1 closes maintenance popup
Then HMI OP1 verifies that popup maintenance is not visible
Then HMI OP1 verifies that popup settings is not visible

Scenario: 13. OP1 starts OP-Voice-Service instances
Meta:
@TEST_STEP_ACTION: OP1 starts OP-Voice-Service instances
@TEST_STEP_REACTION: HMI displays CONNECTED in Notification and Status display
@TEST_STEP_REF: [CATS-REF: j3ny]
GivenStories: voice_GG/includes/StartOpVoiceActiveOnDockerHost1.story,
			  voice_GG/includes/StartOpVoiceActiveOnDockerHost2.story
Then waiting for 60 seconds
Then HMI OP1 has in the DISPLAY STATUS section connection the state CONNECTED
Then HMI OP1 has in the NOTIFICATION DISPLAY section connection the state CONNECTED

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done
