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

import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;

import scripts.cats.hmi.ClickOnRedialCallButton;
import scripts.cats.hmi.SelectCallHistoryEntry;

public class CallHistoryUISteps extends AutomationSteps
{
   @When("$profileName redials last number")
   public void redialLastNumber( final String profileName )
   {
      evaluate( remoteStep( "Redial last number" ).scriptOn(
            profileScriptResolver().map( ClickOnRedialCallButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) ) );
   }


   @When("$profileName selects call history list entry number: $entryNumber")
   public void selectCallHistoryEntry( final String profileName, final Integer entryNumber )
   {
      evaluate( remoteStep( "Select call history list entry" )
            .scriptOn( profileScriptResolver().map( SelectCallHistoryEntry.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( SelectCallHistoryEntry.IPARAM_CALL_HISTORY_ENTRY_NUMBER, entryNumber ) );
   }

}
