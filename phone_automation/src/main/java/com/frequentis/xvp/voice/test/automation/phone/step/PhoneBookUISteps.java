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
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.CallRouteSelector;
import com.frequentis.xvp.voice.test.automation.phone.data.Mission;
import com.google.common.reflect.TypeToken;
import com.google.gson.Gson;
import org.apache.commons.io.FileUtils;
import org.jbehave.core.annotations.*;
import org.json.JSONArray;
import org.json.JSONObject;
import scripts.cats.hmi.actions.PhoneBook.*;
import scripts.cats.hmi.asserts.PhoneBook.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class PhoneBookUISteps extends AutomationSteps
{
   @When("$profileName writes in phonebook text box the address: $address")
   @Alias("$profileName writes in phonebook text box: $address")
   @Then("$profileName inserts in phonebook text box the address: <address>")
   public void writeInPhoneBookTextBox( @Named("profileName") final String profileName, @Named("address") final String address )
   {
      evaluate(
            remoteStep( "Write in phonebook text box" )
                  .scriptOn(
                        profileScriptResolver().map( WriteInPhoneBookTextBox.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                  .input( WriteInPhoneBookTextBox.IPARAM_SEARCH_BOX_TEXT, address ) );
   }


   @When("$profileName selects phonebook entry number: $entryNumber")
   public void selectPhoneBookEntry( final String profileName, final Integer entryNumber )
   {
      evaluate( remoteStep( "Select phone book entry" )
            .scriptOn(
                  profileScriptResolver().map( SelectPhoneBookEntry.class, BookableProfileName.javafx ),
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
            .scriptOn(
                  profileScriptResolver().map( SelectCallRouteSelector.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( SelectCallRouteSelector.IPARAM_CALL_ROUTE_SELECTOR_ID, callRouteSelector ) );
   }

   @Given("the $number of phonebook entries from $resourcePath")
   public void countPhonebookEntries(String number, String resourcePath)
   {
      Integer numberOfEntries = 0;
      try
      {
         JSONArray jsonArray = new JSONArray( FileUtils.readFileToString( StepsUtil.getConfigFile( resourcePath ) ));
         for (int i = 0; i < jsonArray.length(); i++)
         {
            JSONObject jsonObject = jsonArray.getJSONObject( i );
            JSONArray dataSetsArray = jsonObject.getJSONArray( "dataSets" );
            numberOfEntries = numberOfEntries + dataSetsArray.length();
         }
      }
      catch ( IOException e )
      {
         e.printStackTrace();
      }

      setStoryListData( number, String.valueOf( numberOfEntries ) );
   }


   @Then("$profileName verify that call route selector shows $callRouteSelector")
   public void verifyCallRouteSelector( final String profileName, final String callRouteSelector )
   {
      evaluate( remoteStep( "Verify call route selector" )
            .scriptOn(
                  profileScriptResolver().map( VerifyCallRouteSelector.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallRouteSelector.IPARAM_CALL_ROUTE_SELECTOR_LABEL, callRouteSelector ) );
   }


   @Then("$profileName verifies that phone book call button is $state")
   public void verifyCallButtonState( final String profileName, final String state )
   {
      evaluate( remoteStep( "Verify call button has state " + state )
            .scriptOn(
                  profileScriptResolver().map( VerifyPhoneBookCallButtonState.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyPhoneBookCallButtonState.IPARAM_STATE, state ) );
   }


   @Then("$profileName verifies that phone book forward button state is $state")
   public void verifyForwardButtonState( final String profileName, final String state )
   {
      evaluate( remoteStep( "Verify forward button has state " + state )
            .scriptOn(
                  profileScriptResolver().map( VerifyPhoneBookForwardButtonState.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyPhoneBookForwardButtonState.IPARAM_STATE, state ) );
   }


   @Then("$profileName checks that phone book forward button is $state")
   public void verifyExistanceForwardButtonState( final String profileName, final String state )
   {
      evaluate( remoteStep( "Verify forward button is " + state )
            .scriptOn(
                  profileScriptResolver()
                        .map( VerifyPhoneBookForwardButtonIfVisible.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyPhoneBookForwardButtonIfVisible.IPARAM_VISISBILITY, state ) );
   }


   @Then("$profileName verifies that phone book priority toggle is $state")
   public void verifyPriorityToggleState( final String profileName, final String state )
   {
      evaluate( remoteStep( "Verify call button has state " + state )
            .scriptOn(
                  profileScriptResolver().map( VerifyToggleCallPriorityState.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyToggleCallPriorityState.IPARAM_STATE, state ) );
   }


   @Then("$profileName verifies that phone book text box displays text $text")
   public void verifyPhoneBookTextBox( final String profileName, final String text )
   {
      evaluate( remoteStep( "Verify phone book text box displays text " + text )
            .scriptOn(
                  profileScriptResolver().map( VerifyPhoneBookSelectionTextBox.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyPhoneBookSelectionTextBox.IPARAM_SEARCH_BOX_TEXT, text ) );
   }


   @Then("$profileName verifies that phone book dial pad has the $layout layout")
   public void verifyDialpadLayout( final String profileName, final String layout )
   {
      evaluate( remoteStep( "Verify dial pad layout is " + layout )
            .scriptOn(
                  profileScriptResolver().map( VerifyKeyboardLayout.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyKeyboardLayout.IPARAM_KEYBOARD_LAYOUT, layout ) );
   }


   @When("$profileName toggles the $toggle key")
   public void toggleDialpad( final String profileName, final String toggle )
   {
      evaluate( remoteStep( "Toggle dialpad keyboard" ).scriptOn(
            profileScriptResolver().map( ToggleKeyboard.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ToggleKeyboard.IPARAM_KEYBOARD_TYPE, toggle ) );
   }


   @When("$profileName closes phonebook")
   public void closePhonebook( final String profileName )
   {
      evaluate( remoteStep( "Close phonebook" ).scriptOn(
            profileScriptResolver().map( ClickOnPhoneBookCloseButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) ) );
   }

   @When("$profileName clicks on the scroll down button in phonebook for $number time(s)")
   public void scrollDownPhonebook(final String profileName, final String number)
   {
      evaluate( remoteStep( "Scroll down phonebook" ).scriptOn(
            profileScriptResolver().map( ClickOnPhoneBookScrollDownButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
             .input(ClickOnPhoneBookScrollDownButton.IPARAM_CLICK_NUMBER, number));
   }


   @When("$profileName presses key $key")
   public void clicksOnKey( final String profileName, final String key )
   {
      evaluate( remoteStep( "Presses key" ).scriptOn(
            profileScriptResolver().map( ClickOnKeyboard.class, BookableProfileName.javafx ),
            assertProfile( profileName ) )
            .input( ClickOnKeyboard.IPARAM_KEY, key ) );
   }


   @Then("$profileName checks that input text box displays $inputText text")
   public void verifyInputTextBox( final String profileName, final String inputText )
   {
      evaluate( remoteStep( "Verify input text box displays text " + inputText )
            .scriptOn(
                  profileScriptResolver().map( VerifyPhoneBookInputTextBox.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyPhoneBookInputTextBox.IPARAM_INPUT_BOX_TEXT, inputText ) );
   }


   @When("$profileName deletes a character from text box")
   public void clicksOnKey( final String profileName )
   {
      evaluate( remoteStep( "Deletes a character" ).scriptOn(
            profileScriptResolver().map( ClickOnPhoneBookDeleteButton.class, BookableProfileName.javafx ),
            assertProfile( profileName ) ) );
   }


   @Then("$profileName verifies that all phonebook entries have text $text highlighted")
   public void verifyPhonebookListHighlighted( final String profileName, final String text )
   {
      evaluate( remoteStep( "Verify text " + text + "is highlighted" )
            .scriptOn(
                  profileScriptResolver().map( VerifyPhoneBookHighlightText.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyPhoneBookHighlightText.IPARAM_HIGHLIGHT_TEXT, text ) );
   }


   @Then("$profileName verifies that phonebook list has $number items")
   public void verifyPhonebookListSize( final String profileName, final String number )
   {
      evaluate( remoteStep( "Verify phone book has the expected size" )
            .scriptOn(
                  profileScriptResolver().map( VerifyPhoneBookListSize.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyPhoneBookListSize.IPARAM_PHONEBOOK_LIST_SIZE, number ) );
   }

   @Then("$profileName verifies that the total number of phonebook entries is $number")
   public void verifyTotalNumberOfEntriesInPhonebook(final String profileName, final String totalNumber)
   {
      String phoneBookEntriesNumber = getStoryListData( totalNumber, String.class );

      evaluate( remoteStep( "Verify total number of entries is the expected one" )
            .scriptOn(
                  profileScriptResolver().map( VerifyTotalNumberOfEntries.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyTotalNumberOfEntries.IPARAM_TOTAL_ENTRIES_NUMBER, phoneBookEntriesNumber ) );
   }


   @Then("$profileName verifies the Call Route Selector list for mission $givenMission from $path")
   public void verifyCallRouteSelectors( final String profileName, final String givenMission,
         final String path ) throws IOException
   {

      Mission receivedMission = readMissionFromJson( path ).get( givenMission );
      List<CallRouteSelector> callRouteSelectorList = receivedMission.getMissionAssignedCallRouteSelectors();

      List<String> callRouteSelectorNameList = new ArrayList<>();
      for ( CallRouteSelector selector : callRouteSelectorList )
      {
         callRouteSelectorNameList.add( selector.getName() );
      }
      final RemoteStepResult remoteStepResult =
            evaluate( remoteStep( "Verify call route selector list is present " )
                  .scriptOn(
                        profileScriptResolver().map( VerifyCallRouteSelectorList.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) ) );

      final String response = ( String ) remoteStepResult.getOutput(
            VerifyCallRouteSelectorList.OPARAM_RECEIVED_CALL_ROUTE_SELECTORS );
      List<String> responseList = new ArrayList<>( Arrays.asList( response.split( ",") ) );

      for ( int i = 0; i < callRouteSelectorNameList.size(); i++ )
      {
         final LocalStep localStep = localStep( "Missions read from missions.json are well-displayed " );
         localStep.details( ExecutionDetails.create( "Call Route Selector number " + i + " is well-displayed " )
               .expected( callRouteSelectorNameList.get( i ) )
               .received( responseList.get( i ) )
               .success( responseList.get( i ).contains( callRouteSelectorNameList.get( i ) ) ) );
         record( localStep );
      }
   }

   @When("$profileName using information about $missionName found in $path selects: $callRouteSelector")
   public void selectsCallRouteSelectorsByEntry( final String profileName, final String missionName, final String path, final String callRouteSelector ) throws IOException
   {
      Mission receivedMission = readMissionFromJson( path ).get( missionName );
      List<CallRouteSelector> callRouteSelectorList = receivedMission.getMissionAssignedCallRouteSelectors();

      for ( int i=0; i<callRouteSelectorList.size();i++ )
      {
        String name = callRouteSelectorList.get(i).getName();
        if(name.toLowerCase().equals(callRouteSelector)){
           evaluate( remoteStep( "Select call route selector" )
                   .scriptOn(
                           profileScriptResolver().map( SelectCallRouteSelectorByEntry.class, BookableProfileName.javafx ),
                           assertProfile( profileName ) )
                   .input( SelectCallRouteSelectorByEntry.IPARAM_CALL_ROUTE_SELECTOR_ENTRY, i+1 ) );
        }
      }

   }



   public Map<String, Mission> readMissionFromJson( String path ) throws IOException
   {
      String missions = FileUtils.readFileToString( StepsUtil.getConfigFile( path ) );
      List<Mission> list = new Gson().fromJson( missions, new TypeToken<ArrayList<Mission>>(){}.getType() );
      return list.stream().collect( Collectors.toMap( Mission::getMissionName, mission -> mission ) );
   }

}
