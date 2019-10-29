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
import scripts.cats.hmi.actions.Settings.CleanUpMuteButton;
import scripts.cats.hmi.actions.Settings.CleanUpMuteSideToneButton;
import scripts.cats.hmi.actions.Settings.ClickOnClosePanelButton;
import scripts.cats.hmi.actions.Settings.ClickOnMuteButton;
import scripts.cats.hmi.actions.Settings.ClickOnMuteSideToneButton;
import scripts.cats.hmi.actions.Settings.ClickOnVolumeSlider;
import scripts.cats.hmi.actions.ClickOnIdlePopupButton;
import scripts.cats.hmi.actions.ClickOnPopupCloseButton;
import scripts.cats.hmi.actions.ClickOnWarningPopupButton;
import scripts.cats.hmi.asserts.Attended.VerifyIdlePopupText;
import scripts.cats.hmi.asserts.Attended.VerifyWarningPopupCountDownIsVisible;
import scripts.cats.hmi.asserts.Attended.VerifyWarningPopupText;
import scripts.cats.hmi.asserts.Settings.VerifyClosePanelButtonState;
import scripts.cats.hmi.asserts.Settings.VerifyClosePanelButtonVisible;
import scripts.cats.hmi.asserts.Settings.VerifyMuteButtonState;
import scripts.cats.hmi.asserts.Settings.VerifyMuteSidetoneButtonState;
import scripts.cats.hmi.asserts.Settings.VerifyVolumeSliderLevel;
import scripts.cats.hmi.asserts.Settings.VerifySymbolButtonState;

public class SettingsUISteps extends AutomationSteps
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

   @When("$profileName drags volume slider $volumeSlider to $levelValue level")
   public void clickOnVolumeSlider(final String profileName, final String volumeSlider, final String levelValue)
   {
      evaluate(remoteStep( "Click on volume slider" ).scriptOn(
            profileScriptResolver().map( ClickOnVolumeSlider.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ClickOnVolumeSlider.IPARAM_SLIDER_NAME, volumeSlider )
            .input( ClickOnVolumeSlider.IPARAM_SLIDER_LEVEL, levelValue )
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

    @When("$profileName checks button $buttonName state and unmutes it if it finds it mute")
    public void unMuteButton(final String profileName, final String buttonName)
    {
        evaluate( remoteStep( "Click on mute button" ).scriptOn(
                profileScriptResolver().map( CleanUpMuteButton.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input( CleanUpMuteButton.IPARAM_MUTE_BUTTON_NAME, buttonName ) );
    }

    @When("$profileName checks side tone button $buttonName state and unmutes it if it finds it mute")
    public void unMuteSideToneButton(final String profileName, final String buttonName)
    {
        evaluate(remoteStep( "Click on side tone mute button" ).scriptOn(
                profileScriptResolver().map( CleanUpMuteSideToneButton.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input( CleanUpMuteSideToneButton.IPARAM_MUTE_BUTTON_NAME, buttonName ) );
    }


    @Then("$profileName checks that $buttonName button has state $state ")
    public void verifyStateForSymbolButton(final String profileName, final String buttonName, final String state)
    {
        evaluate( remoteStep( "User verifies " + buttonName + "state" ).scriptOn(
                profileScriptResolver().map( VerifySymbolButtonState.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input( VerifySymbolButtonState.IPARAM_BUTTON_NAME, buttonName )
                .input(VerifySymbolButtonState.IPARAM_BUTTON_STATE, state)
        );
    }

    @Then("$profileName verifies that close panel button number $number is visible ")
    public void verifyClosePanelButtonVisible(final String profileName, final Integer number)
    {
        evaluate( remoteStep( "Verify clean button is visible" ).scriptOn(
                profileScriptResolver().map( VerifyClosePanelButtonVisible.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input( VerifyClosePanelButtonVisible.IPARAM_BUTTON_NUMBER, number )
        );
    }

    @Then("$profileName verifies that close panel button number $number is marked $state")
    public void verifyClosePanelButtonState(final String profileName, final String number, final String state)
    {
        String actualState = state;

        if(state.equals("yellow")){
            actualState = "next";
        }
        else if(state.equals("green"))
        {  actualState = "selected";}

        evaluate( remoteStep( "Verify close panel button is in expected state" ).scriptOn(
                profileScriptResolver().map( VerifyClosePanelButtonState.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input( VerifyClosePanelButtonState.IPARAM_BUTTON_NUMBER, number )
                .input( VerifyClosePanelButtonState.IPARAM_STATE, actualState )
        );
    }

    @When("$profileName clicks on close panel button number $number")
    public void clicksClosePanelButtonVisible(final String profileName, final String number)
    {
        evaluate( remoteStep( "Clicks on  clean button is visible" ).scriptOn(
                profileScriptResolver().map( ClickOnClosePanelButton.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input( ClickOnClosePanelButton.IPARAM_BUTTON_NUMBER, number )
        );
    }
}
