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
import scripts.cats.hmi.actions.CleanUpPopupWindow;
import scripts.cats.hmi.actions.ClickContainerTab;
import scripts.cats.hmi.asserts.VerifyLoadingOverlayIsVisible;
import scripts.cats.hmi.asserts.VerifyNotificationLabel;

public class GGBasicUISteps extends AutomationSteps
{
   @Then("$profileName has a notification that shows $notification")
   public void namedCallParties( final String profileName, final String notification  )
   {
      evaluate( remoteStep( "Verify operator position has the correct notification" ).scriptOn(
              profileScriptResolver().map( VerifyNotificationLabel.class, BookableProfileName.javafx ),
              assertProfile( profileName ) )
              .input(VerifyNotificationLabel.IPARAM_NOTIFICATION_LABEL_TEXT, notification));
   }

   @When("$profileName verifies that loading screen is visible")
   public void verifyLoadingScreen( final String profileName)
   {
      evaluate( remoteStep( "Verify that loading screen is visible" ).scriptOn(
              profileScriptResolver().map( VerifyLoadingOverlayIsVisible.class, BookableProfileName.javafx ),
              assertProfile( profileName ) ));
   }

   @When("$profileName selects grid tab $tabPosition")
   public void clicksOnKey( final String profileName, Integer tabPosition )
   {
      evaluate( remoteStep( "Presses key" ).scriptOn(
              profileScriptResolver().map( ClickContainerTab.class, BookableProfileName.javafx ),
              assertProfile( profileName ) )
              .input(ClickContainerTab.IPARAM_TAB_POSITION, tabPosition-1));
   }

   @Then("if $profileName has notification $text it does a clean up by closing $popupName window")
   public void cleaUpClosePopup( final String profileName, final String text, final String popupName )
   {
      evaluate( remoteStep( "ClickOnCloseButton" ).scriptOn(
              profileScriptResolver().map( CleanUpPopupWindow.class, BookableProfileName.javafx ),
              assertProfile( profileName ) )
              .input( CleanUpPopupWindow.IPARAM_NOTIFICATION_LABEL_TEXT, text)
              .input( CleanUpPopupWindow.IPARAM_POPUP_NAME, popupName ) );
   }

}
