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

import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;

import scripts.cats.hmi.actions.ClickOnKeyboard;
import scripts.cats.hmi.actions.ClickOnPhoneBookCloseButton;
import scripts.cats.hmi.actions.ClickOnPhoneBookDeleteButton;
import scripts.cats.hmi.actions.ClickOnPhoneBookForwardButton;
import scripts.cats.hmi.actions.SelectCallRouteSelector;
import scripts.cats.hmi.actions.SelectPhoneBookEntry;
import scripts.cats.hmi.actions.ToggleCallPriority;
import scripts.cats.hmi.actions.ToggleKeyboard;
import scripts.cats.hmi.asserts.VerifyCallRouteSelector;
import scripts.cats.hmi.asserts.VerifyKeyboardLayout;
import scripts.cats.hmi.asserts.VerifyPhoneBookCallButtonState;
import scripts.cats.hmi.actions.WriteInPhoneBookTextBox;
import scripts.cats.hmi.asserts.VerifyPhoneBookForwardButtonState;
import scripts.cats.hmi.asserts.VerifyPhoneBookForwardButtonIfVisible;
import scripts.cats.hmi.asserts.VerifyPhoneBookHighlightText;
import scripts.cats.hmi.asserts.VerifyPhoneBookListSize;
import scripts.cats.hmi.asserts.VerifyPhoneBookSelectionTextBox;
import scripts.cats.hmi.asserts.VerifyPhoneBookInputTextBox;
import scripts.cats.hmi.asserts.VerifyToggleCallPriorityState;

public class PhoneBookUISteps extends AutomationSteps
{
   @When("$profileName writes in phonebook text box the address: $address")
   @Alias("$profileName writes in phonebook text box: $address")
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

    @When("$profileName activates call forward from phonebook")
    public void clickCallForward( final String profileName )
    {
        evaluate( remoteStep( "Activate call forward from phonebook" ).scriptOn(
                profileScriptResolver().map( ClickOnPhoneBookForwardButton.class, BookableProfileName.javafx ),
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

    @Then("$profileName verifies that phone book forward button state is $state")
    public void verifyForwardButtonState( final String profileName, final String state )
    {
        evaluate( remoteStep( "Verify forward button has state " + state )
                .scriptOn( profileScriptResolver().map( VerifyPhoneBookForwardButtonState.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyPhoneBookForwardButtonState.IPARAM_STATE, state ) );
    }

    @Then("$profileName checks that phone book forward button is $state")
    public void verifyExistanceForwardButtonState( final String profileName, final String state )
    {
        evaluate( remoteStep( "Verify forward button is " + state )
                .scriptOn( profileScriptResolver().map( VerifyPhoneBookForwardButtonIfVisible.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyPhoneBookForwardButtonIfVisible.IPARAM_VISISBILITY, state ) );
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
                .scriptOn( profileScriptResolver().map( VerifyPhoneBookSelectionTextBox.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyPhoneBookSelectionTextBox.IPARAM_SEARCH_BOX_TEXT, text ) );
    }

    @Then("$profileName verifies that phone book dial pad has the $layout layout")
    public void verifyDialpadLayout( final String profileName, final String layout )
    {
        evaluate( remoteStep( "Verify dial pad layout is " + layout )
                .scriptOn( profileScriptResolver().map( VerifyKeyboardLayout.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyKeyboardLayout.IPARAM_KEYBOARD_LAYOUT, layout ) );
    }

    @When("$profileName toggles the $toggle key")
    public void toggleDialpad( final String profileName, final String toggle )
    {
        evaluate( remoteStep( "Toggle dialpad keyboard" ).scriptOn(
                profileScriptResolver().map( ToggleKeyboard.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input(ToggleKeyboard.IPARAM_KEYBOARD_TYPE, toggle));
    }

    @When("$profileName closes phonebook")
    public void closePhonebook( final String profileName )
    {
        evaluate( remoteStep( "Close phonebook" ).scriptOn(
                profileScriptResolver().map( ClickOnPhoneBookCloseButton.class, BookableProfileName.javafx ),
                assertProfile( profileName ) ) );
    }

    @When("$profileName presses key $key")
    public void clicksOnKey( final String profileName, final String key )
    {
        evaluate( remoteStep( "Presses key" ).scriptOn(
                profileScriptResolver().map( ClickOnKeyboard.class, BookableProfileName.javafx ),
                assertProfile( profileName ) )
                .input(ClickOnKeyboard.IPARAM_KEY, key));
    }

    @Then("$profileName checks that input text box displays $inputText text")
    public void verifyInputTextBox( final String profileName, final String inputText )
    {
        evaluate( remoteStep( "Verify input text box displays text " + inputText )
                .scriptOn( profileScriptResolver().map( VerifyPhoneBookInputTextBox.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyPhoneBookInputTextBox.IPARAM_INPUT_BOX_TEXT, inputText ) );
    }

    @When("$profileName deletes a character from text box")
    public void clicksOnKey( final String profileName )
    {
        evaluate( remoteStep( "Deletes a character" ).scriptOn(
                profileScriptResolver().map( ClickOnPhoneBookDeleteButton.class, BookableProfileName.javafx ),
                assertProfile( profileName ) ));
    }

    @Then("$profileName verifies that all phonebook entries have text $text highlighted")
    public void verifyPhonebookListHighlighted( final String profileName, final String text )
    {
        evaluate( remoteStep( "Verify text " + text + "is highlighted" )
                .scriptOn( profileScriptResolver().map( VerifyPhoneBookHighlightText.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyPhoneBookHighlightText.IPARAM_HIGHLIGHT_TEXT, text ) );
    }

    @Then("$profileName verifies that phonebook list has $number items")
    public void verifyPhonebookListSize( final String profileName, final String number )
    {
        evaluate( remoteStep( "Verify phone book has the expected size" )
                .scriptOn( profileScriptResolver().map( VerifyPhoneBookListSize.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyPhoneBookListSize.IPARAM_PHONEBOOK_LIST_SIZE, number ) );
    }

}
