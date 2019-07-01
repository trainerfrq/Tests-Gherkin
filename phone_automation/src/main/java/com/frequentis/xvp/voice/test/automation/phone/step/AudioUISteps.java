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
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import scripts.cats.hmi.actions.ClickContainerTab;
import scripts.cats.hmi.actions.ClickOnIdlePopupButton;
import scripts.cats.hmi.actions.ClickOnMuteButton;
import scripts.cats.hmi.actions.ClickOnMuteSideToneButton;
import scripts.cats.hmi.actions.ClickOnPopupCloseButton;
import scripts.cats.hmi.actions.ClickOnVolumeSlider;
import scripts.cats.hmi.actions.ClickOnWarningPopupButton;
import scripts.cats.hmi.asserts.Attended.VerifyIdlePopupText;
import scripts.cats.hmi.asserts.Attended.VerifyWarningPopupCountDownIsVisible;
import scripts.cats.hmi.asserts.Attended.VerifyWarningPopupText;
import scripts.cats.hmi.asserts.VerifyMuteButtonState;
import scripts.cats.hmi.asserts.VerifyMuteSidetoneButtonState;
import scripts.cats.hmi.asserts.VerifyVolumeSliderLevel;

public class AudioUISteps extends AutomationSteps
{
   @When("$profileName clicks on mute button $buttonName")
   public void clickOnMuteButton(final String profileName, final String buttonName)
   {
      evaluate( remoteStep( "Click on mute button" ).scriptOn(
            profileScriptResolver().map( ClickOnMuteButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ClickOnMuteButton.IPARAM_MUTE_BUTTON_NAME, buttonName ) );
   }

   @When("$profileName clicks on side tone mute button $buttonName")
   public void clickOnSideToneMuteButton(final String profileName, final String buttonName)
   {
      evaluate(remoteStep( "Click on side tone mute button" ).scriptOn(
            profileScriptResolver().map( ClickOnMuteSideToneButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ClickOnMuteSideToneButton.IPARAM_MUTE_SIDETONE_BUTTON_NAME, buttonName ) );
   }

   @When("$profileName drags volume slider $volumeSlider to Y value $yValue")
   public void clickOnVolumeSlider(final String profileName, final String volumeSlider, final String yValue)
   {
      evaluate(remoteStep( "Click on volume slider" ).scriptOn(
            profileScriptResolver().map( ClickOnVolumeSlider.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ClickOnVolumeSlider.IPARAM_SLIDER_NAME, volumeSlider )
            .input( ClickOnVolumeSlider.IPARAM_SLIDER_LEVEL, yValue )
      );
   }

   @Then("$profileName verifies that mute button $buttonName is in $muteState state")
   public void verifyMuteButtonState(final String profileName, final String buttonName, final String muteState)
   {
      evaluate( remoteStep( "Verify mute button state is in expected state" ).scriptOn(
            profileScriptResolver().map( VerifyMuteButtonState.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( VerifyMuteButtonState.IPARAM_MUTE_BUTTON_NAME, buttonName )
            .input( VerifyMuteButtonState.IPARAM_STATE, muteState )
      );
   }

   @Then("$profileName verifies that mute sidetone button $buttonName is in $muteState state")
   public void verifyMuteSidetoneButtonState(final String profileName, final String buttonName, final String muteState)
   {
      evaluate( remoteStep( "Verify mute sidetone button state is in expected state" ).scriptOn(
            profileScriptResolver().map( VerifyMuteSidetoneButtonState.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( VerifyMuteSidetoneButtonState.IPARAM_MUTE_SIDFETONE_BUTTON_NAME, buttonName )
            .input( VerifyMuteSidetoneButtonState.IPARAM_STATE, muteState )
      );
   }

   @Then("$profileName verifies that volume slider $volumeSlider is set to level $levelValue")
   public void verifyVolumeSliderLevel(final String profileName, final String volumeSlider, final String levelValue)
   {
      evaluate( remoteStep("Verify volume slider level is at the expected level").scriptOn(
            profileScriptResolver().map( VerifyVolumeSliderLevel.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( VerifyVolumeSliderLevel.IPARAM_SLIDER_NAME, volumeSlider )
            .input( VerifyVolumeSliderLevel.IPARAM_SLIDER_VALUE, levelValue )
      );
   }

   @Then("$profileName verifies that idle popup contains the text: $text")
   public void verifyIdlePopupText( final String profileName, final String text )
   {
      evaluate( remoteStep( "Verify idle popup contains the expected text" ).scriptOn(
            profileScriptResolver().map( VerifyIdlePopupText.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( VerifyIdlePopupText.IPARAM_IDLE_POPUP_TEXT, text ) );
   }


   @Then("$profileName verifies that warning popup contains the text: $text")
   public void verifyWarningPopupVisibility( final String profileName, final String text )
   {
      evaluate( remoteStep( "Verify warning popup contains: " + text ).scriptOn(
            profileScriptResolver().map( VerifyWarningPopupText.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
              .input( VerifyWarningPopupText.IPARAM_WARNING_POPUP_TEXT, text ));
   }


   @Then("$profileName verifies warning popup countdown is visible")
   public void verifyWarningPopupCountVisibility( final String profileName )
   {
      evaluate( remoteStep( "Verify warning popup is visible" ).scriptOn(
              profileScriptResolver().map( VerifyWarningPopupCountDownIsVisible.class, BookableProfileName.javafx ),
              assertProfile( profileName ) ));
   }

   @Then("$profileName closes $popupName popup")
   public void closePopup( final String profileName, final String popupName )
   {
      evaluate( remoteStep( "ClickOnCloseButton" ).scriptOn(
            profileScriptResolver().map( ClickOnPopupCloseButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ClickOnPopupCloseButton.IPARAM_POPUP_NAME, popupName ) );
   }


   @Then("$profileName opens $panelName panel from idle popup")
   public void openIdlePopupPanel( final String profileName, final String panelName )
   {
            evaluate( remoteStep( "Open " + panelName + " while in idle state" ).scriptOn(
                  profileScriptResolver().map( ClickOnIdlePopupButton.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
                  .input( ClickOnIdlePopupButton.IPARAM_BUTTON_NAME, panelName ) );
   }


   @Then("$profileName click on $buttonName button from idle warning popup")
   public void clickOnWarningPopupButton( final String profileName, final String buttonName )
   {
      evaluate( remoteStep( "Choose option " + buttonName + " from idle warning popup" ).scriptOn(
            profileScriptResolver().map( ClickOnWarningPopupButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ClickOnWarningPopupButton.IPARAM_BUTTON_NAME, buttonName ) );
   }
}
