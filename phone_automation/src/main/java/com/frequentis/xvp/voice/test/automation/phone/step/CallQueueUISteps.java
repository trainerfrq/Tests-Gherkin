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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

import scripts.cats.hmi.actions.ClickCallQueueItem;
import scripts.cats.hmi.actions.ClickOnCallQueueInfoContainer;
import scripts.cats.hmi.actions.DragAndClickOnMenuButtonFirstCallQueueItem;
import scripts.cats.hmi.asserts.VerifyCallQueueBarState;
import scripts.cats.hmi.asserts.VerifyCallQueueInfoContainerIfVisible;
import scripts.cats.hmi.asserts.VerifyCallQueueInfoContainerLabel;
import scripts.cats.hmi.asserts.VerifyCallQueueItemLabel;
import scripts.cats.hmi.asserts.VerifyCallQueueItemStateIfPresent;
import scripts.cats.hmi.asserts.VerifyCallQueueItemStyleClass;
import scripts.cats.hmi.asserts.VerifyCallQueueLength;

public class CallQueueUISteps extends AutomationSteps
{
   private static final String CONCAT_CHAR = "_";

   private static final String CALL_QUEUE_ITEM = "_callQueueItem";

   private static final String PRIORITY_CALL_STYLE_CLASS_NAME = "priority";

   private static final String CALL_CONDITIONAL_FLAG = "xfr";

   private static final String IA_CALL_TYPE = "ia";

   private static final String ACTIVE_LIST_NAME = "activeList";

   private static final String WAITING_LIST_NAME = "waitingList";

   private static final String HOLD_MENU_BUTTON_ID = "hold_call_menu_button";

   private static final String DECLINE_CALL_MENU_BUTTON_ID = "decline_call_menu_button";

   private static final String TRANSFER_MENU_BUTTON_ID = "transfer_call_menu_button";

   private static final Map<String, String> CALL_QUEUE_LIST_MAP = new HashMap<>();

   static
   {
      CALL_QUEUE_LIST_MAP.put( "waiting", WAITING_LIST_NAME );
      CALL_QUEUE_LIST_MAP.put( "active", ACTIVE_LIST_NAME );
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
   public void verifyCallConditionalFlagCallQueueItem( final String profileName, final String namedCallQueueItem )
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


   @Then("$profileName has the call queue item $callQueueItem in the $callQueueList list with label $label")
   public void verifyCallQueueItemLabelActiveList( final String profileName, final String namedCallQueueItem,
         final String callQueueList, final String label )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify call queue item status" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemLabel.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemLabel.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemLabel.IPARAM_DISPLAY_NAME, label )
            .input( VerifyCallQueueItemLabel.IPARAM_LIST_NAME, CALL_QUEUE_LIST_MAP.get( callQueueList ) ) );
   }


   @Then("$profileName accepts the call queue item $callQueueItem")
   @Aliases(values = { "$profileName cancels the call queue item $callQueueItem",
         "$profileName retrieves from hold the call queue item $callQueueItem",
         "$profileName terminates the call queue item $callQueueItem",
         "$profileName presses the call queue item $callQueueItem" })
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

    @When("$profileName deactivates call forward by pressing on the call queue info")
    public void clickOnCallQueueInfo( final String profileName )
    {
        evaluate( remoteStep( "Deactivates call forward by pressing on the call queue info" )
                .scriptOn( profileScriptResolver().map( ClickOnCallQueueInfoContainer.class,
                        BookableProfileName.javafx ), assertProfile( profileName ) ));
    }


    @Then("$profileName verifies that call queue item bar signals call state $state")
    public void verifyCallQueueBar( final String profileName, final String state )
    {
        evaluate( remoteStep( "Verify call queue item bar" )
                .scriptOn( profileScriptResolver().map( VerifyCallQueueBarState.class,
                        BookableProfileName.javafx ), assertProfile( profileName ) )
                .input( VerifyCallQueueBarState.IPARAM_CALL_QUEUE_STATE, state ) );
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


    @Then("$profileName verifies that call queue info container is $state")
    public void verifyCallQueueInfoContainerState( final String profileName, final String state )
    {
        evaluate( remoteStep( "Verify call queue info container state" )
                .scriptOn( profileScriptResolver().map( VerifyCallQueueInfoContainerIfVisible.class,
                        BookableProfileName.javafx ), assertProfile( profileName ) )
                .input( VerifyCallQueueInfoContainerIfVisible.IPARAM_VISISBILITY, state ) );
    }

    @Then("$profileName verifies that call queue info container contains $info")
    public void verifyCallQueueInfoContainerLabel( final String profileName, final String info )
    {
        evaluate( remoteStep( "Verify call queue info container info" )
                .scriptOn( profileScriptResolver().map( VerifyCallQueueInfoContainerLabel.class,
                        BookableProfileName.javafx ), assertProfile( profileName ) )
                .input( VerifyCallQueueInfoContainerLabel.IPARAM_INFO_LABEL, info ) );
    }


   private String reformatSipUris( final String sipUri )
   {
      return sipUri != null ? sipUri.replaceAll( "[.,:]", CONCAT_CHAR ) : "";
   }
}
