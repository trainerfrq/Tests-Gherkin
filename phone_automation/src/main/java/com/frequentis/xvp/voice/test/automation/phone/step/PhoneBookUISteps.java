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

import scripts.cats.hmi.actions.SelectCallRouteSelector;
import scripts.cats.hmi.actions.SelectPhoneBookEntry;
import scripts.cats.hmi.actions.ToggleCallPriority;
import scripts.cats.hmi.asserts.VerifyCallRouteSelector;
import scripts.cats.hmi.asserts.VerifyPhoneBookCallButtonState;
import scripts.cats.hmi.actions.WriteInPhoneBookTextBox;
import scripts.cats.hmi.asserts.VerifyPhoneBookTextBox;
import scripts.cats.hmi.asserts.VerifyToggleCallPriorityState;

public class PhoneBookUISteps extends AutomationSteps
{
   @When("$profileName writes in phonebook text box the address: $address")
   public void writeInPhoneBookTextBox( final String profileName, final String address )
   {
      evaluate(
            remoteStep( "Write in phonebook text box" )
                  .scriptOn( profileScriptResolver().map( WriteInPhoneBookTextBox.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                  .input( WriteInPhoneBookTextBox.IPARAM_SEARCH_BOX_TEXT, address ) );
   }


   @When("$profileName selects phonebook entry number: $entryNumber")
   public void selectPhoneBookEntry( final String profileName, final Integer entryNumber )
   {
      evaluate( remoteStep( "Select phone book entry" )
            .scriptOn( profileScriptResolver().map( SelectPhoneBookEntry.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( SelectPhoneBookEntry.IPARAM_PHONEBOOK_ENTRY_NUMBER, entryNumber ) );
   }


   @When("$profileName toggles call priority")
   public void toggleCallPriority( final String profileName )
   {
      evaluate( remoteStep( "Toggle call priority" ).scriptOn(
            profileScriptResolver().map( ToggleCallPriority.class, BookableProfileName.javafx ),
            assertProfile( profileName ) ) );
   }


   @When("$profileName selects call route selector: $callRouteSelector")
   public void selectCallRouteSelector( final String profileName, final String callRouteSelector )
   {
      evaluate( remoteStep( "Select call route selector" )
            .scriptOn( profileScriptResolver().map( SelectCallRouteSelector.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( SelectCallRouteSelector.IPARAM_CALL_ROUTE_SELECTOR_ID, callRouteSelector ) );
   }

   @Then("$profileName verify that call route selector shows $callRouteSelector")
   public void verifyCallRouteSelector( final String profileName, final String callRouteSelector )
   {
      evaluate( remoteStep( "Verify call route selector" )
              .scriptOn( profileScriptResolver().map( VerifyCallRouteSelector.class, BookableProfileName.javafx ),
                      assertProfile( profileName ) )
              .input( VerifyCallRouteSelector.IPARAM_CALL_ROUTE_SELECTOR_LABEL, callRouteSelector ) );
   }

   @Then("$profileName verifies that phone book call button is $state")
   public void verifyCallButtonState( final String profileName, final String state )
   {
      evaluate( remoteStep( "Verify call button has state " + state )
              .scriptOn( profileScriptResolver().map( VerifyPhoneBookCallButtonState.class, BookableProfileName.javafx ),
                      assertProfile( profileName ) )
              .input( VerifyPhoneBookCallButtonState.IPARAM_STATE, state ) );
   }

    @Then("$profileName verifies that phone book priority toggle is $state")
    public void verifyPriorityToggleState( final String profileName, final String state )
    {
        evaluate( remoteStep( "Verify call button has state " + state )
                .scriptOn( profileScriptResolver().map( VerifyToggleCallPriorityState.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyToggleCallPriorityState.IPARAM_STATE, state ) );
    }

    @Then("$profileName verifies that phone book text box displays text $text")
    public void verifyPhoneBookTextBox( final String profileName, final String text )
    {
        evaluate( remoteStep( "Verify phone book text box displays text " + text )
                .scriptOn( profileScriptResolver().map( VerifyPhoneBookTextBox.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyPhoneBookTextBox.IPARAM_SEARCH_BOX_TEXT, text ) );
    }

}
