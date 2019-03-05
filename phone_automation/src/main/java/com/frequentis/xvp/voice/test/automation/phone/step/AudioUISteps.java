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
import scripts.cats.hmi.actions.ClickOnIdlePopupButton;
import scripts.cats.hmi.actions.ClickOnPopupCloseButton;
import scripts.cats.hmi.actions.ClickOnWarningPopupButton;
import scripts.cats.hmi.asserts.Attended.VerifyIdlePopupText;
import scripts.cats.hmi.asserts.Attended.VerifyPositionUnattendedPopupVisible;
import scripts.cats.hmi.asserts.Attended.VerifyWarningPopupCountDownIsVisible;
import scripts.cats.hmi.asserts.Attended.VerifyWarningPopupText;

public class AudioUISteps extends AutomationSteps
{

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

   @Then("$profileName verifies that popup $popupName is $exists")
   public void verifyHoldButtonExistence( final String profileName, final String popupName, final String exists )
   {
      Boolean isVisible = true;
      if(exists.contains("not")){
         isVisible = false;
      }
      evaluate( remoteStep( "Verify popup visible" )
              .scriptOn( profileScriptResolver().map( VerifyPositionUnattendedPopupVisible.class,
                      BookableProfileName.javafx ), assertProfile( profileName ) )
              .input( VerifyPositionUnattendedPopupVisible.IPARAM_POPUP_NAME, popupName )
              . input(VerifyPositionUnattendedPopupVisible.IPARAM_IS_VISIBLE, isVisible));
   }


   @Then("$profileName closes $popupName")
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
