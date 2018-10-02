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
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;

import scripts.cats.hmi.ClickOnCallHistoryClearButton;
import scripts.cats.hmi.ClickOnCallHistoryCloseButton;
import scripts.cats.hmi.ClickOnRedialCallButton;
import scripts.cats.hmi.SelectCallHistoryEntry;
import scripts.cats.hmi.VerifyCallHistoryDialBtnLabel;
import scripts.cats.hmi.VerifyCallHistoryListEntries;
import scripts.cats.hmi.VerifyCallHistoryRedialBtnLabel;
import scripts.cats.hmi.VerifyRedialCallButtonState;

public class CallHistoryUISteps extends AutomationSteps
{
   @When("$profileName redials last number")
   public void redialLastNumber( final String profileName )
   {
      evaluate( remoteStep( "Redial last number" ).scriptOn(
            profileScriptResolver().map( ClickOnRedialCallButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) ) );
   }

   @Then("$profileName closes Call History popup window")
   public void closeCallHistoryPopup( final String profileName )
   {
      evaluate( remoteStep( "Close CallHistory popup window" ).scriptOn(
              profileScriptResolver().map( ClickOnCallHistoryCloseButton.class, BookableProfileName.javafx ),
              assertProfile( profileName ) ) );
   }

    @Then("$profileName clears Call History list")
    public void clearCallHistoryList( final String profileName )
    {
        evaluate( remoteStep( "Clear Call History list" ).scriptOn(
                profileScriptResolver().map( ClickOnCallHistoryClearButton.class, BookableProfileName.javafx ),
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

    @Then("$profileName verifies that call history list contains $number entries")
    public void verifyCallHistoryNumberOfEntries( final String profileName, final Integer number )
    {
        evaluate( remoteStep( "Verify call history list contains " + number.toString() + "entries" )
                .scriptOn( profileScriptResolver().map( VerifyCallHistoryListEntries.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyCallHistoryListEntries.IPARAM_CALL_HISTORY_LIST_SIZE, number ) );
    }

    @Then("$profileName verifies that call history call button has label $label")
    public void verifyCallHistoryButtonContainsLabel( final String profileName, final String label )
    {
        evaluate( remoteStep( "Verify call history call button contains label " + label)
                .scriptOn( profileScriptResolver().map( VerifyCallHistoryDialBtnLabel.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyCallHistoryDialBtnLabel.IPARAM_DISPLAY_NAME, label) );
    }

    @Then("$profileName verifies that call history redial button has label $label")
    public void verifyRedialButtonContainsLabel( final String profileName, final String label )
    {
        evaluate( remoteStep( "Verify call history redial button contains label " + label)
                .scriptOn( profileScriptResolver().map( VerifyCallHistoryRedialBtnLabel.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyCallHistoryRedialBtnLabel.IPARAM_DISPLAY_NAME, label) );
    }

    @Then("$profileName verifies that call history redial button is $state")
    public void verifyRedialButtonState( final String profileName, final String state )
    {
        evaluate( remoteStep( "Verify call history redial button has state " + state)
                .scriptOn( profileScriptResolver().map( VerifyRedialCallButtonState.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyRedialCallButtonState.IPARAM_STATE, state) );
    }



}
