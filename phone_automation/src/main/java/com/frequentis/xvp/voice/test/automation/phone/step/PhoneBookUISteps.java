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

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.io.FileUtils;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.CallRouteSelector;
import com.frequentis.xvp.voice.test.automation.phone.data.Mission;

import scripts.cats.hmi.actions.ClickOnPhoneBookCloseButton;
import scripts.cats.hmi.actions.ClickOnPhoneBookForwardButton;
import scripts.cats.hmi.actions.SelectCallRouteSelector;
import scripts.cats.hmi.actions.SelectPhoneBookEntry;
import scripts.cats.hmi.actions.ToggleCallPriority;
import scripts.cats.hmi.asserts.VerifyCallRouteSelector;
import scripts.cats.hmi.asserts.VerifyCallRouteSelectorFromList;
import scripts.cats.hmi.asserts.VerifyPhoneBookCallButtonState;
import scripts.cats.hmi.actions.WriteInPhoneBookTextBox;
import scripts.cats.hmi.asserts.VerifyPhoneBookForwardButtonState;
import scripts.cats.hmi.asserts.VerifyPhoneBookForwardButtonIfVisible;
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

    @Then("$profileName verifies that call route selector number $callRouteSelectorNo matches $namedCallRouteSelector")
    public void verifyCallRouteSelectorFromList(final String profileName, final String callRouteSelectorNumber, final String namedCallRouteSelector) {

        CallRouteSelector callRouteSelector = getStoryListData(namedCallRouteSelector, CallRouteSelector.class);
        evaluate(remoteStep("Verify call route selector number " + callRouteSelectorNumber)
                         .scriptOn(
                                 profileScriptResolver().map(VerifyCallRouteSelectorFromList.class, BookableProfileName.javafx),
                                 assertProfile(profileName))
                         .input(VerifyCallRouteSelectorFromList.IPARAM_CALL_ROUTE_SELECTOR_LABEL, callRouteSelector.getName())
                         .input(VerifyCallRouteSelectorFromList.IPARAM_CALL_ROUTE_SELECTOR_NUMBER, callRouteSelectorNumber));
    }

    @Then("$profileName closes Phone Book window")
    public void closeCallHistoryPopup(final String profileName) {
        evaluate(remoteStep("Close Phone Book window").scriptOn(
                profileScriptResolver().map(ClickOnPhoneBookCloseButton.class, BookableProfileName.javafx),
                assertProfile(profileName)));
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
                .scriptOn( profileScriptResolver().map( VerifyPhoneBookTextBox.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyPhoneBookTextBox.IPARAM_SEARCH_BOX_TEXT, text ) );
    }

    @Then("get for $namedCallRouteSelector the values assigned for Call Route Selector number $callRouteSelectorNumber for mission $mission from $path")
    public void assignValuesForCallRouteSelectors(final String namedCallRouteSelector, final Integer callRouteSelectorNumber, final String givenMission, final String path) throws IOException {

        List<Mission> missionList = readMissionFromJson(path);

        Mission receivedMission = getMissionFromList(missionList, givenMission);
        List<CallRouteSelector> callRouteSelectorList = receivedMission.getMissionAssignedCallRouteSelectors();

        CallRouteSelector callRouteSelector = getStoryListData(namedCallRouteSelector, CallRouteSelector.class);

        callRouteSelector.setId(callRouteSelectorList.get(callRouteSelectorNumber).getId());
        callRouteSelector.setName(callRouteSelectorList.get(callRouteSelectorNumber).getName());
        callRouteSelector.setPattern(callRouteSelectorList.get(callRouteSelectorNumber).getPattern());

        final LocalStep localStep = localStep("Values for Call Route Selector have been assigned ");
        localStep.details(ExecutionDetails.create("Values for Call Route Selector have been assigned ").received(callRouteSelector.toString()));
        record(localStep);
    }

    public List<Mission> readMissionFromJson(String path) throws IOException {

        Gson gson = new GsonBuilder().create();
        String callRouteSelectors = FileUtils.readFileToString(StepsUtil.getConfigFile(path));

        Type foundListType = new TypeToken<ArrayList<Mission>>() {}.getType();
        List<Mission> list = new Gson().fromJson(callRouteSelectors, foundListType);

        final LocalStep localStep = localStep("Missions read from missions.json ");
        localStep.details(ExecutionDetails.create("Missions read from missions.json are: ").received(list.toString()));
        record(localStep);

        return list;
    }


    public Mission getMissionFromList(List<Mission> missionList, String givenMission) {

        Mission result = null;
        for (Mission mission : missionList) {
            if (mission.getMissionName().equals( givenMission)) {
                result = mission;
            }
        }
        return result;
    }

}
