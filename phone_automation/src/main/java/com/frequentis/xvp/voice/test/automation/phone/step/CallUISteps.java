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

import scripts.cats.hmi.actions.ClickDAButton;
import scripts.cats.hmi.actions.ClickFunctionKey;
import scripts.cats.hmi.actions.ClickOnCallHistoryCallButton;
import scripts.cats.hmi.actions.ClickOnPhoneBookCallButton;
import scripts.cats.hmi.actions.DragAndClickOnMenuButtonDAKey;
import scripts.cats.hmi.asserts.VerifyCallForwardState;
import scripts.cats.hmi.asserts.VerifyDAButtonState;
import scripts.cats.hmi.asserts.VerifyDAKeyDisplayCallType;

import java.util.List;

import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.CallRouteSelector;
import com.frequentis.xvp.voice.test.automation.phone.data.DAKey;
import com.frequentis.xvp.voice.test.automation.phone.data.FunctionKey;

public class CallUISteps extends AutomationSteps {
    private static final String PRIORITY_CALL_MENU_BUTTON_ID = "priority_call_menu_button";

    private static final String DECLINE_CALL_MENU_BUTTON_ID = "decline_call_menu_button";

    private static final String HOLD_MENU_BUTTON_ID = "hold_call_menu_button";

    private static final String TRANSFER_MENU_BUTTON_ID = "transfer_call_menu_button";


   @Given("the DA keys: $daKeys")
    public void defineDaKeys(final List<DAKey> daKeys) {
        final LocalStep localStep = localStep("Define DA keys");
        for (final DAKey daKey : daKeys) {
            final String key = daKey.getSource() + "-" + daKey.getTarget();
            setStoryListData(key, daKey);
            localStep.details(ExecutionDetails.create("Define DA key").usedData(key, daKey));
        }

        record(localStep);
    }

    @Given("the function keys: $functionKeys")
    public void defineFunctionKeys(final List<FunctionKey> functionKeys) {
        final LocalStep localStep = localStep("Define function keys");
        for (final FunctionKey functionKey : functionKeys) {
            final String key = functionKey.getKey();
            setStoryListData(key, functionKey);
            localStep.details(ExecutionDetails.create("Define function key").usedData(key, functionKey));
        }

        record(localStep);
    }

    @Given("the call route selectors: $callRouteSelectors")
    public void defineCallRouteSelectors(final List<CallRouteSelector> callRouteSelectors) {
        final LocalStep localStep = localStep("Define call route selector");
        for (final CallRouteSelector callRouteSelector : callRouteSelectors) {
            final String key = callRouteSelector.getKey();
            setStoryListData(key, callRouteSelector);
            localStep
                    .details(ExecutionDetails.create("Define call route selector").usedData(key, callRouteSelector));
        }

        record(localStep);
    }

    @When("$profileName presses DA key $target")
    @Alias("$profileName presses IA key $target")
    public void clickDA(final String profileName, final String target) {
        DAKey daKey = retrieveDaKey(profileName, target);

        evaluate(remoteStep("Check application status")
                         .scriptOn(
                                 profileScriptResolver().map(ClickDAButton.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(ClickDAButton.IPARAM_DA_KEY_ID, daKey.getId()));
    }

    @When("$profileName presses for $number times the DA key $target")
    public void clickDAManyTimes(final String profileName,  final Integer number, final String target) {
        for (int i = 1; i <= number; i++) {
            clickDA(profileName,target);
        }
    }

    @When("$profileName presses function key $type")
    public void clickFunctionKey(final String profileName, final String type) {
        FunctionKey functionKey = retrieveFunctionKey(type);

        evaluate(remoteStep("Click on a function key")
                         .scriptOn(
                                 profileScriptResolver().map(ClickFunctionKey.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(ClickFunctionKey.IPARAM_FUNCTION_KEY_ID, functionKey.getId()));
    }

    @When("$profileName initiates a call from the $functionPopup")
    @Alias("$profileName redials last number from $functionPopup")
    public void initiateCallFromPhoneBook(final String profileName, final String functionPopup) {
        switch (functionPopup) {
            case "phonebook":
                evaluate(remoteStep("Initiate call from phonebook").scriptOn(
                        profileScriptResolver().map(ClickOnPhoneBookCallButton.class, BookableProfileName.javafx),
                        assertProfile(profileName)));
                break;
            case "call history":
                evaluate(remoteStep("Initiate call from call history").scriptOn(
                        profileScriptResolver().map(ClickOnCallHistoryCallButton.class, BookableProfileName.javafx),
                        assertProfile(profileName)));
                break;
            default:
                break;
        }
    }

    @Then("$profileName has the DA key $target in state $state")
    @Alias("$profileName has the IA key $target in state $state")
    public void verifyDAState(final String profileName, final String target, final String state) {
        DAKey daKey = retrieveDaKey(profileName, target);

        evaluate(remoteStep("Check application status")
                         .scriptOn(
                                 profileScriptResolver().map(VerifyDAButtonState.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(VerifyDAButtonState.IPARAM_DA_KEY_ID, daKey.getId())
                         .input(VerifyDAButtonState.IPARAM_DA_KEY_STATE, state));
    }

    @Then("$profileName verifies that the DA key $target has the displayed call type $givenCallType")
    public void verifyDAKeyCallType( final String profileName, final String target,
          final String givenCallType )
    {
        DAKey daKey = retrieveDaKey(profileName, target);

        evaluate( remoteStep( "Verify DA key call type" )
              .scriptOn( profileScriptResolver().map( VerifyDAKeyDisplayCallType.class, BookableProfileName.javafx ),
                    assertProfile( profileName ) )
              .input( VerifyDAKeyDisplayCallType.IPARAM_DA_KEY_ID, daKey.getId() )
              .input( VerifyDAKeyDisplayCallType.IPARAM_DA_KEY_CALL_TYPE, givenCallType ) );
    }


    @When("$profileName declines the call on DA key $target")
    public void terminateCallOnDAKey(final String profileName, final String target) {
        DAKey daKey = retrieveDaKey(profileName, target);

        evaluate(remoteStep("Decline call on DA key " + target)
                         .scriptOn(
                                 profileScriptResolver().map(DragAndClickOnMenuButtonDAKey.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(DragAndClickOnMenuButtonDAKey.IPARAM_DA_KEY_ID, daKey.getId())
                         .input(DragAndClickOnMenuButtonDAKey.IPARAM_MENU_BUTTON_ID, DECLINE_CALL_MENU_BUTTON_ID));
    }

    @When("$profileName initiates a priority call on DA key $target")
    public void initiatePriorityCallOnDAKey(final String profileName, final String target) {
        DAKey daKey = retrieveDaKey(profileName, target);

        evaluate(remoteStep("Initiate priority call with DA key " + target)
                         .scriptOn(
                                 profileScriptResolver().map(DragAndClickOnMenuButtonDAKey.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(DragAndClickOnMenuButtonDAKey.IPARAM_DA_KEY_ID, daKey.getId())
                         .input(DragAndClickOnMenuButtonDAKey.IPARAM_MENU_BUTTON_ID, PRIORITY_CALL_MENU_BUTTON_ID));
    }


   @Then("$profileName has the function key $key in $state state")
   public void verifyForwardState(final String profileName, final String target, final String state) {
      FunctionKey key = retrieveFunctionKey(target);

      evaluate( remoteStep( "Verify operator position has the "+ target +" key in " + state + " state" )
            .scriptOn(profileScriptResolver().map( VerifyCallForwardState.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallForwardState.IPARAM_KEY_ID, key.getId() )
            .input( VerifyCallForwardState.IPARAM_KEY_STATE, state + "State" ) );
   }

    @When("$profileName puts on hold the active call using DA key $target")
    public void putOnHoldActiveCallOnDAKey( final String profileName, final String target )
    {
        DAKey daKey = retrieveDaKey(profileName, target);
        evaluate( remoteStep( "Put on hold active call" )
              .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonDAKey.class,
                    BookableProfileName.javafx ), assertProfile( profileName ) )
              .input( DragAndClickOnMenuButtonDAKey.IPARAM_MENU_BUTTON_ID, HOLD_MENU_BUTTON_ID )
              .input( DragAndClickOnMenuButtonDAKey.IPARAM_DA_KEY_ID, daKey.getId() ) );
    }

    @When("$profileName initiates a transfer using the DA key $target")
    public void transferActiveCallUsingDAKey( final String profileName, final String target  )
    {
        DAKey daKey = retrieveDaKey(profileName, target);
        evaluate( remoteStep( "Transfer active call" )
              .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonDAKey.class,
                    BookableProfileName.javafx ), assertProfile( profileName ) )
              .input( DragAndClickOnMenuButtonDAKey.IPARAM_MENU_BUTTON_ID, TRANSFER_MENU_BUTTON_ID )
              .input( DragAndClickOnMenuButtonDAKey.IPARAM_DA_KEY_ID, daKey.getId() ) );
    }

    private DAKey retrieveDaKey(final String source, final String target) {
        final DAKey daKey = getStoryListData(source + "-" + target, DAKey.class);
        evaluate(localStep("Check DA key").details(ExecutionDetails.create("Verify DA key is defined")
                                                                   .usedData("source", source).usedData("target", target).success(daKey != null)));
        return daKey;
    }

    private FunctionKey retrieveFunctionKey(final String key) {
        final FunctionKey functionKey = getStoryListData(key, FunctionKey.class);
        evaluate(localStep("Check Function Key").details(ExecutionDetails.create("Verify Function key is defined")
                                                                         .usedData("key", key).success(functionKey.getId() != null)));
        return functionKey;
    }
}
