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

import static com.frequentis.c4i.test.model.MatcherDetails.match;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.instanceOf;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.notNullValue;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.Random;
import java.util.UUID;

import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.automation.model.PhoneBookEntry;
import com.frequentis.xvp.tools.cats.websocket.automation.model.ProfileToWebSocketConfigurationReference;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.tools.cats.websocket.dto.WebsocketAutomationSteps;
import com.frequentis.xvp.voice.opvoice.json.messages.JsonMessage;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.PhoneBookRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.PhoneBookResponse;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.PhoneBookResponseItem;
import com.frequentis.xvp.voice.sip.SipURI;
import com.frequentis.xvp.voice.sip.SipUser;

import scripts.cats.websocket.sequential.SendTextMessage;
import scripts.cats.websocket.sequential.buffer.ReceiveLastReceivedMessage;

public class PhoneBookSteps extends WebsocketAutomationSteps
{
   @When("$namedWebSocket requests a number of $nrOfEntries entries starting from index $startIndex with the search pattern $searchPattern and saves the $namedRequestId")
   public void sendPhoneBookRequestWithSearchPattern( final String namedWebSocket, final Integer nrOfEntries,
         final Integer startIndex, final String searchPattern, final String namedRequestId )
   {
      sendPhoneBookRequest( namedWebSocket, nrOfEntries, startIndex, searchPattern, namedRequestId );
   }


   @When("$namedWebSocket requests a number of $nrOfEntries entries starting from index $startIndex with an empty search pattern and saves the $namedRequestId")
   public void sendPhoneBookRequestWithEmptySearchPattern( final String namedWebSocket, final Integer nrOfEntries,
         final Integer startIndex, final String namedRequestId )
   {
      sendPhoneBookRequest( namedWebSocket, nrOfEntries, startIndex, "", namedRequestId );
   }


   @Then("$namedWebSocket receives phone book response on buffer named $bufferName for request with $namedRequestId with entry number $entryNumber matching phone book entry $phoneBookEntry")
   public void receivePhoneBookResponseCheckEntry( final String namedWebSocket, final String bufferName,
         final String namedRequestId, final Integer entryNumber, final String namedPhoneBookEntry )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving phone book response on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName )
                        .input( ReceiveLastReceivedMessage.IPARAM_DISCARDALLMESSAGES, false ) );

      String requestId = getStoryListData( namedRequestId, String.class );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( ReceiveLastReceivedMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received phone book response" )
            .details( match( jsonMessage.body().getPayload(), instanceOf( PhoneBookResponse.class ) ) ).details( match(
                  Integer.toString( jsonMessage.body().phoneBookResponse().getRequestId() ), equalTo( requestId ) ) ) );

      PhoneBookResponse phoneBookResponse = jsonMessage.body().phoneBookResponse();
      PhoneBookEntry phoneBookEntry = getStoryListData( namedPhoneBookEntry, PhoneBookEntry.class );

      evaluate( localStep( "Check phone book entry" )
            .details( match( "Verify phone book entry is defined", phoneBookEntry, is( notNullValue() ) ) )
            .details( match( "Entry of given number is present in response", phoneBookResponse.getItems().length,
                  greaterThanOrEqualTo( entryNumber ) ) ) );

      assertPhoneBookEntry( phoneBookResponse.getItems()[entryNumber - 1], phoneBookEntry );
   }


   @Then("$namedWebSocket receives phone book response on buffer named $bufferName for request with $namedRequestId with a total number of $nrOfEntries entries")
   public void receivePhoneBookResponseCheckEntryNumber( final String namedWebSocket, final String bufferName,
         final String namedRequestId, final Integer nrOfEntries )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving phone book response on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName )
                        .input( ReceiveLastReceivedMessage.IPARAM_DISCARDALLMESSAGES, false ) );

      String requestId = getStoryListData( namedRequestId, String.class );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( ReceiveLastReceivedMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      PhoneBookResponse phoneBookResponse = jsonMessage.body().phoneBookResponse();

      evaluate( localStep( "Received phone book response" )
            .details( match( jsonMessage.body().getPayload(), instanceOf( PhoneBookResponse.class ) ) ).details( match(
                  Integer.toString( jsonMessage.body().phoneBookResponse().getRequestId() ), equalTo( requestId ) ) ) );

      evaluate(
            localStep( "Check number of entries" ).details( match( "Verify number of phone book entries in response",
                  phoneBookResponse.getItems().length, is( nrOfEntries ) ) ) );
   }


   @Then("$namedWebSocket receives phone book response on buffer named $bufferName for request with $namedRequestId with more items available flag being $moreItemsAvailable")
   public void receivePhoneBookResponseCheckMoreItemsAvailable( final String namedWebSocket, final String bufferName,
         final String namedRequestId, final Boolean moreItemsAvailable )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Receiving phone book response on buffer named " + bufferName )
                        .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName )
                        .input( ReceiveLastReceivedMessage.IPARAM_DISCARDALLMESSAGES, false ) );

      String requestId = getStoryListData( namedRequestId, String.class );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( ReceiveLastReceivedMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      evaluate( localStep( "Received phone book response" )
            .details( match( jsonMessage.body().getPayload(), instanceOf( PhoneBookResponse.class ) ) ).details( match(
                  Integer.toString( jsonMessage.body().phoneBookResponse().getRequestId() ), equalTo( requestId ) ) ) );

      PhoneBookResponse phoneBookResponse = jsonMessage.body().phoneBookResponse();

      evaluate( localStep( "Check more items available flag" ).details( match( "Verify more items are available",
            phoneBookResponse.areMoreItemsAvailable(), is( moreItemsAvailable ) ) ) );
   }


   private void sendPhoneBookRequest( final String namedWebSocket, final Integer nrOfEntries, final Integer startIndex,
         final String searchPattern, final String namedRequestId )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      PhoneBookRequest phoneBookRequest =
            new PhoneBookRequest( new Random().nextInt(), searchPattern, startIndex, nrOfEntries );

      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() ).withPhoneBookRequest( phoneBookRequest )
                  .build();

      evaluate( remoteStep( "Sending phone book request " )
            .scriptOn( profileScriptResolver().map( SendTextMessage.class, BookableProfileName.websocket ),
                  requireProfile( reference.getProfileName() ) )
            .input( SendTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
            .input( SendTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      setStoryListData( namedRequestId, Integer.toString( phoneBookRequest.getRequestId() ) );
   }


   private void assertPhoneBookEntry( final PhoneBookResponseItem phoneBookResponseItem,
         final PhoneBookEntry phoneBookEntry )
   {
      evaluate( localStep( "Verify phone book entry " )
            .details( match( "Phone book entry uri matches", phoneBookResponseItem.getDestination().getUri(),
                  equalTo( phoneBookEntry.getUri() ) ) )
            .details(
                  match( "Phone book entry display name matches", phoneBookResponseItem.getDestination().getDisplay(),
                        equalTo( getUserPartOfURI( phoneBookEntry.getUri() ) ) ) )
            .details( match( "Phone book entry full name matches", phoneBookResponseItem.getFullName(),
                  equalTo( phoneBookEntry.getFullName() ) ) )
            .details( match( "Phone book entry name matches", phoneBookResponseItem.getName(),
                  equalTo( phoneBookEntry.getName() ) ) )
            .details( match( "Phone book entry display add-on matches", phoneBookResponseItem.getDisplayAddon(),
                  equalTo( phoneBookEntry.getDisplayAddon() ) ) )
            .details( match( "Phone book entry organization matches", phoneBookResponseItem.getOrganization(),
                  equalTo( phoneBookEntry.getOrganization() ) ) )
            .details( match( "Phone book entry location matches", phoneBookResponseItem.getLocation(),
                  equalTo( phoneBookEntry.getLocation() ) ) )
            .details( match( "Phone book entry notes matches", phoneBookResponseItem.getNotes(),
                  equalTo( phoneBookEntry.getNotes() ) ) ) );
   }


   private String getUserPartOfURI( final String uri )
   {
      SipUser sipUserPart = null;
      try
      {
         final URI convertedURI = new URI( uri );
         SipURI sipURI = SipURI.fromURI( convertedURI );

         if ( sipURI.getUser().isPresent() )
         {
            sipUserPart = sipURI.getUser().get();
         }
      }
      catch ( URISyntaxException | IllegalArgumentException e )
      {
         evaluate( localStep( "Parsing SIP URI" )
               .details( ExecutionDetails.create( "Failed to parse SIP URI" ).failure() ) );
      }

      return sipUserPart != null ? sipUserPart.getUser() : null;
   }
}