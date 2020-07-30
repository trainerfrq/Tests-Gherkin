package com.frequentis.xvp.voice.test.automation.phone.step.local;

import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.xvp.voice.if73.json.messages.JsonMessage;
import com.frequentis.xvp.voice.if73.json.messages.payload.common_commands.Command;
import com.frequentis.xvp.voice.if73.json.messages.payload.common_commands.CommandResponse;
import com.frequentis.xvp.voice.if73.json.messages.payload.common_commands.CommandType;
import com.frequentis.xvp.voice.if73.json.messages.payload.common_commands.Result;
import com.frequentis.xvp.voice.if73.json.messages.payload.gg_commands.*;
import com.frequentis.xvp.voice.if73.json.utils.GsonUtils;
import com.frequentis.xvp.voice.test.automation.phone.util.ATIUtil;
import com.google.gson.Gson;
import org.jbehave.core.annotations.Aliases;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import org.jbehave.core.model.ExamplesTable;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static com.frequentis.c4i.test.model.MatcherDetails.match;
import static org.hamcrest.Matchers.*;

public class ATISteps extends ATIUtil
{

    private static final String STATUS_OK = "OK";

    @When("$hmiOperator presses (via POST request) DA key $daKeyTarget")
    public void apiDACall( final String hmiOperator, final String daKeyTarget )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - DA call" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessageRequest =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( daKeyTarget, GgCommandType.CLICK_DA )).build();

        final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final GgCommandResponse output = jsonMessage.body().getPayloadAs( GgCommandResponse.class );

        evaluate( localStep( "Verify response for executed POST request - DA call" )
                .details( match( output.getCommandType(), equalTo(GgCommandType.CLICK_DA)) )
                .details( match( output.getResult(), equalTo(GgResult.OK)))
                .details( match( output.getId(), equalTo(daKeyTarget)) )
                .details( match(output.getData(), is(nullValue())) ));
    }

    @When("$hmiOperator answers (via POST request) $type call by clicking on the queue")
    @Aliases(values = {"$hmiOperator terminates (via POST request) $type call visible on call queue",
            "$hmiOperator cancels (via POST request) $type call visible on call queue"})
    public void apiCallQueueCall( final String hmiOperator, final String type)
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - accept/terminate call on call queue" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessageRequest =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( type, GgCommandType.CLICK_CALL_QUEUE )).build();

        final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final GgCommandResponse output = jsonMessage.body().getPayloadAs( GgCommandResponse.class );

        evaluate( localStep( "Verify response for executed POST request - accept/terminate call on call queue" )
                .details( match( output.getCommandType(), equalTo(GgCommandType.CLICK_CALL_QUEUE)) )
                .details( match( output.getResult(), equalTo(GgResult.OK)))
                .details( match(output.getData(), is(nullValue())) ));
    }

    @When("HMI operators initiate calls to the following targets: $tableEntries")
    @Aliases(values = { "HMI operators cancel the following calls: $tableEntries",
            "HMI operators terminate the following calls: $tableEntries",
            "HMI operators answer the following calls: $tableEntries"})
    public void apiDACallParallel( final ExamplesTable tableEntries )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - DA call" );
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String hmiOperator = tableEntry.get("hmiOperator");
            String daKeyTarget = tableEntry.get("target");

            String endpointUri = getStoryListData(hmiOperator, String.class);

            final JsonMessage jsonMessageRequest =
                    JsonMessage.builder()
                            .withCorrelationId(UUID.randomUUID())
                            .withPayload(new GgCommand(daKeyTarget, GgCommandType.CLICK_DA)).build();

            final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

            final Gson gson = GsonUtils.getGson();
            final JsonMessage jsonMessage = gson.fromJson(responseContent, JsonMessage.class);
            final GgCommandResponse output = jsonMessage.body().getPayloadAs(GgCommandResponse.class);

            localStep("Verify response for executed POST request - DA call")
                    .details(match(output.getCommandType(), equalTo(GgCommandType.CLICK_DA)))
                    .details(match(output.getResult(), equalTo(GgResult.OK)))
                    .details(match(output.getId(), equalTo(daKeyTarget)))
                    .details(match(output.getData(), is(nullValue())));
        }
        evaluate(localStep);
    }

    @When("$hmiOperator changes (via POST request) current mission to mission $missionName")
    public void apiChangeMission( final String hmiOperator, final String missionName )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - mission change" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessageRequest =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new Command(missionName, CommandType.MISSION_CHANGE )).build();

        final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final CommandResponse output = jsonMessage.body().getPayloadAs( CommandResponse.class );

        evaluate( localStep( "Verify response for executed POST request - mission change" )
                .details( match( output.getCommandType(), equalTo(CommandType.MISSION_CHANGE)) )
                .details( match( output.getResult(), equalTo(Result.OK)))
                .details( match( output.getId(), equalTo(missionName)) ));

    }

    @When("the following operators change the current mission to mission from the table: $tableEntries")
    public void apiChangeMissionParallel( final ExamplesTable tableEntries )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - mission change" );
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String hmiOperator = tableEntry.get("hmiOperator");
            String missionName = tableEntry.get("mission");

            String endpointUri = getStoryListData(hmiOperator, String.class);

            final JsonMessage jsonMessageRequest =
                    JsonMessage.builder()
                            .withCorrelationId(UUID.randomUUID())
                            .withPayload(new Command(missionName, CommandType.MISSION_CHANGE)).build();

            final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

            final Gson gson = GsonUtils.getGson();
            final JsonMessage jsonMessage = gson.fromJson(responseContent, JsonMessage.class);
            final CommandResponse output = jsonMessage.body().getPayloadAs(CommandResponse.class);

            localStep("Verify response for executed POST request - mission change")
                    .details(match(output.getCommandType(), equalTo(CommandType.MISSION_CHANGE)))
                    .details(match(output.getResult(), equalTo(Result.OK)))
                    .details(match(output.getId(), equalTo(missionName)));
        }
        evaluate(localStep);
    }

    @Then("$hmiOperator verifies (via POST request) that the displayed mission is $missionName")
    public void apiVerifyChangeMission( final String hmiOperator, final String missionName )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify mission change" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessageRequest =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new Command(null, CommandType.MISSION_STATUS )).build();

        final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final CommandResponse output = jsonMessage.body().getPayloadAs( CommandResponse.class );

        evaluate( localStep( "Verify response for executed POST request - verify mission change" )
                .details( match( output.getCommandType(), equalTo(CommandType.MISSION_STATUS)) )
                .details( match( output.getResult(), equalTo(Result.OK)))
                .details( match( output.getId(), equalTo(missionName)) ));

    }

    @Then("verify that the following operators changed the mission successfully: $tableEntries")
    public void apiVerifyChangeMissionParallel( final ExamplesTable tableEntries )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify mission change" );
        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String hmiOperator = tableEntry.get("hmiOperator");
            String missionName = tableEntry.get("mission");

            String endpointUri = getStoryListData(hmiOperator, String.class);

            final JsonMessage jsonMessageRequest =
                    JsonMessage.builder()
                            .withCorrelationId(UUID.randomUUID())
                            .withPayload(new Command(null, CommandType.MISSION_STATUS)).build();

            final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

            final Gson gson = GsonUtils.getGson();
            final JsonMessage jsonMessage = gson.fromJson(responseContent, JsonMessage.class);
            final CommandResponse output = jsonMessage.body().getPayloadAs(CommandResponse.class);

            localStep("Verify response for executed POST request - verify mission change")
                    .details(match(output.getCommandType(), equalTo(CommandType.MISSION_STATUS)))
                    .details(match(output.getResult(), equalTo(Result.OK)))
                    .details(match(output.getId(), equalTo(missionName)));
        }
        evaluate(localStep);

    }

    @Then("$hmiOperator verify (via POST request) that DA key $daKeyTarget has status $status")
    public void apiDACallStatus( final String hmiOperator, final String daKeyTarget, final String status )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify DA call status" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessageRequest =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( daKeyTarget, GgCommandType.GET_CALL_STATUS )
                        .withCallType( GgCallType.DA ) ).build();

        final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final GgCommandResponse output = jsonMessage.body().getPayloadAs( GgCommandResponse.class );
        List<GgCallStatusElement> elements = output.getData();

        for(GgCallStatusElement element : elements){
            if(element.getType().value().contains("DA")) {
                evaluate(localStep("Verify response for executed POST request - verify DA call status")
                        .details(match(output.getCommandType(), equalTo(GgCommandType.GET_CALL_STATUS)))
                        .details(match(output.getResult(), equalTo(GgResult.OK)))
                        .details(match(output.getId(), equalTo(daKeyTarget)))
                        .details(match(receivedGGCallStatus(element, status, 2000), equalTo(status))));
            }
            break;
        }
    }

    @Then("HMI operators verify that DA keys have the expected status: $tableEntries")
    public void apiDACallStatusParallel( final ExamplesTable tableEntries )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify DA key call status" );

        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String hmiOperator = tableEntry.get("hmiOperator");
            String daKeyTarget = tableEntry.get("target");
            String status = tableEntry.get("status");

            String endpointUri = getStoryListData(hmiOperator, String.class);

            final JsonMessage jsonMessageRequest =
                    JsonMessage.builder()
                            .withCorrelationId(UUID.randomUUID())
                            .withPayload(new GgCommand(daKeyTarget, GgCommandType.GET_CALL_STATUS)
                                    .withCallType(GgCallType.DA)).build();

            final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, status);

            final Gson gson = GsonUtils.getGson();
            final JsonMessage jsonMessage = gson.fromJson(responseContent, JsonMessage.class);
            final GgCommandResponse output = jsonMessage.body().getPayloadAs(GgCommandResponse.class);
            List<GgCallStatusElement> elements = output.getData();

            for (GgCallStatusElement element : elements) {
                if (element.getType().value().contains("DA")) {
                    localStep("Verify response for executed POST request - verify DA call status")
                            .details(match(output.getCommandType(), equalTo(GgCommandType.GET_CALL_STATUS)))
                            .details(match(output.getResult(), equalTo(GgResult.OK)))
                            .details(match(output.getId(), equalTo(daKeyTarget)))
                            .details(match(receivedGGCallStatus(element, status, 2000), equalTo(status)));
                    break;
                }
            }
        }
        evaluate(localStep);
    }

    @Then("$hmiOperator verify (via POST request) that call queue has status $status")
    public void apiCallQueueStatus( final String hmiOperator, final String status )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify call queue status" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessageRequest =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( "callQueue", GgCommandType.GET_CALL_STATUS )).build();

        final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final GgCommandResponse output = jsonMessage.body().getPayloadAs( GgCommandResponse.class );
        List<GgCallStatusElement> elements = output.getData();

        for(GgCallStatusElement element : elements){
                evaluate(localStep("Verify response for executed POST request - verify call queue status")
                        .details(match(output.getCommandType(), equalTo(GgCommandType.GET_CALL_STATUS)))
                        .details(match(output.getResult(), equalTo(GgResult.OK)))
                        .details(match(output.getId(), equalTo("callQueue")))
                        .details(match(receivedGGCallStatus(element, status, 2000), equalTo(status))));
        }
    }

 @Then("$hmiOperator verifies (via POST request) that there are $nrOfCalls calls in the call queue with status: $statuses")
    public void apiCallQueueStatuses( final String hmiOperator, final Integer nrOfCalls, final List<String> statuses )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify call queue status" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessageRequest =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( "callQueue", GgCommandType.GET_CALL_STATUS )).build();

        final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final GgCommandResponse output = jsonMessage.body().getPayloadAs( GgCommandResponse.class );
        List<GgCallStatusElement> elements = output.getData();

        for(int i=0; i<nrOfCalls; i++){
            evaluate(localStep("Verify response for executed POST request - verify call queue status")
                    .details(match(output.getCommandType(), equalTo(GgCommandType.GET_CALL_STATUS)))
                    .details(match(output.getResult(), equalTo(GgResult.OK)))
                    .details(match(output.getId(), equalTo("callQueue")))
                    .details(match(receivedGGCallStatus(elements.get(i), statuses.get(i), 2000), equalTo(statuses.get(i)))));
        }
    }

@Then("$hmiOperator verify (via POST request) that call queue shows $type")
    public void apiCallQueueCallType( final String hmiOperator, final String type )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify call type" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessageRequest =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( "callQueue", GgCommandType.GET_CALL_STATUS )).build();

        final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final GgCommandResponse output = jsonMessage.body().getPayloadAs( GgCommandResponse.class );
        List<GgCallStatusElement> elements = output.getData();

        for(GgCallStatusElement element : elements){
            evaluate(localStep("Verify response for executed POST request - verify call queue status")
                    .details(match(output.getCommandType(), equalTo(GgCommandType.GET_CALL_STATUS)))
                    .details(match(output.getResult(), equalTo(GgResult.OK)))
                    .details(match(output.getId(), equalTo("callQueue")))
                    .details(match(element.getId(), equalTo(type))));
        }
    }

    @Then("HMI operators verify that they have no calls in the call queue: $tableEntries")
    public void apiCallQueueStatusTerminatedParallel( final ExamplesTable tableEntries )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify call queue status terminated" );

        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String hmiOperator = tableEntry.get("hmiOperator");

            String endpointUri = getStoryListData(hmiOperator, String.class);

            final JsonMessage jsonMessageRequest =
                    JsonMessage.builder()
                            .withCorrelationId(UUID.randomUUID())
                            .withPayload(new GgCommand("callQueue", GgCommandType.GET_CALL_STATUS)).build();

            final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

            final Gson gson = GsonUtils.getGson();
            final JsonMessage jsonMessage = gson.fromJson(responseContent, JsonMessage.class);
            final GgCommandResponse output = jsonMessage.body().getPayloadAs(GgCommandResponse.class);
            List<GgCallStatusElement> elements = output.getData();

            for (GgCallStatusElement element : elements) {
                localStep("Verify response for executed POST request - verify call queue status")
                        .details(match(output.getCommandType(), equalTo(GgCommandType.GET_CALL_STATUS)))
                        .details(match(output.getResult(), equalTo(GgResult.OK)))
                        .details(match(output.getId(), equalTo("callQueue")))
                        .details(match(output.getData(), equalTo(null)));
            }
        }
        evaluate(localStep);
    }

    @Then("HMI operators verify that call queues have the expected status: $tableEntries")
    public void apiCallQueueStatusParallel( final ExamplesTable tableEntries )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify call queue status" );

        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String hmiOperator = tableEntry.get("hmiOperator");
            String status = tableEntry.get("status");

            String endpointUri = getStoryListData(hmiOperator, String.class);

            final JsonMessage jsonMessageRequest =
                    JsonMessage.builder()
                            .withCorrelationId(UUID.randomUUID())
                            .withPayload(new GgCommand("callQueue", GgCommandType.GET_CALL_STATUS)).build();
            
            final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, status);
            
            final Gson gson = GsonUtils.getGson();
            final JsonMessage jsonMessage = gson.fromJson(responseContent, JsonMessage.class);
            final GgCommandResponse output = jsonMessage.body().getPayloadAs(GgCommandResponse.class);
            List<GgCallStatusElement> elements = output.getData();

            for (GgCallStatusElement element : elements) {
                localStep("Verify response for executed POST request - verify call queue status")
                        .details(match(output.getCommandType(), equalTo(GgCommandType.GET_CALL_STATUS)))
                        .details(match(output.getResult(), equalTo(GgResult.OK)))
                        .details(match(output.getId(), equalTo("callQueue")))
                        .details(match(receivedGGCallStatus(element, status, 2000), equalTo(status)));
            }
        }
        evaluate(localStep);
    }

    @When("$hmiOperator start (via POST request) a call from phone book to $target")
    public void apiPhonebookCall( final String hmiOperator, final String target )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - phone book call" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessageRequest =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( target, GgCommandType.PHONEBOOK_CALL )).build();

        final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final GgCommandResponse output = jsonMessage.body().getPayloadAs( GgCommandResponse.class );

        evaluate( localStep( "Verify response for executed POST request - phone book call" )
                .details( match( output.getCommandType(), equalTo(GgCommandType.PHONEBOOK_CALL)) )
                .details( match( output.getResult(), equalTo(GgResult.OK)))
                .details( match( output.getId(), equalTo(target)) )
                .details( match(output.getData(), is(nullValue())) ));
    }

    @When("HMI operators start a call from phone book to: $tableEntries")
    public void apiPhonebookCallParallel( final ExamplesTable tableEntries )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - phone book call" );

        for (Map<String, String> tableEntry : tableEntries.getRows()) {
            String hmiOperator = tableEntry.get("hmiOperator");
            String target = tableEntry.get("target");

            String endpointUri = getStoryListData(hmiOperator, String.class);

            final JsonMessage jsonMessageRequest =
                    JsonMessage.builder()
                            .withCorrelationId(UUID.randomUUID())
                            .withPayload(new GgCommand(target, GgCommandType.PHONEBOOK_CALL)).build();

            final String responseContent = getResponseWithStatus(endpointUri, jsonMessageRequest, STATUS_OK);

            final Gson gson = GsonUtils.getGson();
            final JsonMessage jsonMessage = gson.fromJson(responseContent, JsonMessage.class);
            final GgCommandResponse output = jsonMessage.body().getPayloadAs(GgCommandResponse.class);

            localStep("Verify response for executed POST request - phone book call")
                    .details(match(output.getCommandType(), equalTo(GgCommandType.PHONEBOOK_CALL)))
                    .details(match(output.getResult(), equalTo(GgResult.OK)))
                    .details(match(output.getId(), equalTo(target)))
                    .details(match(output.getData(), is(nullValue())));
        }
        evaluate(localStep);
    }
}
