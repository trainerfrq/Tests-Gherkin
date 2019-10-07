package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.fluent.step.remote.RemoteStepResult;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.websocket.automation.model.ProfileToWebSocketConfigurationReference;
import com.frequentis.xvp.tools.cats.websocket.dto.BookableProfileName;
import com.frequentis.xvp.tools.cats.websocket.dto.WebsocketAutomationSteps;
import com.frequentis.xvp.voice.opvoice.json.messages.JsonMessage;
import com.frequentis.xvp.voice.opvoice.json.messages.payload.phone.*;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.websocket.sequential.SendTextMessage;
import scripts.cats.websocket.sequential.buffer.ReceiveAllReceivedMessages;
import scripts.cats.websocket.sequential.buffer.ReceiveLastReceivedMessage;
import scripts.cats.websocket.sequential.buffer.SendAndReceiveTextMessage;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static com.frequentis.c4i.test.model.MatcherDetails.match;
import static org.hamcrest.Matchers.equalTo;

public class ConferenceSteps extends WebsocketAutomationSteps {

    @When("$namedWebSocket establishes a conference call using callId $phoneCallIdName")
    public void establishP2PConferenceCall(final String namedWebSocket, final String phoneCallIdName) {
        establishConferenceCall(namedWebSocket, phoneCallIdName);
    }


    @Then("$namedWebSocket receives call status indication on message buffer named $bufferName with callId $phoneCallIdName and status $callStatus")
    public void receiveCallStatusIndication(final String namedWebSocket, final String bufferName,
                                            final String phoneCallIdName, final String callStatus) {
        receiveCallStatusIndication(namedWebSocket, bufferName, phoneCallIdName, callStatus, null);
    }


    @Then("$namedWebSocket receives call incoming indication on message buffer named $bufferName with the flag $flagName and names $confCallIdName")
    public void partyOperatorReceivesCallIncomingIndicationForConference(final String namedWebSocket, final String bufferName, final String flagName, final String callIdName) {
        partyOpReceivesCallIncomingIndicationForConference(namedWebSocket, bufferName, flagName, callIdName);
    }

    @Then("$namedWebSocket confirms incoming phone call with callId $phoneCallIdName")
    public void partyOperatorConfirmsIncomingCallForConference(final String namedWebSocket, final String phoneCallIdName) {
        partyOpConfirmsIncomingCallForConference(namedWebSocket, phoneCallIdName);
    }


    @When("$namedWebSocket receives conference status indication with status $confStatus and type $confType on buffer named $bufferName and names $confCallIdName")
    public void checkConferenceStatusAndConferenceType(final String namedWebSocket, final String confStatus, final String confType, final String bufferName, final String conferenceCallId) {
        verifyConferenceStatusAndConferenceType(namedWebSocket, confStatus, confType, bufferName, conferenceCallId);
    }


    @When("$namedWebSocket receives conference status indication with $confCallIdName , callingParty $callingPartyName , calledParty $calledPartyName and state $calledPartyState on message buffer named $bufferName")
    public void checkConferenceCallingAndCalledParties(final String namedWebSocket, final String conferenceCallId, final String callingPartyName, final String calledPartyName, final String calledPartyState, final String bufferName) {
        checkConferenceParties(namedWebSocket, conferenceCallId, callingPartyName, calledPartyName, calledPartyState, bufferName);
    }


    @When("$namedWebSocket receives conference status indication with $confCallId1 and callingParty $callingPartyName , calledParty $calledPartyName on message buffer named $bufferName with status $partiesStatus for both parties")
    public void checkPartiesAreConnected(final String namedWebSocket, final String conferenceCallId, final String callingPartyName, final String calledPartyName, final String bufferName, final String partiesStatus) {
        verifyPartiesAreConnectedSuccesfully(namedWebSocket, conferenceCallId, callingPartyName, calledPartyName, bufferName, partiesStatus);
    }


    @When("$namedWebSocket establish a conference add party request to conference $confCallIdName with callingParty $callSourceName and calledParty $calledTargetName")
    public void establishConferenceAddPartyRequest(final String namedWebSocket, final String confCallIdName, final String callSourceName, final String callTargetName) {
        addPartyToConference(namedWebSocket, confCallIdName, callSourceName, callTargetName, "none");
    }


    @Then("$namedWebSocket receives conference add party response on message buffer named $bufferName with $callSourceName and $calledTargetName and result $resultName")
    public void receiveConferenceAddPartyResponse(final String namedWebSocket, final String bufferName, final String callSourceName, final String callTargetName, final String resultName) {
        receiveConfAddPartyResponse(namedWebSocket, bufferName, callSourceName, callTargetName, resultName);
    }


    @Then("$namedWebSocket receives conference status indication messages with status $statusType for all the participants on buffer named $bufferName")
    public void receiveConferenceStatusIndication(final String namedWebSocket, final String statusType, final String bufferName) {
        receiveConfStatusIndication(namedWebSocket, statusType, bufferName);
    }


    @Then("$namedWebSocket accepts the incoming phone call with callId $phoneCallIdName")
    public void acceptPhoneCallId(final String namedWebSocket, final String phoneCallIdName) {
        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final JsonMessage request =
                JsonMessage.builder().withCorrelationId(UUID.randomUUID())
                        .withPayload(new CallAcceptRequest(getStoryListData(phoneCallIdName, String.class))).build();

        evaluate(remoteStep("Confirming incoming phone call")
                .scriptOn(profileScriptResolver().map(SendTextMessage.class, BookableProfileName.websocket),
                        requireProfile(reference.getProfileName()))
                .input(SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey())
                .input(SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson()));
    }

    @Then("$namedWebSocket receives conference status indication message with conference status $conferenceStatus on buffer named $bufferName")
    public void receiveConfStatusIndicationAfterFirstAndThirdPartiesLeft(final String namedWebSocket, final String confStatus, final String bufferName) {

        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep("Receive conf status indication on buffer name " + bufferName)
                                .scriptOn(profileScriptResolver().map(ReceiveLastReceivedMessage.class,
                                        BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                .input(ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey())
                                .input(ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName));

        final String jsonResponse =
                (String) remoteStepResult.getOutput(ReceiveLastReceivedMessage.OPARAM_RECEIVEDMESSAGE);
        final JsonMessage jsonMessage = JsonMessage.fromJson(jsonResponse);


        evaluate(localStep("Verifying the conference status after first and third parties left")
                .details(match("Conference status matches", jsonMessage.body().confStatusIndication().getConfStatus(),
                        equalTo(confStatus))));
    }


    private void establishConferenceCall(final String namedWebSocket, final String phoneCallIdName) {
        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final String callId = getStoryListData(phoneCallIdName, String.class);

        final Integer transactionId = new Integer(1234);

        final ConfEstablishRequest conEstablishRequest = new ConfEstablishRequest(transactionId, callId);
        final JsonMessage request =
                new JsonMessage.Builder().withCorrelationId(UUID.randomUUID()).withPayload(conEstablishRequest).build();

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep("Establishing conf request to " + callId)
                                .scriptOn(profileScriptResolver().map(SendAndReceiveTextMessage.class,
                                        BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                .input(SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey())
                                .input(SendAndReceiveTextMessage.IPARAM_RESPONSETYPE, "confEstablishResponse")
                                .input(SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson()));

        final String jsonResponse =
                (String) remoteStepResult.getOutput(SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE);
    }


    private void receiveCallStatusIndication(final String namedWebSocket, final String bufferName,
                                             final String phoneCallIdName, final String callStatus, final String callConditionalFlag) {
        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep("Receiving call status indication on buffer named " + bufferName)
                                .scriptOn(profileScriptResolver().map(ReceiveLastReceivedMessage.class,
                                        BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                .input(ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey())
                                .input(ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName));

        final String jsonResponse =
                (String) remoteStepResult.getOutput(SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE);
        final JsonMessage jsonMessage = JsonMessage.fromJson(jsonResponse);

        evaluate(localStep("Verify call status indication")
                .details(
                        match("Is call status indication", jsonMessage.body().isCallStatusIndication(), equalTo(true)))
                .details(match("Phone call id matches", jsonMessage.body().callStatusIndication().getCallId(),
                        equalTo(getStoryListData(phoneCallIdName, String.class))))
                .details(match("Call status does not match", jsonMessage.body().callStatusIndication().getCallStatus(),
                        equalTo(callStatus)))
                .details(match("Call conditional flag does not match",
                        jsonMessage.body().callStatusIndication().getCallConditionalFlag(),
                        equalTo(callConditionalFlag))));
    }


    private void partyOpReceivesCallIncomingIndicationForConference(String namedWebSocket, String bufferName, String flagName, String callIdName) {
        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep("Receiving call incoming indication on buffer named " + bufferName)
                                .scriptOn(profileScriptResolver().map(ReceiveLastReceivedMessage.class,
                                        BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                .input(ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey())
                                .input(ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName));

        final String jsonResponse =
                (String) remoteStepResult.getOutput(ReceiveLastReceivedMessage.OPARAM_RECEIVEDMESSAGE);
        final JsonMessage jsonMessage = JsonMessage.fromJson(jsonResponse);

        evaluate(localStep("Verify call incoming indication")
                .details(match("Is call incoming indication", jsonMessage.body().isCallIncomingIndication(),
                        equalTo(true)))
                .details(match("Call flag matches", jsonMessage.body().callIncomingIndication().getCallConditionalFlag(),
                        equalTo(flagName))));

        setStoryListData(callIdName, jsonMessage.body().callIncomingIndication().getCallId());
    }


    private void partyOpConfirmsIncomingCallForConference(String namedWebSocket, String phoneCallIdName) {
        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final JsonMessage request =
                JsonMessage.builder().withCorrelationId(UUID.randomUUID())
                        .withPayload(new CallIncomingConfirmation(getStoryListData(phoneCallIdName, String.class))).build();

        evaluate(remoteStep("Confirming incoming phone call")
                .scriptOn(profileScriptResolver().map(SendTextMessage.class, BookableProfileName.websocket),
                        requireProfile(reference.getProfileName()))
                .input(SendAndReceiveTextMessage.IPARAM_ENDPOINTNAME, reference.getKey())
                .input(SendAndReceiveTextMessage.IPARAM_MESSAGETOSEND, request.toJson()));
    }


    private void verifyConferenceStatusAndConferenceType(final String namedWebSocket, final String conferenceStatus, final String conferenceType, final String bufferName, final String conferenceCallId) {

        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep("Checking if all conference status indication messages are received on buffer name " + bufferName)
                                .scriptOn(profileScriptResolver().map(ReceiveAllReceivedMessages.class,
                                        BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                .input(ReceiveAllReceivedMessages.IPARAM_ENDPOINTNAME, reference.getKey())
                                .input(ReceiveAllReceivedMessages.IPARAM_BUFFERKEY, bufferName));

        final List<String> receivedMessagesList =
                (List<String>) remoteStepResult.getOutput(ReceiveAllReceivedMessages.OPARAM_RECEIVEDMESSAGES);

        Optional<String> desiredMessage;

        if (!receivedMessagesList.isEmpty()) {
            desiredMessage = Optional.of(receivedMessagesList.get(0));
        } else {
            desiredMessage = Optional.empty();
        }

        final JsonMessage jsonMessage = JsonMessage.fromJson(receivedMessagesList.get(0));

        evaluate(localStep("Verifying the conference status and conference type in first received message")
                .details(match("Buffer should contain desired message", desiredMessage.isPresent(), equalTo(true)))
                .details(match("Conference status matches", jsonMessage.body().confStatusIndication().getConfStatus(),
                        equalTo(conferenceStatus)))
                .details(match("Conference type matches ", jsonMessage.body().confStatusIndication().getConfType(),
                        equalTo(conferenceType)))
                .details(ExecutionDetails.create("Desired message").usedData("The desired message is: ",
                        desiredMessage.orElse("Message was not found!"))));

        setStoryListData(conferenceCallId, jsonMessage.body().confStatusIndication().getConfCallId());
    }


    private void checkConferenceParties(final String namedWebSocket, final String conferenceCallId, final String callingPartyName, final String calledPartyName, final String calledPartyState, final String bufferName) {
        Optional<String> desiredMessage;

        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep("Checking if all conference status indication messages are received on buffer name " + bufferName)
                                .scriptOn(profileScriptResolver().map(ReceiveAllReceivedMessages.class,
                                        BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                .input(ReceiveAllReceivedMessages.IPARAM_ENDPOINTNAME, reference.getKey())
                                .input(ReceiveAllReceivedMessages.IPARAM_BUFFERKEY, bufferName));

        final List<String> receivedMessagesList =
                (List<String>) remoteStepResult.getOutput(ReceiveAllReceivedMessages.OPARAM_RECEIVEDMESSAGES);

        if (!receivedMessagesList.isEmpty()) {
            desiredMessage = Optional.of(receivedMessagesList.get(1));
        } else {
            desiredMessage = Optional.empty();
        }

        final JsonMessage jsonMessage = JsonMessage.fromJson(receivedMessagesList.get(1));
        List<ConfParticipant> confParticipants = jsonMessage.body().confStatusIndication().getConfParticipants();

        evaluate(localStep("Verifying the conference parties and conference status in second received message")
                .details(match("Conference call ID matches", jsonMessage.body().confStatusIndication().getConfCallId(),
                        equalTo(getStoryListData(conferenceCallId, String.class))))
                .details(match("Calling party matches", confParticipants.get(0).getCallingParty(),
                        equalTo((getStoryListData(callingPartyName, String.class)) + ":5060")))
                .details(match("Called party matches", confParticipants.get(0).getCalledParty(),
                        equalTo((getStoryListData(calledPartyName, String.class)) + ":5060")))
                .details(match("Called party state matches", confParticipants.get(0).getState(),
                        equalTo(calledPartyState)))
                .details(ExecutionDetails.create("Desired message").usedData("The desired message is: ",
                        desiredMessage.orElse("Message was not found!"))));

    }


    private void verifyPartiesAreConnectedSuccesfully(String namedWebSocket, String conferenceCallId, String callingPartyName, String calledPartyName, String bufferName, String partiesState) {
        Optional<String> desiredMessage;

        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep("Checking if all conference status indication messages are received on buffer name " + bufferName)
                                .scriptOn(profileScriptResolver().map(ReceiveAllReceivedMessages.class,
                                        BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                .input(ReceiveAllReceivedMessages.IPARAM_ENDPOINTNAME, reference.getKey())
                                .input(ReceiveAllReceivedMessages.IPARAM_BUFFERKEY, bufferName));

        final List<String> receivedMessagesList =
                (List<String>) remoteStepResult.getOutput(ReceiveAllReceivedMessages.OPARAM_RECEIVEDMESSAGES);


        if (!receivedMessagesList.isEmpty()) {
            desiredMessage = Optional.of(receivedMessagesList.get(3));
        } else {
            desiredMessage = Optional.empty();
        }

        final JsonMessage jsonMessage = JsonMessage.fromJson(receivedMessagesList.get(3));

        List<ConfParticipant> confParticipants = jsonMessage.body().confStatusIndication().getConfParticipants();

        evaluate(localStep("Verifying the conference parties and conference status in third received message")
                .details(match("Conference call ID matches", jsonMessage.body().confStatusIndication().getConfCallId(),
                        equalTo(getStoryListData(conferenceCallId, String.class))))
                .details(match("Calling party matches", confParticipants.get(0).getCallingParty(),
                        equalTo((getStoryListData(callingPartyName, String.class)) + ":5060")))
                .details(match("Called party matches", confParticipants.get(0).getCalledParty(),
                        equalTo((getStoryListData(calledPartyName, String.class)) + ":5060")))
                .details(match("Calling party state matches", confParticipants.get(0).getState(),
                        equalTo(partiesState)))
                .details(match("Called party state matches", confParticipants.get(1).getState(),
                        equalTo(partiesState)))
                .details(ExecutionDetails.create("Desired message").usedData("The desired message is: ",
                        desiredMessage.orElse("Message was not found!"))));
    }


    private void addPartyToConference(String namedWebSocket, String confCallIdName, String callSourceName, String callTargetName, String confPartyRouteSelectorId) {
        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final String confCallId = getStoryListData(confCallIdName, String.class);
        final String confInitiator = getStoryListData(callSourceName, String.class);


        final Integer transactionId = new Integer(1234);

        final ConfAddPartyRequest confAddPartyRequest = new ConfAddPartyRequest(transactionId, confCallId, confInitiator, callTargetName, confPartyRouteSelectorId);

        final JsonMessage request =
                new JsonMessage.Builder().withCorrelationId(UUID.randomUUID()).withPayload(confAddPartyRequest).build();

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep("Establishing conference add party request to conference" + confCallId)
                                .scriptOn(profileScriptResolver().map(SendTextMessage.class,
                                        BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                .input(SendTextMessage.IPARAM_ENDPOINTNAME, reference.getKey())
                                .input(SendTextMessage.IPARAM_MESSAGETOSEND, request.toJson()));
    }


    private void receiveConfAddPartyResponse(final String namedWebSocket, final String bufferName, final String callingPartyName, final String calledPartyName, final String resultName) {

        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep("Receiving conference add party response on buffer named " + bufferName)
                                .scriptOn(profileScriptResolver().map(ReceiveLastReceivedMessage.class,
                                        BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                .input(ReceiveLastReceivedMessage.IPARAM_ENDPOINTNAME, reference.getKey())
                                .input(ReceiveLastReceivedMessage.IPARAM_BUFFERKEY, bufferName));

        final String jsonResponse =
                (String) remoteStepResult.getOutput(SendAndReceiveTextMessage.OPARAM_RECEIVEDMESSAGE);
        final JsonMessage jsonMessage = JsonMessage.fromJson(jsonResponse);

        evaluate(localStep("Verifying conference added party and conference result")
                .details(match("Calling party matches", jsonMessage.body().confAddPartyResponse().getCallingParty().getUri(),
                        equalTo((getStoryListData(callingPartyName, String.class)) + ":5060")))
                .details(match("Called party matches", jsonMessage.body().confAddPartyResponse().getCalledParty().getUri(),
                        equalTo((getStoryListData(calledPartyName, String.class)) + ":5060")))
                .details(match("Conf add party result matches", jsonMessage.body().confAddPartyResponse().getResult(),
                        equalTo(resultName))));
    }


    private void receiveConfStatusIndication(String namedWebSocket, String stateType, String bufferName) {
        Optional<String> desiredMessage;
        final ProfileToWebSocketConfigurationReference reference =
                getStoryListData(namedWebSocket, ProfileToWebSocketConfigurationReference.class);

        final RemoteStepResult remoteStepResult =
                evaluate(
                        remoteStep("Receive conf status indication on buffer name " + bufferName)
                                .scriptOn(profileScriptResolver().map(ReceiveAllReceivedMessages.class,
                                        BookableProfileName.websocket), requireProfile(reference.getProfileName()))
                                .input(ReceiveAllReceivedMessages.IPARAM_ENDPOINTNAME, reference.getKey())
                                .input(ReceiveAllReceivedMessages.IPARAM_BUFFERKEY, bufferName));

        final List<String> receivedMessagesList =
                (List<String>) remoteStepResult.getOutput(ReceiveAllReceivedMessages.OPARAM_RECEIVEDMESSAGES);


        if (!receivedMessagesList.isEmpty()) {
            desiredMessage = Optional.of(receivedMessagesList.get(5));
        } else {
            desiredMessage = Optional.empty();
        }

        final JsonMessage jsonMessage = JsonMessage.fromJson(receivedMessagesList.get(5));
        List<ConfParticipant> confParticipants = jsonMessage.body().confStatusIndication().getConfParticipants();

        evaluate(localStep("Verifying the conference status off all parties")
                .details(match("First party state matches", confParticipants.get(0).getState(),
                        equalTo(stateType)))
                .details(match("Second party state matches", confParticipants.get(1).getState(),
                        equalTo(stateType)))
                .details(match("Third party state matches", confParticipants.get(2).getState(),
                        equalTo(stateType)))
                .details(ExecutionDetails.create("Desired message").usedData("The desired message is: ",
                        desiredMessage.orElse("Message was not found!"))));
    }
}
