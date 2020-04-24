package com.frequentis.xvp.voice.test.automation.phone.step.local;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.voice.if73.json.messages.JsonMessage;
import com.frequentis.xvp.voice.if73.json.messages.payload.gg_commands.GgCallType;
import com.frequentis.xvp.voice.if73.json.messages.payload.gg_commands.GgCommand;
import com.frequentis.xvp.voice.if73.json.messages.payload.gg_commands.GgCommandType;
import com.frequentis.xvp.voice.if73.json.messages.payload.gg_commands.GgPrecondition;
import com.frequentis.xvp.voice.test.automation.phone.step.StepsUtil;
import org.apache.commons.io.FileUtils;
import org.glassfish.jersey.client.JerseyClientBuilder;
import org.glassfish.jersey.client.JerseyWebTarget;
import org.jbehave.core.annotations.When;

import javax.ws.rs.client.Entity;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.net.URI;
import java.util.Arrays;
import java.util.List;

public class ATISteps extends AutomationSteps
{
    private static final List<Integer> SUCCESS_RESPONSES = Arrays.asList( 200, 201 );

    @When("doing http POST request to endpoint $endpointUri using $resourcePath")
    public void doPOSTRequest( final String endpointUri, final String resourcePath )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request with payload" );

        final JsonMessage jsonMessage =
                JsonMessage.builder().withPayload( GgCommand.builder( GgCommandType.CLICK_DA, "TestId" )
                        .withPrecondition( GgPrecondition.PRIORITY ).withCallType( GgCallType.DA ).build() ).build();

        if ( endpointUri != null )
        {
            final URI automationInterfaceURI = new URI( endpointUri );

            Response response =
                    getATIWebTarget( automationInterfaceURI + resourcePath )
                            .request( MediaType.APPLICATION_JSON )
                            .post( Entity.json( jsonMessage ) );

            final JsonMessage responseJson = JsonMessage.fromJson(response.toString());

            localStep.details( ExecutionDetails.create( "Executed POST request with payload! " )
                    .expected(responseJson.toString())
                    .received( response.toString() )
                    .success( requestWithSuccess( response ) ) );
        }
        else
        {
            localStep.details( ExecutionDetails.create( "Executed POST request! " ).expected( "Success" )
                    .received( "Endpoint is not present", endpointUri != null ).failure() );
        }
    }

    @When("doing http POST request to endpoint $endpointUri and path $resourcePath with payload $templatePath")
    public void doingPOSTRequest( final String endpointUri, final String resourcePath, final String templatePath )
            throws Throwable
    {
        final LocalStep localStep = localStep( "Execute POST request with payload" );

        if ( endpointUri != null )
        {
            final URI configurationURI = new URI( endpointUri );
            final String templateContent = FileUtils.readFileToString( StepsUtil.getConfigFile( templatePath ) );
            Response response =
                    getATIWebTarget( configurationURI + resourcePath ).request( MediaType.APPLICATION_JSON )
                            .post( Entity.json( templateContent ) );

            localStep.details( ExecutionDetails.create( "Executed POST request with payload! " ).expected( "200 or 201" )
                    .received( response.toString() ).success( requestWithSuccess( response ) ) );
        }
        else
        {
            localStep.details( ExecutionDetails.create( "Executed POST request! " ).expected( "Success" )
                    .received( "Endpoint is not present", endpointUri != null ).failure() );
        }
    }

    private JerseyWebTarget getATIWebTarget(final String uri )
    {
        return new JerseyClientBuilder().build().target( uri );
    }

    private boolean requestWithSuccess( final Response response )
    {
        return SUCCESS_RESPONSES.contains( response.getStatus() );
    }
}
