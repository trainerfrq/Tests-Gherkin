Narrative:
As a caller operator having an active mission
I want to change mission
So I can verify that I can access other missions

Scenario: Booking profiles
Given booked profiles:
| profile | group | host           | identifier |
| javafx  | hmi   | <<CLIENT1_IP>> | HMI OP1    |
| javafx  | hmi   | <<CLIENT2_IP>> | HMI OP2    |
| javafx  | hmi   | <<CLIENT3_IP>> | HMI OP3    |

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: Opens missions window and verifies missions list
When HMI OP1 with layout <<LAYOUT_MISSION1>> presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 has missions <<MISSIONS_LIST>> available in the missions list

Scenario: Changes mission
		  @REQUIREMENTS: GID-3003102
		  @REQUIREMENTS: GID-3003103
		  @REQUIREMENTS: GID-4324230
		  @REQUIREMENTS: GID-4324231
Then HMI OP1 changes current mission to mission <<MISSION_2_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS 2 section mission the assigned mission <<MISSION_2_NAME>>

Scenario: Opens missions window and verifies missions list
When HMI OP1 with layout <<LAYOUT_MISSION2>> presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 has missions <<MISSIONS_LIST>> available in the missions list

Scenario: Changes mission
Then HMI OP1 changes current mission to mission <<MISSION_3_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS 3 section mission the assigned mission <<MISSION_3_NAME>>

Scenario: Opens missions window and verifies missions list
When HMI OP1 with layout <<LAYOUT_MISSION3>> presses function key MISSIONS
Then HMI OP1 has a list of <<NUMBER_OF_MISSIONS>> missions available
Then HMI OP1 has missions <<MISSIONS_LIST>> available in the missions list

Scenario: Changes mission
Then HMI OP1 changes current mission to mission <<MISSION_1_NAME>>
Then HMI OP1 activates mission
Then waiting for 5 seconds

Scenario: Verify operator mission
Then HMI OP1 has in the DISPLAY STATUS section mission the assigned mission <<MISSION_1_NAME>>

Scenario: A scenario that is only executed in case of an execution failure
Meta: @RunOnFailure
GivenStories: voice_GG/ui/includes/@CleanupStory.story
Then waiting until the cleanup is done

