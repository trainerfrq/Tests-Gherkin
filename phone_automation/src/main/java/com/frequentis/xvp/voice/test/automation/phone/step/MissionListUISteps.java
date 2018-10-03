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

import org.jbehave.core.annotations.Then;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;

import scripts.cats.hmi.actions.ClickActivateMission;
import scripts.cats.hmi.actions.ClickMissionCloseButton;
import scripts.cats.hmi.actions.SelectMissionFromList;
import scripts.cats.hmi.asserts.VerifyMissionList;
import scripts.cats.hmi.asserts.VerifyStatusDisplay;

public class MissionListUISteps extends AutomationSteps
{

   @Then("$profileName has the assigned mission $mission")
   public void verifyAssignedMission( final String profileName, final String mission )
   {
      evaluate(
            remoteStep( "Verify that the user has the correct assigned mission" )
                  .scriptOn( profileScriptResolver().map( VerifyStatusDisplay.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                  .input( VerifyStatusDisplay.IPARAM_STATUS_DISPLAY_TEXT, mission ) );
   }


   @Then("$profileName has a list of $numberOfMissions missions available")
   public void verifyListofAvailableMissions( final String profileName, final String numberOfMissions )
   {
      evaluate( remoteStep( "Verify that the user has the correct list of missions" )
            .scriptOn( profileScriptResolver().map( VerifyMissionList.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyMissionList.IPARAM_MISSION_LIST_SIZE, numberOfMissions ) );
   }


   @Then("$profileName changes current mission to mission $mission")
   public void changeMission( final String profileName, final String mission )
   {
      evaluate( remoteStep( "user selects mission: " + mission )
            .scriptOn( profileScriptResolver().map( SelectMissionFromList.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( SelectMissionFromList.IPARAM_MISSION_NAME, mission ) );
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

}
