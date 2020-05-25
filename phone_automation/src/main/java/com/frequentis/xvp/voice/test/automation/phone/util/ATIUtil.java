package com.frequentis.xvp.voice.test.automation.phone.util;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
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

public class ATIUtil {

    private static final Logger LOGGER = LoggerFactory.getLogger( WebsocketScriptTemplate.class );

    public static String getResponse(final String endpointUri, final JsonMessage jsonMessage){

        Response response =
                getATIWebTarget( endpointUri )
                   .request( MediaType.APPLICATION_JSON )
                   .post( Entity.json( jsonMessage.toString() ));

        String responseContent = response.readEntity( new GenericType<String>() {} );
        int i = 1;
        int numberOfVerificationRetries = 17; //it will get and verify the response for 2 seconds
        while(!responseContent.contains("OK")){
            WaitTimer.pause(450);
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

    public static String receivedGGCallStatus(final GgCallStatusElement element, final String expectedStatus, final long nWait)
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
}
