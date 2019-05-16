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
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.hmi.actions.ClickActivateMission;
import scripts.cats.hmi.actions.ClickMissionCloseButton;
import scripts.cats.hmi.actions.ClickMissionLabel;
import scripts.cats.hmi.actions.SelectMissionFromList;
import scripts.cats.hmi.actions.SelectMissionFromListByPosition;
import scripts.cats.hmi.asserts.VerifyMissionListNames;
import scripts.cats.hmi.asserts.VerifyMissionListSize;
import scripts.cats.hmi.asserts.VerifyStatusDisplay;

public class MissionListUISteps extends AutomationSteps
{

   @Then("$profileName has in the display status section $label the assigned mission $text")
   @Alias("$profileName has in the display status section $label the state $text")
   public void verifyAssignedMission( final String profileName, final String label, final String text )
   {
      evaluate( remoteStep( "Verify that the user has the correct assigned mission" )
            .scriptOn( profileScriptResolver().map( VerifyStatusDisplay.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
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


   @Then("$profileName changes current mission to mission $mission")
   public void changeMission( final String profileName, final String mission )
   {
      evaluate( remoteStep( "user selects mission: " + mission )
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


   @Then("$profileName closes mission popup window")
   public void clickCloseMission( final String profileName )
   {
      evaluate( remoteStep( "user clicks Close Mission" ).scriptOn(
            profileScriptResolver().map( ClickMissionCloseButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) ) );
   }


   @When("$profileName clicks on mission label $label")
   public void clickMissionLabel( final String profileName, final String label )
   {
      evaluate( remoteStep( "sser clicks mission label" )
            .scriptOn( profileScriptResolver().map( ClickMissionLabel.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( ClickMissionLabel.IPARAM_MISSION_DISPLAY_LABEL, label ) );
   }

}
