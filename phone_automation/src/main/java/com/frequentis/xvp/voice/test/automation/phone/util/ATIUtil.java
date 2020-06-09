package com.frequentis.xvp.voice.test.automation.phone.util;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.c4i.test.util.timer.WaitCondition;
import com.frequentis.c4i.test.util.timer.WaitTimer;
import com.frequentis.xvp.tools.cats.websocket.plugin.WebsocketScriptTemplate;
import com.frequentis.xvp.voice.if73.json.messages.JsonMessage;
import com.frequentis.xvp.voice.if73.json.messages.payload.gg_commands.GgCallStatusElement;
import org.glassfish.jersey.client.JerseyClientBuilder;
import org.glassfish.jersey.client.JerseyWebTarget;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.client.Entity;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.Arrays;
import java.util.List;

public class ATIUtil extends AutomationSteps {

    private static final Logger LOGGER = LoggerFactory.getLogger( WebsocketScriptTemplate.class );

    private static final List<Integer> SUCCESS_RESPONSES = Arrays.asList( 200, 201 );

    public String getResponseWithStatus(final String endpointUri, final JsonMessage jsonMessage, final String callStatus){

        final LocalStep localStep = localStep( "Verify POST request was done successfully" );

        Response response =
                getATIWebTarget( endpointUri )
                        .request( MediaType.APPLICATION_JSON )
                        .post( Entity.json( jsonMessage.toString() ));

        localStep.details( ExecutionDetails.create( "POST request was done successfully! " ).expected( "200 or 201" )
                .received( Integer.toString( response.getStatus() ) ).success( requestWithSuccess( response ) ) );

        String responseContent = response.readEntity( new GenericType<String>() {} );
        int i = 1;
        int numberOfVerificationRetries = 10; //it will get and verify the response for 2.5 seconds
        while(!responseContent.contains(callStatus) ){
            WaitTimer.pause(250);
            response =
                    getATIWebTarget( endpointUri )
                            .request( MediaType.APPLICATION_JSON )
                            .post( Entity.json( jsonMessage.toString() ));
            responseContent = response.readEntity( new GenericType<String>() {} );
            i++;
            if( i > numberOfVerificationRetries) {
                break;
            }
        }
        return responseContent;
    }

    private static JerseyWebTarget getATIWebTarget(final String uri )
    {
        return new JerseyClientBuilder().build().target( uri );
    }

    public String receivedGGCallStatus(final GgCallStatusElement element, final String expectedStatus, final long nWait)
    {
       String status = element.getStatus().toString();
       if (element.getStatus() != null )
        {
            try
            {
                final WaitCondition condition = new WaitCondition( "Wait for certain amount of time" )
                {
                    @Override
                    public boolean test()
                    {
                        return element.getStatus().toString().contains(expectedStatus);
                    }
                };

                if ( WaitTimer.pause( condition, nWait ) )
                {
                    status = element.getStatus().toString();
                }
            }
            catch ( final Exception ex )
            {
                LOGGER.error( "Error receiving status", ex );
            }
        }
        else
        {
            LOGGER.error( "Couldn't find element" );
        }
        return status;
    }

    private boolean requestWithSuccess( final Response response )
    {
        return SUCCESS_RESPONSES.contains( response.getStatus() );
    }
}
