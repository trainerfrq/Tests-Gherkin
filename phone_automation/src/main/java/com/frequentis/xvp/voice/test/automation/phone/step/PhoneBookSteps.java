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

import scripts.cats.websocket.sequential.SendTextMessage;
import scripts.cats.websocket.sequential.buffer.ReceiveAllReceivedMessages;
import scripts.cats.websocket.sequential.buffer.ReceiveLastReceivedMessage;
import scripts.cats.websocket.sequential.buffer.SendAndReceiveTextMessage;
import static com.frequentis.c4i.test.model.MatcherDetails.match;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.instanceOf;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.isIn;
import static org.hamcrest.Matchers.notNullValue;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;
import java.util.stream.Collectors;

import org.jbehave.core.annotations.Named;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.automation.model.PhoneBookEntry;
import com.frequentis.xvp.tools.cats.websocket.automation.model.ProfileToWebSocketConfigurationReference;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.tools.cats.websocket.dto.WebsocketAutomationSteps;
import com.frequentis.xvp.voice.common.sip.SipURI;
import com.frequentis.xvp.voice.common.sip.SipUser;
import com.frequentis.xvp.voice.opvoice.json.messages.JsonMessage;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.PhoneBookRequest;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.PhoneBookResponse;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.PhoneBookResponseItem;
import com.google.common.collect.ImmutableList;

public class PhoneBookSteps extends WebsocketAutomationSteps
{

   public static final int MAX_NUMBER_OF_PHONEBOOK_ITEMS = 100000;

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


   @When("$namedWebSocket requests all entries and saves the $namedRequestId")
   public void sendPhoneBookRequestForAllEntriesWithEmptySearchPattern( final String namedWebSocket, final String namedRequestId )
   {
      sendPhoneBookRequest( namedWebSocket, MAX_NUMBER_OF_PHONEBOOK_ITEMS, 0, "", namedRequestId );
   }


   @Then("$namedWebSocket receives phone book response on buffer named $bufferName for request with $namedRequestId with entry number $entryNumber matching phone book entry $namedPhoneBookEntry")
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
            .details( match( "Entry of given number is present in response", phoneBookResponse.getItems().size(),
                  greaterThanOrEqualTo( entryNumber ) ) ) );

      assertPhoneBookEntry( phoneBookResponse.getItems().get( entryNumber - 1 ), phoneBookEntry );
   }


   @Then("$namedWebSocket receives phone book response on buffer named $bufferName for request with $namedRequestId with one entry matching phone book entry <key>")
   public void receivePhoneBookResponseCheckAllEntriesFromTable( @Named("namedWebSocket") final String namedWebSocket, @Named("bufferName") final String bufferName,
                                                                 @Named("namedRequestId") final String namedRequestId, @Named("key") final String entry )
   {
      receivePhoneBookResponseCheckAllEntries( namedWebSocket, bufferName, namedRequestId, entry );
   }

   public void receivePhoneBookResponseCheckAllEntries( final String namedWebSocket, final String bufferName,
                                                        final String namedRequestId, final String namedPhoneBookEntry )
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
                        .details( match( "Verify phone book entry is defined", phoneBookEntry, is( notNullValue() ) ) ) );

      assertPhoneBookEntryAllEntries( phoneBookResponse.getItems(), phoneBookEntry );
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
                  phoneBookResponse.getItems().size(), is( nrOfEntries ) ) ) );
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


   @When("$namedWebSocket requests the phone book entry names for role $roleIdName and saves the response $responseId")
   public void sendAndReceiveRolePhoneBookRequest( final String namedWebSocket, final String roleIdName, final String namedResponseId )
   {
      final ProfileToWebSocketConfigurationReference reference =
            getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final String roleId = getStoryListData( roleIdName, String.class );

      PhoneBookRequest phoneBookRequest = new PhoneBookRequest( new Random().nextInt(), "", 0, MAX_NUMBER_OF_PHONEBOOK_ITEMS );
      final JsonMessage request =
            JsonMessage.builder().withCorrelationId( UUID.randomUUID() ).withPhoneBookRequest( phoneBookRequest )
                  .build();

      final RemoteStepResult remoteStepResult =
            evaluate(
                  remoteStep( "Querying phone book for role " + roleId )
                        .scriptOn( profileScriptResolver().map( SendAndReceiveTextMessage.class,
                              BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                        .input( SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                        .input( SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "phoneBookResponse" )
                        .input( SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson() ) );

      final String jsonResponse =
            ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );
      List<String> phoneBookNames = new ArrayList<>(  );
      for( PhoneBookResponseItem phoneBookItem : jsonMessage.body().phoneBookResponse().getItems() )
      {
         phoneBookNames.add( phoneBookItem.getName() );
      }
      setStoryListData( namedResponseId, phoneBookNames.toString());
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


   @Then("$namedWebSocket receives call status indication on message buffer named $bufferName with $callPartyType matching phone book entry $namedPhoneBookEntry")
   public void receiveCallStatusIndicationMatchingCalledParty( final String namedWebSocket, final String bufferName,
                                                               final String callPartyType, final String namedPhoneBookEntry )
   {
      final ProfileToWebSocketConfigurationReference reference =
              getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
              evaluate(
                      remoteStep( "Receiving call incoming indication on buffer named " + bufferName )
                              .scriptOn( profileScriptResolver().map( ReceiveAllReceivedMessages.class,
                                      BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                              .input( ReceiveAllReceivedMessages.IPARAM_ENDPOINTNAME, reference.getKey() )
                              .input( ReceiveAllReceivedMessages.IPARAM_BUFFERKEY, bufferName ));

      final List<String> receivedMessagesList =
              ( List<String> ) remoteStepResult.getOutput( ReceiveAllReceivedMessages.OPARAM_RECEIVEDMESSAGES );

      PhoneBookEntry phoneBookEntry = getStoryListData( namedPhoneBookEntry, PhoneBookEntry.class );
      evaluate( localStep( "Check phone book entry" ).details(
              ExecutionDetails.create( "Verify phone book entry is defined" ).success( phoneBookEntry != null ) ) );

      final Optional<String> desiredMessage =
              receivedMessagesList.stream().map( JsonMessage::fromJson ).collect( Collectors.toList() ).stream()
                      .filter( jsonMessage -> jsonMessage.body().isCallStatusIndication() )
                      .filter( jsonMessage -> jsonMessage.body().callStatusIndication().getCallStatus()
                              .equals("out_initiated" ))
                      .filter( jsonMessage -> jsonMessage.body().callStatusIndication().getCalledParty().getUri()
                              .equals( phoneBookEntry.getUri() ) )
                      .filter( jsonMessage -> jsonMessage.body().callStatusIndication().getCalledParty().getName()
                              .equals( phoneBookEntry.getName() ) )
                      .filter( jsonMessage -> jsonMessage.body().callStatusIndication().getCalledParty().getFullName()
                              .equals( phoneBookEntry.getFullName() ) )
                      .filter( jsonMessage -> jsonMessage.body().callStatusIndication().getCalledParty().getLocation()
                              .equals( phoneBookEntry.getLocation() ) )
                      .filter( jsonMessage -> jsonMessage.body().callStatusIndication().getCalledParty().getOrganization()
                              .equals( phoneBookEntry.getOrganization() ) )
                      .filter( jsonMessage -> jsonMessage.body().callStatusIndication().getCalledParty().getNotes()
                              .equals( phoneBookEntry.getNotes() ) )
                      .findFirst().map( JsonMessage::toString );

      evaluate( localStep( "Verify if desired message was contained in buffer" )
              .details( match( "Buffer should contain desired message", desiredMessage.isPresent(), equalTo( true ) ) )
              .details( ExecutionDetails.create( "Desired message" ).usedData( "The desired message is: ",
                      desiredMessage.orElse( "Message was not found!" ) ) ) );
   }


   @When("$namedWebSocket receives call incoming indication on message buffer named $bufferName with $callPartyType matching phone book entry $namedPhoneBookEntry")
   public void receiveCallIncomingIndicationMatchingCallParty( final String namedWebSocket, final String bufferName,
                                                               final String callPartyType, final String namedPhoneBookEntry )
   {
      final ProfileToWebSocketConfigurationReference reference =
              getStoryListData( namedWebSocket, ProfileToWebSocketConfigurationReference.class );

      final RemoteStepResult remoteStepResult =
              evaluate(
                      remoteStep( "Receiving call incoming indication on buffer named " + bufferName )
                              .scriptOn( profileScriptResolver().map( ReceiveLastReceivedMessage.class,
                                      BookableProfileName.websocket ), requireProfile( reference.getProfileName() ) )
                              .input( ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey() )
                              .input( ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName )
                              .input( ReceiveLastReceivedMessage.IPARAM_DISCARDALLMESSAGES, false ) );

      final String jsonResponse =
              ( String ) remoteStepResult.getOutput( SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE );
      final JsonMessage jsonMessage = JsonMessage.fromJson( jsonResponse );

      PhoneBookEntry phoneBookEntry = getStoryListData( namedPhoneBookEntry, PhoneBookEntry.class );
      evaluate( localStep( "Check phone book entry" ).details(
              ExecutionDetails.create( "Verify phone book entry is defined" ).success( phoneBookEntry != null ) ) );

      switch ( callPartyType )
      {
         case "calledParty":
            assertCalledParty( jsonMessage, phoneBookEntry );
            break;
         case "callingParty":
            assertCallingParty( jsonMessage, phoneBookEntry );
            break;
         default:
            evaluate( localStep( "Check call party type" )
                    .details( ExecutionDetails.create( "Unknown call party type: " + callPartyType ).failure() ) );
            break;
      }
   }


   private void assertCallingParty( final JsonMessage jsonMessage, final PhoneBookEntry phoneBookEntry )
   {

      evaluate( localStep( "Verify calling party in call incoming indication" )
              .details( match( "Is call incoming indication", jsonMessage.body().isCallIncomingIndication(),
                      equalTo( true ) ) )
              .details( match( "Calling party uri matches",
                      jsonMessage.body().callIncomingIndication().getCallingParty().getUri(),
                      equalTo( phoneBookEntry.getUri() ) ) )
              .details( match( "Calling party name matches",
                      jsonMessage.body().callIncomingIndication().getCallingParty().getName(),
                      equalTo( phoneBookEntry.getName() ) ) )
              .details( match( "Calling party full name matches",
                      jsonMessage.body().callIncomingIndication().getCallingParty().getFullName(),
                      equalTo( phoneBookEntry.getFullName() ) ) )
              .details( match( "Calling party location matches",
                      jsonMessage.body().callIncomingIndication().getCallingParty().getLocation(),
                      equalTo( phoneBookEntry.getLocation() ) ) )
              .details( match( "Calling party organization matches",
                      jsonMessage.body().callIncomingIndication().getCallingParty().getOrganization(),
                      equalTo( phoneBookEntry.getOrganization() ) ) )
              .details( match( "Calling party notes match",
                      jsonMessage.body().callIncomingIndication().getCallingParty().getNotes(),
                      equalTo( phoneBookEntry.getNotes() ) ) )
      );
   }


   private void assertCalledParty( final JsonMessage jsonMessage, final PhoneBookEntry phoneBookEntry )
   {
      evaluate( localStep( "Verify called party in call incoming indication" )
              .details( match( "Is call incoming indication", jsonMessage.body().isCallIncomingIndication(),
                      equalTo( true ) ) )
              .details( match( "Called party uri matches",
                      jsonMessage.body().callIncomingIndication().getCalledParty().getUri(),
                      equalTo( phoneBookEntry.getUri() ) ) )
              .details( match( "Called party name matches",
                      jsonMessage.body().callIncomingIndication().getCalledParty().getName(),
                      equalTo( phoneBookEntry.getName() ) ) )
              .details( match( "Called party full name matches",
                      jsonMessage.body().callIncomingIndication().getCalledParty().getFullName(),
                      equalTo( phoneBookEntry.getFullName() ) ) )
              .details( match( "Called party location matches",
                      jsonMessage.body().callIncomingIndication().getCalledParty().getLocation(),
                      equalTo( phoneBookEntry.getLocation() ) ) )
              .details( match( "Called party organization matches",
                      jsonMessage.body().callIncomingIndication().getCalledParty().getOrganization(),
                      equalTo( phoneBookEntry.getOrganization() ) ) )
              .details( match( "Called party notes match",
                      jsonMessage.body().callIncomingIndication().getCalledParty().getNotes(),
                      equalTo( phoneBookEntry.getNotes() ) ) )
              .details( match( "Called party display addon matches",
                      jsonMessage.body().callIncomingIndication().getCalledParty().getDisplayAddon(),
                      equalTo( phoneBookEntry.getDisplayAddon() ) ) ) );
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
            .details( match( "Phone book entry call priority matches", phoneBookResponseItem.getCallPriority(),
                  equalTo( phoneBookEntry.getCallPriority() ) ) )
            .details( match( "Phone book entry notes matches", phoneBookResponseItem.getNotes(),
                  equalTo( phoneBookEntry.getNotes() ) ) ) );
   }


   private void assertPhoneBookEntryAllEntries(final ImmutableList<PhoneBookResponseItem> items, final PhoneBookEntry phoneBookEntry) {

      PhoneBookResponseItem entry = new PhoneBookResponseItem(phoneBookEntry.getName(), phoneBookEntry.getFullName(),phoneBookEntry.getLocation(),
                                                              phoneBookEntry.getOrganization(),phoneBookEntry.getNotes(),phoneBookEntry.getDisplayAddon(),
                                                              phoneBookEntry.getUri(), getUserPartOfURI( phoneBookEntry.getUri() ), phoneBookEntry.getCallPriority());
      evaluate( localStep( "Verify phone book entry exists in the entire phone book list" )
                        .details(match(entry,isIn(items))));
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
