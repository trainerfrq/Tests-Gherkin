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

import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.voice.test.automation.phone.data.CallQueueItem;
import com.frequentis.xvp.voice.test.automation.phone.data.DAKey;

import scripts.cats.hmi.ClickDAButton;
import scripts.cats.hmi.DragAndClickOnMenuButtonActiveList;
import scripts.cats.hmi.DragAndClickOnMenuButtonDAKey;
import scripts.cats.hmi.VerifyCallQueueItemPriority;
import scripts.cats.hmi.VerifyCallQueueItemState;
import scripts.cats.hmi.VerifyCallQueueLength;
import scripts.cats.hmi.VerifyDAButtonState;

public class UISteps extends AutomationSteps
{

   public static final String CONCAT_CHAR = "_";

   public static final String CALL_QUEUE_ITEM = "_callQueueItem";

   public static final String HOLD_MENU_BUTTON_ID = "hold_menu_button";

   public static final String PRIORITY_CALL_MENU_BUTTON_ID = "#priority_call_menu_button";


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
   public void clickDA( final String profileName, final String target )
   {
      DAKey daKey = retrieveDaKey( profileName, target );

      evaluate( remoteStep( "Check application status" )
            .scriptOn( profileScriptResolver().map( ClickDAButton.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( ClickDAButton.IPARAM_DA_KEY_ID, daKey.getId() ) );
   }


   @Then("$profileName has the DA key $target in state $state")
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
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemPriority.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemPriority.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() ) );
   }


   @Then("$profileName has the call queue item $callQueueItem in state $state")
   public void verifyPriorityCallQueueItem( final String profileName, final String namedCallQueueItem,
         final String state )
   {
      CallQueueItem callQueueItem = getStoryListData( namedCallQueueItem, CallQueueItem.class );

      evaluate( remoteStep( "Verify call queue item status" )
            .scriptOn( profileScriptResolver().map( VerifyCallQueueItemState.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( VerifyCallQueueItemState.IPARAM_CALL_QUEUE_ITEM_ID, callQueueItem.getId() )
            .input( VerifyCallQueueItemState.IPARAM_CALL_QUEUE_ITEM_STATE, state ) );
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
      evaluate(
            remoteStep( "Put on hold active call" )
                  .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonActiveList.class,
                        BookableProfileName.javafx ), assertProfile( profileName ) )
                  .input( DragAndClickOnMenuButtonActiveList.IPARAM_MENU_BUTTON_ID, HOLD_MENU_BUTTON_ID ) );
   }


   @When("$profileName initiates a priority call on DA key $target")
   public void initiatePriorityCall( final String profileName, final String target )
   {
      DAKey daKey = retrieveDaKey( profileName, target );

      evaluate( remoteStep( "Initiate priority call" )
            .scriptOn( profileScriptResolver().map( DragAndClickOnMenuButtonDAKey.class, BookableProfileName.javafx ),
                  assertProfile( profileName ) )
            .input( DragAndClickOnMenuButtonDAKey.IPARAM_DA_KEY_ID, daKey.getId() )
            .input( DragAndClickOnMenuButtonDAKey.IPARAM_MENU_BUTTON_ID, PRIORITY_CALL_MENU_BUTTON_ID ) );
   }


   private DAKey retrieveDaKey( final String source, final String target )
   {
      final DAKey daKey = getStoryListData( source + "-" + target, DAKey.class );
      evaluate( localStep( "Check DA key" ).details( ExecutionDetails.create( "Verify DA key is defined" )
            .usedData( "source", source ).usedData( "target", target ).success( daKey != null ) ) );
      return daKey;
   }


   private String reformatSipUris( final String sipUri )
   {
      return sipUri.replaceAll( "[.,:]", CONCAT_CHAR );
   }
}
