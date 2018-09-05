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

import java.util.List;

import com.frequentis.xvp.voice.test.automation.phone.data.FunctionKey;
import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Aliases;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.CallQueueItem;
import com.frequentis.xvp.voice.test.automation.phone.data.DAKey;

import scripts.cats.hmi.*;

public class UISteps extends AutomationSteps
{

   public static final String CONCAT_CHAR = "_";

   public static final String CALL_QUEUE_ITEM = "_callQueueItem";

   public static final String HOLD_MENU_BUTTON_ID = "hold_call_menu_button";

   public static final String TRANSFER_MENU_BUTTON_ID = "transfer_call_menu_button";

   public static final String PRIORITY_CALL_MENU_BUTTON_ID = "priority_call_menu_button";

   public static final String DECLINE_CALL_MENU_BUTTON_ID = "decline_call_menu_button";

   public static final String PRIORITY_CALL_STYLE_CLASS_NAME = "priority";

   public static final String ACTIVE_LIST_NAME = "activeList";

   public static final String WAITING_LIST_NAME = "waitingList";

   public static final String IA_CALL_TYPE = "ia";

   public static final String CALL_CONDITIONAL_FLAG = "xfr";


   @Given("the DA keys: $daKeys")
   public void defineDaKeys( final List<DAKey> daKeys )
   {
      final LocalStep localStep = localStep( "Define DA keys" );
      for ( final DAKey daKey : daKeys )
      {
         final String key = daKey.getSource() + "-" + daKey.getTarget();
         setStoryListData( key, daKey );
         localStep.details( ExecutionDetails.create( "Define DA key" ).usedData( key, daKey ) );
      }

      record( localStep );
   }


    @Given("the function keys: $functionKeys")
    public void defineFunctionKeys( final List<FunctionKey> functionKeys )
    {
        final LocalStep localStep = localStep( "Define function keys" );
        for ( final FunctionKey functionKey : functionKeys )
        {
            final String key = functionKey.getKey();
            setStoryListData( key, functionKey );
            localStep.details( ExecutionDetails.create( "Define function key" ).usedData( key, functionKey ) );
        }

        record( localStep );
    }


   @Given("the call queue items: $callQueueItems")
   public void defineCallQueueItems( final List<CallQueueItem> callQueueItems )
   {
      final LocalStep localStep = localStep( "Define call queue items" );
      for ( final CallQueueItem callQueueItem : callQueueItems )
      {
         final String itemId =
               reformatSipUris( callQueueItem.getSource() ).concat( CONCAT_CHAR )
                     .concat( reformatSipUris( callQueueItem.getTarget() ) ).concat( CONCAT_CHAR )
                     .concat( callQueueItem.getCallType() ).concat( CALL_QUEUE_ITEM );
         callQueueItem.setId( itemId );

         final String key = callQueueItem.getKey();
         setStoryListData( key, callQueueItem );
         localStep.details( ExecutionDetails.create( "Define call queue item" ).usedData( key, callQueueItem ) );
      }

      record( localStep );
   }


   @When("$profileName presses DA key $target")
   @Alias("$profileName presses IA key $target")
   public void clickDA( final String profileName, final String target )
   {
      DAKey daKey = retrieveDaKey( profileName, target );

      evaluate( remoteStep( "Check application status" )
            .scriptOn( profileScriptResolver().map( ClickDAButton.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( ClickDAButton.IPARAM_DA_KEY_ID, daKey.getId() ) );
   }

   @When("$profileName presses function key $type")
   public void clickFunctionKey(final String profileName, final String type)
   {
      FunctionKey functionKey = retrieveFunctionKey(type);

      evaluate( remoteStep("Click on a function key")
             .scriptOn( profileScriptResolver().map( ClickFunctionButton.class, BookableProfileName.javafx),
                    assertProfile(profileName))
              .input( ClickFunctionButton.IPARAM_FUNCTION_KEY_ID, functionKey.getId() ) );
   }


   @Then("$profileName has the DA key $target in state $state")
   @Alias("$profileName has the IA key $target in state $state")
   public void verifyDAState( final String profileName, final String target, final String state )
   {
      DAKey daKey = retrieveDaKey( profileName, target );

      evaluate( remoteStep( "Check application status" )
            .scriptOn( profileScriptResolver().map( VerifyDAButtonState.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyDAButtonState.IPARAM_DA_KEY_ID, daKey.getId() )
            .input( VerifyDAButtonState.IPARAM_DA_KEY_STATE, state ) );
   }


   @Then("$profileName has in the call queue the item $callQueueItem with priority")
   public void verifyCallQueueItemState( final String profileName, final String namedCallQueueItem )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify call queue item priority" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemStyleClass.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_CLASS_NAME, PRIORITY_CALL_STYLE_CLASS_NAME ) );
   }


   @Then("$profileName has the call queue item $callQueueItem in state $state")
   public void verifyPriorityCallQueueItem( final String profileName, final String namedCallQueueItem,
         final String state )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify call queue item status" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemStyleClass.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_CLASS_NAME, state ) );
   }


   @Then("$profileName has the call conditional flag set for call queue item $callQueueItem")
   public void verifyCallConditionFlagCallQueueItem( final String profileName, final String namedCallQueueItem )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify call queue item call conditional flag" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemStyleClass.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_CLASS_NAME, CALL_CONDITIONAL_FLAG ) );
   }


   @Then("$profileName has the IA call queue item $callQueueItem with audio direction $direction")
   public void verifyIACallQueueItemDirection( final String profileName, final String namedCallQueueItem,
         final String direction )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify if call queue item is of IA type" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemStyleClass.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_CLASS_NAME, IA_CALL_TYPE ) );

      evaluate( remoteStep( "Verify IA call direction" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemStyleClass.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemStyleClass.IPARAM_CALL_QUEUE_ITEM_CLASS_NAME, direction ) );
   }


   @Then("$profileName has the call queue item $callQueueItem in the waiting list with label $label")
   public void verifyCallQueueItemLabelActiveList( final String profileName, final String namedCallQueueItem,
         final String label )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify call queue item status" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemLabel.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemLabel.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemLabel.IPARAM_DISPLAY_NAME, label )
            .input( VerifyCallQueueItemLabel.IPARAM_LIST_NAME, WAITING_LIST_NAME ) );
   }


   @Then("$profileName accepts the call queue item $callQueueItem")
   @Aliases(values = { "$profileName cancels the call queue item $callQueueItem",
         "$profileName retrieves from hold the call queue item $callQueueItem" })
   public void clickCallQueueItem( final String profileName, final String namedCallQueueItem )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Click call queue item" )
            .scriptOn( profileScriptResolver().map( ClickCallQueueItem.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( ClickCallQueueItem.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() ) );
   }


   @Then("$profileName has in the call queue a number of $numberOfCalls calls")
   public void verifyCallQueueLength( final String profileName, final Integer numberOfCalls )
   {
      evaluate( remoteStep( "Verify call queue length" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueLength.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueLength.IPARAM_QUEUE_EXPECTED_LENGTH, numberOfCalls ) );
   }


   @When("$profileName puts on hold the active call")
   public void putOnHoldActiveCall( final String profileName )
   {
      evaluate( remoteStep( "Put on hold active call queue item" )
            .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonFirstCallQueueItem.class,
                  BookableProfileName.javafx ), assertProfile( profileName ) )
            .input( DragAndClickOnMenuButtonFirstCallQueueItem.IPARAM_MENU_BUTTON_ID, HOLD_MENU_BUTTON_ID )
            .input( DragAndClickOnMenuButtonFirstCallQueueItem.IPARAM_LIST_NAME, ACTIVE_LIST_NAME ) );
   }


   @Then("$profileName rejects the waiting call queue item")
   public void rejectWaitingCall( final String profileName )
   {
      evaluate( remoteStep( "Reject waiting call queue item" )
            .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonFirstCallQueueItem.class,
                  BookableProfileName.javafx ), assertProfile( profileName ) )
            .input( DragAndClickOnMenuButtonFirstCallQueueItem.IPARAM_MENU_BUTTON_ID, DECLINE_CALL_MENU_BUTTON_ID )
            .input( DragAndClickOnMenuButtonFirstCallQueueItem.IPARAM_LIST_NAME, WAITING_LIST_NAME ) );
   }


   @When("$profileName initiates a transfer on the active call")
   public void transferActiveCall( final String profileName )
   {
      evaluate( remoteStep( "Transfer active call queue item" )
            .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonFirstCallQueueItem.class,
                  BookableProfileName.javafx ), assertProfile( profileName ) )
            .input( DragAndClickOnMenuButtonFirstCallQueueItem.IPARAM_MENU_BUTTON_ID, TRANSFER_MENU_BUTTON_ID )
            .input( DragAndClickOnMenuButtonFirstCallQueueItem.IPARAM_LIST_NAME, ACTIVE_LIST_NAME ) );
   }


   @When("$profileName declines the call on DA key $target")
   public void terminateCallOnDAKey( final String profileName, final String target )
   {
      DAKey daKey = retrieveDaKey( profileName, target );

      evaluate( remoteStep( "Decline call on DA key " + target )
            .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonDAKey.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( DragAndClickOnMenuButtonDAKey.IPARAM_DA_KEY_ID, daKey.getId() )
            .input( DragAndClickOnMenuButtonDAKey.IPARAM_MENU_BUTTON_ID, DECLINE_CALL_MENU_BUTTON_ID ) );
   }


   @When("$profileName initiates a priority call on DA key $target")
   public void initiatePriorityCallOnDAKey( final String profileName, final String target )
   {
      DAKey daKey = retrieveDaKey( profileName, target );

      evaluate( remoteStep( "Initiate priority call with DA key " + target )
            .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonDAKey.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( DragAndClickOnMenuButtonDAKey.IPARAM_DA_KEY_ID, daKey.getId() )
            .input( DragAndClickOnMenuButtonDAKey.IPARAM_MENU_BUTTON_ID, PRIORITY_CALL_MENU_BUTTON_ID ) );
   }


   @Then("$profileName is in transfer state")
   public void verifyTransferState( final String profileName )
   {
      evaluate( remoteStep( "Verify operator position is in transfer state" ).scriptOn(
            profileScriptResolver().map( VerifyTransferState.class, BookableProfileName.javafx ),
            assertProfile( profileName ) ) );
   }


   @Then("the call queue item $namedCallQueueItem is $state for only one of the operator positions: $profileNames")
   public void verifyIACallAcceptedOnlyOnOnePosition( final String namedCallQueueItem, final String state,
         final String profileNames )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );
      String[] profiles = profileNames.split( "\\s*,\\s*" );
      int nrOfMatchingCallQueueItems = 0;
      for ( final String profileName : profiles )
      {
         final RemoteStepResult remoteStepResult =
               evaluate( remoteStep( "Check if call queue item " + namedCallQueueItem + " exists and if it is in state "
                     + state + " on profile: " + profileName )
                           .scriptOn( profileScriptResolver().map( VerifyCallQueueItemStateIfPresent.class,
                                 BookableProfileName.javafx ), assertProfile( profileName ) )
                           .input( VerifyCallQueueItemStateIfPresent.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
                           .input( VerifyCallQueueItemStateIfPresent.IPARAM_CALL_QUEUE_ITEM_CLASS_NAME, state ) );

         boolean wasFound =
               ( boolean ) remoteStepResult
                     .getOutput( VerifyCallQueueItemStateIfPresent.OPARAM_CALL_QUEUE_ITEM_WAS_FOUND );

         if ( wasFound )
         {
            nrOfMatchingCallQueueItems++;
         }
      }

      evaluate( localStep( "Verifying number of matching call queue items" ).details(
            ExecutionDetails.create( "Checking if only one matching call queue item was found on all profiles" )
                  .expected( "Exactly one matching call queue item" )
                  .received( "A number of " + nrOfMatchingCallQueueItems + " matching call queue items" )
                  .success( nrOfMatchingCallQueueItems == 1 ) ) );
   }

   @Then("$profileName has the assigned mission $mission")
   public void verifyAssignedMission(final String profileName, final String mission){
       evaluate( remoteStep( "Verify that the user has the correct assigned mission" )
               .scriptOn( profileScriptResolver().map( VerifyStatusDisplay.class, BookableProfileName.javafx ),
                       assertProfile( profileName ) )
               .input( VerifyStatusDisplay.IPARAM_STATUS_DISPLAY_TEXT, mission ) );
   }

    @Then("$profileName has a list of $numberOfMissions missions available")
    public void verifyListofAvailableMissions(final String profileName, final String numberOfMissions){
        evaluate( remoteStep( "Verify that the user has the correct list of missions" )
                .scriptOn( profileScriptResolver().map( VerifyMissionList.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyMissionList.IPARAM_MISSION_LIST_SIZE, numberOfMissions ) );
    }


   private DAKey retrieveDaKey( final String source, final String target )
   {
      final DAKey daKey = getStoryListData( source + "-" + target, DAKey.class );
      evaluate( localStep( "Check DA key" ).details( ExecutionDetails.create( "Verify DA key is defined" )
            .usedData( "source", source ).usedData( "target", target ).success( daKey != null ) ) );
      return daKey;
   }

   private FunctionKey retrieveFunctionKey(final String key)
   {
      final FunctionKey functionKey = getStoryListData (key, FunctionKey.class);
      evaluate(localStep("Check Function Key")
                 .details(ExecutionDetails.create("Verify Function key is defined")
                 .usedData("key", key)
                 .success(functionKey.getId()!=null)));
      return functionKey;
   }


   private String reformatSipUris( final String sipUri )
   {
      return sipUri.replaceAll( "[.,:]", CONCAT_CHAR );
   }
}
