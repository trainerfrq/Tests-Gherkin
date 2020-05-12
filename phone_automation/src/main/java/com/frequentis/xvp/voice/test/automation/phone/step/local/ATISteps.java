package com.frequentis.xvp.voice.test.automation.phone.step.local;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.voice.if73.json.messages.JsonMessage;
import com.frequentis.xvp.voice.if73.json.messages.payload.common_commands.Command;
import com.frequentis.xvp.voice.if73.json.messages.payload.common_commands.CommandResponse;
import com.frequentis.xvp.voice.if73.json.messages.payload.common_commands.CommandType;
import com.frequentis.xvp.voice.if73.json.messages.payload.common_commands.Result;
import com.frequentis.xvp.voice.if73.json.messages.payload.gg_commands.*;
import com.frequentis.xvp.voice.if73.json.utils.GsonUtils;
import com.google.gson.Gson;
import org.glassfish.jersey.client.JerseyClientBuilder;
import org.glassfish.jersey.client.JerseyWebTarget;
import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import javax.ws.rs.client.Entity;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;
import java.util.UUID;

import static com.frequentis.c4i.test.model.MatcherDetails.match;
import static org.hamcrest.Matchers.*;

public class ATISteps extends AutomationSteps
{
    @When("$hmiOperator presses (via POST request) DA key $target")
    public void apiDACall( final String hmiOperator, final String target )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - DA call" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessage =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( target, GgCommandType.CLICK_DA )
                        .withCallType( GgCallType.DA ) ).build();

            Response response =
                    getATIWebTarget( endpointUri )
                            .request( MediaType.APPLICATION_JSON )
                            .post( Entity.json( jsonMessage.toString() ) );

        final GgCommandResponse output = getGgResponseContent(response);

        evaluate( localStep( "Verify response for executed POST request - DA call" )
                .details( match( output.getCommandType(), equalTo(GgCommandType.CLICK_DA)) )
                .details( match( output.getResult(), equalTo(GgResult.OK)))
                .details( match( output.getId(), equalTo(target)) )
                .details( match(output.getData(), is(nullValue())) ));
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

        Response response =
                getATIWebTarget( endpointUri )
                        .request( MediaType.APPLICATION_JSON )
                        .post( Entity.json( jsonMessageRequest.toJson() ) );

        final CommandResponse output = getResponseContent(response);

        evaluate( localStep( "Verify response for executed POST request - mission change" )
                .details( match( output.getCommandType(), equalTo(CommandType.MISSION_CHANGE)) )
                .details( match( output.getResult(), equalTo(Result.OK)))
                .details( match( output.getId(), equalTo(missionName)) ));

    }

    @Then("$hmiOperator verifies (via POST request) change mission $missionName was successfully")
    public void apiVerifyChangeMission( final String hmiOperator, final String missionName )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify mission change" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessageRequest =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new Command(null, CommandType.MISSION_STATUS )).build();

        Response response =
                getATIWebTarget( endpointUri )
                        .request( MediaType.APPLICATION_JSON )
                        .post( Entity.json( jsonMessageRequest.toJson() ) );

        final CommandResponse output = getResponseContent(response);

        evaluate( localStep( "Verify response for executed POST request - verify mission change" )
                .details( match( output.getCommandType(), equalTo(CommandType.MISSION_STATUS)) )
                .details( match( output.getResult(), equalTo(Result.OK)))
                .details( match( output.getId(), equalTo(missionName)) ));

    }

    @Then("$hmiOperator verify (via POST request) that DA key $target has status $status")
    public void apiDACallStatus( final String hmiOperator, final String target, final String status )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify DA call status" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessage =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( target, GgCommandType.GET_CALL_STATUS )
                        .withCallType( GgCallType.DA ) ).build();

        Response response =
                getATIWebTarget( endpointUri )
                        .request( MediaType.APPLICATION_JSON )
                        .post( Entity.json( jsonMessage.toString() ) );

        final GgCommandResponse output = getGgResponseContent(response);
        List<GgCallStatusElement> elements = output.getData();

        for(GgCallStatusElement element : elements){
            if(element.getId().contains(target)) {
                evaluate(localStep("Verify response for executed POST request - verify DA call status")
                        .details(match(output.getCommandType(), equalTo(GgCommandType.GET_CALL_STATUS)))
                        .details(match(output.getResult(), equalTo(GgResult.OK)))
                        .details(match(output.getId(), equalTo(target)))
                        .details(match(element.getStatus().toString(), equalTo(status))));
            }
            break;
        }
    }

    @Then("$hmiOperator verify (via POST request) that call queue has status $status")
    public void apiCallQueueStatus( final String hmiOperator, final String status )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - verify call queue status" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessage =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( "callQueue", GgCommandType.GET_CALL_STATUS )).build();

        Response response =
                getATIWebTarget( endpointUri )
                        .request( MediaType.APPLICATION_JSON )
                        .post( Entity.json( jsonMessage.toString() ) );

        final GgCommandResponse output = getGgResponseContent(response);
        List<GgCallStatusElement> elements = output.getData();

        for(GgCallStatusElement element : elements){
                evaluate(localStep("Verify response for executed POST request - verify call queue status")
                        .details(match(output.getCommandType(), equalTo(GgCommandType.GET_CALL_STATUS)))
                        .details(match(output.getResult(), equalTo(GgResult.OK)))
                        .details(match(output.getId(), equalTo("callQueue")))
                        .details(match(element.getStatus().toString(), equalTo(status))));
        }
    }

    @When("$hmiOperator start (via POST request) a call from phone book to $target")
    public void apiPhonebookCall( final String hmiOperator, final String target )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request - phone book call" );

        String  endpointUri = getStoryListData(hmiOperator, String.class);

        final JsonMessage jsonMessage =
                JsonMessage.builder()
                        .withCorrelationId(UUID.randomUUID())
                        .withPayload( new GgCommand( target, GgCommandType.PHONEBOOK_CALL )).build();

        Response response =
                getATIWebTarget( endpointUri )
                        .request( MediaType.APPLICATION_JSON )
                        .post( Entity.json( jsonMessage.toString() ) );

        final GgCommandResponse output = getGgResponseContent(response);

        evaluate( localStep( "Verify response for executed POST request - phone book call" )
                .details( match( output.getCommandType(), equalTo(GgCommandType.PHONEBOOK_CALL)) )
                .details( match( output.getResult(), equalTo(GgResult.OK)))
                .details( match( output.getId(), equalTo(target)) )
                .details( match(output.getData(), is(nullValue())) ));
    }

    private JerseyWebTarget getATIWebTarget(final String uri )
    {
        return new JerseyClientBuilder().build().target( uri );
    }

    private GgCommandResponse getGgResponseContent (final Response response)
    {
        final String responseContent = response.readEntity( new GenericType<String>() {} );
        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final GgCommandResponse result = jsonMessage.body().getPayloadAs( GgCommandResponse.class );
        return result;
    }

    private CommandResponse getResponseContent (final Response response)
    {
        final String responseContent = response.readEntity( new GenericType<String>() {} );
        final Gson gson = GsonUtils.getGson();
        final JsonMessage jsonMessage = gson.fromJson( responseContent, JsonMessage.class );
        final CommandResponse result = jsonMessage.body().getPayloadAs( CommandResponse.class );
        return result;
    }
}
