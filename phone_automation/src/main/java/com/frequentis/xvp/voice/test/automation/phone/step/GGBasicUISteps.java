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

import scripts.cats.hmi.actions.ClickOnCallHistoryCallButton;
import scripts.cats.hmi.actions.ClickOnPhoneBookCallButton;
import scripts.cats.hmi.actions.ClickOnPopupCloseButton;
import scripts.cats.hmi.asserts.VerifyIdlePopupText;
import scripts.cats.hmi.asserts.VerifyNotificationLabel;

import javax.ws.rs.client.Client;

import org.jbehave.core.annotations.Then;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.audiointerface.json.messages.eplogic.signalling.EpLogicSignalChangedEvent;
import com.frequentis.xvp.voice.audiosimulator.TestAudioHttpClient;

public class GGBasicUISteps extends AutomationSteps
{
   @Then("$profileName has a notification that shows $notification")
   public void namedCallParties( final String profileName, final String notification  )
   {
      evaluate( remoteStep( "Verify operator position has the correct notificatione" ).scriptOn(
              profileScriptResolver().map( VerifyNotificationLabel.class, BookableProfileName.javafx ),
              assertProfile( profileName ) )
              .input(VerifyNotificationLabel.IPARAM_NOTIFICATION_LABEL_TEXT, notification));
   }

   @Then("$profileName verifies that idle popup is visible and contains the text: $text")
   public void verifyIdlePopupText( final String profileName, final String text  )
   {
      evaluate( remoteStep( "Verify operator position has the correct notificatione" ).scriptOn(
            profileScriptResolver().map( VerifyIdlePopupText.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( VerifyIdlePopupText.IPARAM_IDLE_POPUP_TEXT, text));
   }

   @Then("$profileName closes $popupName popup")
   public void closePopup(final String profileName, final String popupName ) {
      evaluate(remoteStep("Clear Call History list").scriptOn(
            profileScriptResolver().map( ClickOnPopupCloseButton.class, BookableProfileName.javafx),
            assertProfile(profileName))
      .input( ClickOnPopupCloseButton.IPARAM_POPUP_NAME, popupName));
   }

   @Then("$profileName opens $popupName popup")
   public void openPopup(final String profileName, final String popupName )
   {
      switch ( popupName )
      {
         case "maintenance":
            evaluate( remoteStep( "Initiate call from phonebook" ).scriptOn(
                  profileScriptResolver().map( ClickOnPhoneBookCallButton.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) ) );
            break;
         case "settings":
            evaluate( remoteStep( "Initiate call from call history" ).scriptOn(
                  profileScriptResolver().map( ClickOnCallHistoryCallButton.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) ) );
            break;
         default:
            break;
      }
   }


   public void disconnectHeadset( Client httpClient, String baseAddress, EpLogicSignalChangedEvent event)
   {
      TestAudioHttpClient test = new TestAudioHttpClient(httpClient, baseAddress);
      test.sendEpLogicSignalChangedEvent(event);
   }

}
