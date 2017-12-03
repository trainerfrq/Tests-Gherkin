/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */


package scripts.cats.websocket.sequential

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.xvp.tools.cats.websocket.plugin.WebsocketScriptTemplate

/**
 * Sends a single TextMessage on a given Endpoint
 */
class SendTextMessage extends WebsocketScriptTemplate {
    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";
    public static final String IPARAM_MESSAGETOSEND = "message_to_send";

    @Override
    protected void script() {
        // get input parameters
        final String endpointName = assertInput(IPARAM_ENDPOINTNAME) as String;
        final String request = assertInput(IPARAM_MESSAGETOSEND) as String;

        // get and assert endpoint
        ClientEndpoint endpoint = getWebSocketEndpointManager().getWebSocketEndpoint(endpointName);
        evaluate(ExecutionDetails.create("Verify websocket endpoint available")
                .expected("WebSocket endpoint available: " + endpointName)
                .success(endpoint != null))

        // Send the TextMessage
        def textMessageRequest = new TextMessage(request)
        evaluate(ExecutionDetails.create("Sending text message")
                .expected("Text message successfully sent")
                .usedData(IPARAM_MESSAGETOSEND, request)
                .success(endpoint.sendText(new TextMessage(request))))
    }
}
