/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */

package scripts.cats.websocket.sequential.buffer

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.cats.websocket.plugin.AbstractBufferScript

/**
 * Opens message buffer with filter set depending on the message type
 */
class OpenMessageBuffer extends AbstractBufferScript {
    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";
    public static final String IPARAM_BUFFERKEY = "websocket-target-buffer-key";
    public static final String IPARAM_MESSAGETYPE = "message_type";

    @Override
    protected void script() {
        // get input parameters
        final String endpointName = assertInput(IPARAM_ENDPOINTNAME)
        final String bufferKey = assertInput(IPARAM_BUFFERKEY)
        final String messageType = assertInput(IPARAM_MESSAGETYPE) as String

        // validate input parameters
        evaluate(ExecutionDetails.create("Getting input parameters")
                .expected("EndpointName input parameter exists or is null.")
                .received("Target endpoint name: '" + endpointName + "'")
                .success(endpointName == null || (endpointName != null && !endpointName.isEmpty())))

        // get and assert endpoint
        ClientEndpoint endpoint = getWebSocketEndpointManager().getWebSocketEndpoint(endpointName);
        evaluate(ExecutionDetails.create("Verify websocket endpoint available")
                .expected("WebSocket endpoint available: " + endpointName)
                .success(endpoint != null))

        def map = endpoint.getMessageBufferMap(true)
        Integer mapSize = map.size()

        evaluate(ExecutionDetails.create("Verify websocket buffer numbers")
                .expected("Available buffers: " + mapSize)
                .success(true))

        //Create Buffer for getting response
        Boolean notificationBufferCreated = createNewBuffer(endpoint, bufferKey.trim(), 30, 0, messageType);

        evaluate(ExecutionDetails.create("Notification buffer created")
                .usedData("Buffer key", bufferKey)
                .usedData("Filtered message type", messageType)
                .success(notificationBufferCreated))

        evaluate(ExecutionDetails.create("Verify websocket buffer numbers")
                .expected("Available buffers: " + endpoint.getMessageBufferMap(true).size())
                .success(true))
    }
}


