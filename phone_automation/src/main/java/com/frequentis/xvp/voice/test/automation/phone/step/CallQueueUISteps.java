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
import com.frequentis.xvp.voice.test.automation.phone.data.CallQueueItem;
import org.jbehave.core.annotations.Aliases;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.hmi.actions.CallQueue.CleanUpCallQueue;
import scripts.cats.hmi.actions.CallQueue.ClickCallQueueElementsList;
import scripts.cats.hmi.actions.CallQueue.ClickCallQueueItem;
import scripts.cats.hmi.actions.CallQueue.ClickCallQueueItemByPosition;
import scripts.cats.hmi.actions.CallQueue.ClickOnCallQueueInfoContainer;
import scripts.cats.hmi.actions.CallQueue.DragAndClickOnMenuButtonFirstCallQueueItem;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueBarState;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueCollapsedAreaLength;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueCollapsedAreaSectionLength;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueContainerVisibility;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueInfoContainerIfVisible;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueInfoContainerLabel;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueItemCallType;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueItemIndexInList;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueItemLabel;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueItemNotInList;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueItemStateIfPresent;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueItemStyleClass;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueItemTransferState;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueLength;
import scripts.cats.hmi.asserts.CallQueue.VerifyCallQueueSectionLength;
import scripts.cats.hmi.asserts.CallQueue.VerifyMenuButtonFirstCallQueueItemIsVisible;
import scripts.cats.hmi.asserts.Monitoring.VerifyMonitoringCallQueueItem;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CallQueueUISteps extends AutomationSteps
{
   private static final String CONCAT_CHAR = "_";

   private static final String CALL_QUEUE_ITEM = "_callQueueItem";

   private static final String PRIORITY_CALL_STYLE_CLASS_NAME = "priority";

   private static final String CALL_CONDITIONAL_FLAG = "hold";

   private static final String IA_CALL_TYPE = "ia";

   private static final String ACTIVE_LIST_NAME = "activeList";

   private static final String WAITING_LIST_NAME = "waitingList";

   private static final String HOLD_LIST_NAME = "holdList";

   private static final String PRIORITY_LIST_NAME = "priorityList";

   private static final String MONITORING_LIST_NAME = "#monitoringList";

   private static final String HOLD_MENU_BUTTON_ID = "hold_call_menu_button";

   private static final String DECLINE_CALL_MENU_BUTTON_ID = "decline_call_menu_button";

   private static final String TRANSFER_MENU_BUTTON_ID = "transfer_call_menu_button";

   private static final String CONFERENCE_MENU_BUTTON_ID = "conference_call_menu_button";

   private static final String CONFERENCE_LIST_CALL_MENU_BUTTON_ID = "conference_list_call_menu_button";

   private static final Map<String, String> CALL_QUEUE_LIST_MAP = new HashMap<>();

   static
   {
      CALL_QUEUE_LIST_MAP.put( "waiting", WAITING_LIST_NAME );
      CALL_QUEUE_LIST_MAP.put( "active", ACTIVE_LIST_NAME );
      CALL_QUEUE_LIST_MAP.put( "hold", HOLD_LIST_NAME );
      CALL_QUEUE_LIST_MAP.put( "priority", PRIORITY_LIST_NAME );
      CALL_QUEUE_LIST_MAP.put( "monitoring", MONITORING_LIST_NAME );
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


   @Then("$profileName has the call queue item $callQueueItem in the $callQueueList list with $labelType label $label")
   public void verifyCallQueueItemLabelActiveList( final String profileName, final String namedCallQueueItem,
         final String callQueueList, final String labelType, final String label )
   {
      waitForSeconds( 1 );
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify call queue item status" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemLabel.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemLabel.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemLabel.IPARAM_DISPLAY_NAME, label )
            .input( VerifyCallQueueItemLabel.IPARAM_LABEL_TYPE, labelType )
            .input( VerifyCallQueueItemLabel.IPARAM_LIST_NAME, CALL_QUEUE_LIST_MAP.get( callQueueList ) ) );
   }

   @Then("$profileName verifies that the call queue item $callQueueItem from the $callQueueList list has call type $givenCallType")
   public void verifyCallQueueItemCallType( final String profileName, final String namedCallQueueItem,
         final String callQueueList, final String givenCallType )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify call queue item call type" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemCallType.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemCallType.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemCallType.IPARAM_DISPLAY_CALL_TYPE, givenCallType )
            .input( VerifyCallQueueItemCallType.IPARAM_LIST_NAME, CALL_QUEUE_LIST_MAP.get( callQueueList ) ) );
   }

   @Then("$profileName verifies that the call queue item $callQueueItem was removed from the $callQueueList list")
   public void verifyCallQueueItemList( final String profileName, final String namedCallQueueItem,
         final String callQueueList )
   {
      waitForSeconds( 1 );
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify call queue item is not in the given section " )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemNotInList.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemNotInList.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemNotInList.IPARAM_LIST_NAME, CALL_QUEUE_LIST_MAP.get( callQueueList ) ) );
   }

   @Then("$profileName verifies that the call queue item $callQueueItem has index $indexNumber in the $callQueueList list")
   public void verifyCallQueueItemOrder( final String profileName, final String namedCallQueueItem,
         final String indexNumber, final String callQueueList )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify call queue item is at index " + indexNumber + " in the call queue list." )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemIndexInList.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemIndexInList.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemIndexInList.IPARAM_CALL_QUEUE_ITEM_INDEX, indexNumber)
            .input( VerifyCallQueueItemIndexInList.IPARAM_LIST_NAME, CALL_QUEUE_LIST_MAP.get( callQueueList ) ) );
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

   @Then("$profileName click on call queue Elements list")
   public void clickCallQueueElements( final String profileName )
   {
      evaluate( remoteStep( "Click call queue elements list" )
            .scriptOn( profileScriptResolver().map( ClickCallQueueElementsList.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) ) );
   }

   @Then("$profileName answers item $itemNumber from $listType call queue list")
   @Aliases(values = { "$profileName cancels item $itemNumber from $listType call queue list",
           "$profileName terminates item $itemNumber from $listType call queue list",
           "$profileName retrives from hold item $itemNumber from $listType call queue list",
           "$profileName presses item $itemNumber from $listType call queue list" })
   public void clickCallQueueItemByPosition( final String profileName, final Integer itemNumber, final String itemType )
   {
      Integer realItemPosition = itemNumber -1;
      evaluate( remoteStep( "Click on call queue item " +itemNumber+ " from waiting list" )
              .scriptOn( profileScriptResolver().map( ClickCallQueueItemByPosition.class, BookableProfileName.javafx ),
                      assertProfile( profileName ) )
              .input(ClickCallQueueItemByPosition.IPARAM_QUEUE_ITEM_POSITION, realItemPosition.toString())
              .input(ClickCallQueueItemByPosition.IPARAM_QUEUE_ITEM_TYPE, itemType));
   }


   @Then("$profileName has in the call queue a number of $numberOfCalls calls")
   public void verifyCallQueueLength( final String profileName, final Integer numberOfCalls )
   {
      evaluate( remoteStep( "Verify call queue length" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueLength.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueLength.IPARAM_QUEUE_EXPECTED_LENGTH, numberOfCalls ) );
   }


   @Then("$profileName has in the $listName list a number of $numberOfCalls calls")
   public void verifyCallQueueSectionLength( final String profileName, final String callQueueList, final Integer numberOfCalls )
   {
      evaluate( remoteStep( "Verify call queue list length" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueSectionLength.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueSectionLength.IPARAM_QUEUE_EXPECTED_LENGTH, numberOfCalls )
            .input( VerifyCallQueueSectionLength.IPARAM_LIST_NAME, CALL_QUEUE_LIST_MAP.get( callQueueList ) ) );
   }

   @Then("$profileName has in the collapsed area a number of $numberOfCalls calls")
   public void verifyCallQueueCollapsedLength( final String profileName, final Integer numberOfCalls )
   {
      evaluate( remoteStep( "Verify call queue collapsed area length" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueCollapsedAreaLength.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueCollapsedAreaLength.IPARAM_QUEUE_EXPECTED_LENGTH, numberOfCalls ) );
   }

    @Then("$profileName has in the collapsed $listName area a number of $numberOfCalls calls")
    public void verifyCallQueueCollapsedLength( final String profileName, final String listName, final Integer numberOfCalls )
    {
        evaluate( remoteStep( "Verify call queue collapsed area length" )
                .scriptOn( profileScriptResolver().map( VerifyCallQueueCollapsedAreaSectionLength.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input(VerifyCallQueueCollapsedAreaSectionLength.IPARAM_LIST_NAME, listName)
                .input( VerifyCallQueueCollapsedAreaSectionLength.IPARAM_QUEUE_EXPECTED_LENGTH, numberOfCalls ) );
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

   @Then("$profileName has the call queue item $target in $state state")
   public void verifyTransferState(final String profileName, final String target, final String state) {
      CallQueueItem callQueueItem = getStoryListData( target, CallQueueItem.class );

      evaluate( remoteStep( "Verify operator position has the " + target +" key in " + state + " state" )
            .scriptOn(profileScriptResolver().map( VerifyCallQueueItemTransferState.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemTransferState.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemTransferState.IPARAM_KEY_STATE, state + "State" ) );
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


    @Then("$profileName verifies that call queue container $containerName is $state")
    public void verifyCallQueueContainerState( final String profileName, final String containerName, final String state )
    {
        evaluate( remoteStep( "Verify call queue container " +containerName+ " state" )
                .scriptOn( profileScriptResolver().map( VerifyCallQueueContainerVisibility.class,
                        BookableProfileName.javafx ), assertProfile( profileName ) )
                .input(VerifyCallQueueContainerVisibility.IPARAM_CONTAINER_NAME, containerName)
                .input( VerifyCallQueueContainerVisibility.IPARAM_IS_VISIBLE, state ) );
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

   @When("$profileName starts a conference using an existing active call")
   public void startsConference( final String profileName )
   {
      evaluate( remoteStep( "Starts a conference using call queue context menu" )
              .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonFirstCallQueueItem.class,
                      BookableProfileName.javafx ), assertProfile( profileName ) )
              .input( DragAndClickOnMenuButtonFirstCallQueueItem.IPARAM_MENU_BUTTON_ID, CONFERENCE_MENU_BUTTON_ID )
              .input( DragAndClickOnMenuButtonFirstCallQueueItem.IPARAM_LIST_NAME, ACTIVE_LIST_NAME ) );
   }

   @When("$profileName opens the conference participants list")
   public void opensListConference( final String profileName )
   {
      evaluate( remoteStep( "Opens conference participants list using call queue context menu" )
              .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonFirstCallQueueItem.class,
                      BookableProfileName.javafx ), assertProfile( profileName ) )
              .input( DragAndClickOnMenuButtonFirstCallQueueItem.IPARAM_MENU_BUTTON_ID, CONFERENCE_LIST_CALL_MENU_BUTTON_ID )
              .input( DragAndClickOnMenuButtonFirstCallQueueItem.IPARAM_LIST_NAME, ACTIVE_LIST_NAME ) );
   }

   @Then("$profileName verifies that hold button $exists")
   public void verifyHoldButtonExistence( final String profileName, final String exists )
   {
      Boolean isVisible = true;
      if(exists.contains("not")){
         isVisible = false;
      }
      evaluate( remoteStep( "Verify hold button existence" )
              .scriptOn( profileScriptResolver().map( VerifyMenuButtonFirstCallQueueItemIsVisible.class,
                      BookableProfileName.javafx ), assertProfile( profileName ) )
              .input( VerifyMenuButtonFirstCallQueueItemIsVisible.IPARAM_MENU_BUTTON_ID, HOLD_MENU_BUTTON_ID )
              .input( VerifyMenuButtonFirstCallQueueItemIsVisible.IPARAM_LIST_NAME, ACTIVE_LIST_NAME )
              . input(VerifyMenuButtonFirstCallQueueItemIsVisible.IPARAM_IS_VISIBLE, isVisible));
   }

   @Then("$profileName verifies that transfer button $exists")
   public void verifyTransferButtonExistence( final String profileName, final String exists )
   {
      Boolean isVisible = true;
      if(exists.contains("not")){
         isVisible = false;
      }
      evaluate( remoteStep( "Verify transfer button existence" )
              .scriptOn( profileScriptResolver().map( VerifyMenuButtonFirstCallQueueItemIsVisible.class,
                      BookableProfileName.javafx ), assertProfile( profileName ) )
              .input( VerifyMenuButtonFirstCallQueueItemIsVisible.IPARAM_MENU_BUTTON_ID, TRANSFER_MENU_BUTTON_ID )
              .input( VerifyMenuButtonFirstCallQueueItemIsVisible.IPARAM_LIST_NAME, ACTIVE_LIST_NAME )
              . input(VerifyMenuButtonFirstCallQueueItemIsVisible.IPARAM_IS_VISIBLE, isVisible));
   }

    @Then("$profileName verifies the call queue item $callQueueItem has label $type showing $label")
    public void monitoringCallQueueItem( final String profileName, final String namedCallQueueItem, final String type, final String label )
    {
        CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

        evaluate( remoteStep( "Monitoring call queue item" )
                .scriptOn( profileScriptResolver().map( VerifyMonitoringCallQueueItem.class, BookableProfileName.javafx ),
                        assertProfile( profileName ) )
                .input( VerifyMonitoringCallQueueItem.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
                .input(VerifyMonitoringCallQueueItem.IPARAM_LABEL_TYPE, type)
                .input(VerifyMonitoringCallQueueItem.IPARAM_MONITORING_LABEL, label));
    }

   @Then("$profileName cleans the call queue item $callQueueItem from the call queue list $callQueueItemList")
   public void cleanUpCallQueueItem( final String profileName, final String namedCallQueueItem, final String callQueueItemList )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Cleanup call queue item" )
              .scriptOn( profileScriptResolver().map( CleanUpCallQueue.class, BookableProfileName.javafx ),
                      assertProfile( profileName ) )
              .input( CleanUpCallQueue.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
              .input(CleanUpCallQueue.IPARAM_LIST_NAME, callQueueItemList));
   }

   private String reformatSipUris( final String sipUri )
   {
      return sipUri != null ? sipUri.replaceAll( "[.,:]", CONCAT_CHAR ) : "";
   }


   public void waitForSeconds( final double secs )
   {
      final LocalStep step = localStep( "Wait for " + secs + " seconds" );

      try
      {
         Thread.sleep( (int) secs * 1000 );
         step.details(
               ExecutionDetails.create( "Wait for " + secs + " seconds" ).received( "Waited" ).success( true ) );
      }
      catch ( final Exception ex )
      {
         step.details( ExecutionDetails.create( "Wait for " + secs + " seconds" ).received( "Waited with error" )
               .success( false ) );
      }
      record( step );
   }
}
