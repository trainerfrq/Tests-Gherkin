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
 * Delete custom buffer
 */
class RemoveCustomMessageBuffer extends AbstractBufferScript {
    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";
    public static final String IPARAM_BUFFERKEY = "websocket-target-buffer-key";

    @Override
    protected void script() {
        final String endpointName = assertInput(IPARAM_ENDPOINTNAME)
        final String bufferKey = assertInput(IPARAM_BUFFERKEY)

        // get and assert endpoint
        ClientEndpoint endpoint = getWebSocketEndpointManager().getWebSocketEndpoint(endpointName);
        evaluate(ExecutionDetails.create("Verify websocket endpoint available")
                .expected("WebSocket endpoint available: " + endpointName)
                .success(endpoint != null))

        if (endpoint != null) {
            endpoint.removeMessageBuffer(bufferKey);
        }

        record(ExecutionDetails.create("Deleting custom buffer on the endpoint named: " + endpointName)
                .expected("Custom buffer deleted")
                .received("Deleted buffer with key: " + bufferKey)
                .success())
    }
}

