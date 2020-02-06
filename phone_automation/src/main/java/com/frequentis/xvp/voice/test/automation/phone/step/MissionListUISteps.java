/************************************************************************
 ** PROJECT:   XVP
 ** LANGUAGE:  Java, J2SE JDK 1.8
 **
 ** COPYRIGHT: FREQUENTIS AG
 **            Innovationsstrasse 1
 **            A-1100 VIENNA
 **            AUSTRIA
 **            tel +43 1 811 50-0
 **
 ** The copyright to the computer program(s) herein
 ** is the property of Frequentis AG, Austria.
 ** The program(s) shall not be used and/or copied without
 ** the written permission of Frequentis AG.
 **
 ************************************************************************/
package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.FunctionKey;
import com.frequentis.xvp.voice.test.automation.phone.data.StatusKey;
import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.hmi.actions.Mission.*;
import scripts.cats.hmi.asserts.Mission.VerifyCurrentActiveMission;
import scripts.cats.hmi.asserts.Mission.VerifyMissionListNames;
import scripts.cats.hmi.asserts.Mission.VerifyMissionListSize;
import scripts.cats.hmi.asserts.Mission.VerifyRolesInMissionList;
import scripts.cats.hmi.asserts.VerifyStatusDisplay;

public class MissionListUISteps extends AutomationSteps
{

   @Then("$profileName has in the $key section $label the assigned mission $text")
   @Alias("$profileName has in the $key section $label the state $text")
   public void verifyAssignedMission( final String profileName, final String key, final String label, final String text )
   {
      StatusKey statusKey = retrieveStatusKey(profileName, key);
      evaluate( remoteStep( "Verify that the user has the correct assigned mission" )
            .scriptOn( profileScriptResolver().map( VerifyStatusDisplay.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input(VerifyStatusDisplay.IPARAM_STATUS_DISPLAY_KEY, statusKey.getId())
            .input( VerifyStatusDisplay.IPARAM_STATUS_DISPLAY_LABEL, label + "Label" )
            .input( VerifyStatusDisplay.IPARAM_STATUS_DISPLAY_TEXT, text ) );
   }


   @Then("$profileName has a list of $numberOfMissions missions available")
   public void verifyListofAvailableMissions( final String profileName, final String numberOfMissions )
   {
      evaluate( remoteStep( "Verify that the user has the correct list of missions" )
            .scriptOn( profileScriptResolver().map( VerifyMissionListSize.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyMissionListSize.IPARAM_MISSION_LIST_SIZE, numberOfMissions ) );
   }

   @Then("$profileName has missions $missionNames available in the missions list")
   public void verifyNamesOfAvailableMissions( final String profileName, final String missionNames )
   {
      evaluate( remoteStep( "Verify that the user has the correct list of mission names" )
              .scriptOn( profileScriptResolver().map( VerifyMissionListNames.class, BookableProfileName.javafx ),
                      assertProfile( profileName ) )
              .input( VerifyMissionListNames.IPARAM_MISSION_LIST_NAMES, missionNames ) );
   }

    @Then("$profileName has roles $roleNames available in the roles list")
    public void verifyNamesOfAvailableRoles( final String profileName, final String roleNames )
    {
        evaluate( remoteStep( "Verify that the mission has the correct list of roles" )
                .scriptOn( profileScriptResolver().map( VerifyRolesInMissionList.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyRolesInMissionList.IPARAM_ROLE_LIST_NAMES, roleNames ) );
    }

    @Then("$profileName verifies that current active mission is mission $mission")
    public void verifyActiveMission( final String profileName, final String mission )
    {
        evaluate( remoteStep( "Verify active mission is: " + mission )
                .scriptOn( profileScriptResolver().map( VerifyCurrentActiveMission.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyCurrentActiveMission.IPARAM_MISSION_NAME, mission ) );
    }


   @Then("$profileName changes current mission to mission $mission")
   public void changeMission( final String profileName, final String mission )
   {
      evaluate( remoteStep( "User selects mission: " + mission )
            .scriptOn( profileScriptResolver().map( SelectMissionFromList.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( SelectMissionFromList.IPARAM_MISSION_NAME, mission ) );
   }


   @Then("$profileName chooses to change current mission to mission from position $position")
   public void changeMissionByPosition( final String profileName, final int position )
   {
      int pos = position-1;
      evaluate( remoteStep( "user selects mission: " + position )
              .scriptOn( profileScriptResolver().map( SelectMissionFromListByPosition.class, BookableProfileName.javafx ),
                      assertProfile( profileName ) )
              .input( SelectMissionFromListByPosition.IPARAM_MISSION_POSITION, position ) );
   }


   @Then("$profileName activates mission")
   public void clickActivateMission( final String profileName )
   {
      evaluate( remoteStep( "user clicks Activate Mission" ).scriptOn(
            profileScriptResolver().map( ClickActivateMission.class, BookableProfileName.javafx ),
            assertProfile( profileName ) ) );
   }

    @Then("$profileName with layout $layoutName will do a change mission if $key section $label has not the default mission $text")
    public void cleanupMission( final String profileName, final String layoutName, final String key, final String label, final String text )
    {
        String keyMission = layoutName + "-" + label.toUpperCase()+"S";
        FunctionKey functionKey = retrieveFunctionKey(keyMission);
        StatusKey statusKey = retrieveStatusKey(profileName, key);
        evaluate( remoteStep( "Clean-up mission" )
                .scriptOn( profileScriptResolver().map( CleanUpMission.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(CleanUpMission.IPARAM_STATUS_DISPLAY_KEY, statusKey.getId())
                .input( CleanUpMission.IPARAM_STATUS_DISPLAY_LABEL, label + "Label" )
                .input( CleanUpMission.IPARAM_STATUS_DISPLAY_TEXT, text )
                .input( CleanUpMission.IPARAM_FUNCTION_KEY_ID, functionKey.getId() ));
    }

    @When("$profileName scrolls down $number page(s) in mission list")
    public void scrollDownMission(final String profileName, final String number)
    {
        evaluate( remoteStep( "Scroll down mission" ).scriptOn(
                profileScriptResolver().map( ClickOnMissionScrollDownButton.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input( ClickOnMissionScrollDownButton.IPARAM_CLICK_NUMBER, number ));
    }


    private StatusKey retrieveStatusKey(final String source, final String key) {
        final StatusKey statusKey = getStoryListData(source + "-" + key, StatusKey.class);
        evaluate(localStep("Check Status Key").details(ExecutionDetails.create("Verify Status key is defined")
                .usedData("source", source).usedData("key", key).success(statusKey.getId() != null)));
        return statusKey;
    }

    private FunctionKey retrieveFunctionKey(final String key) {
        final FunctionKey functionKey = getStoryListData(key, FunctionKey.class);
        evaluate(localStep("Check Function Key").details(ExecutionDetails.create("Verify Function key is defined")
                .usedData("key", key).success(functionKey.getId() != null)));
        return functionKey;
    }

}
