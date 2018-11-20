/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */


package scripts.cats.websocket.sequential

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpointManager
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.xvp.tools.cats.websocket.plugin.WebsocketScriptTemplate

/**
 * Close an open web socket connection.
 */
class CloseWebSocketClientConnection extends WebsocketScriptTemplate {
    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";

    @Override
    protected void script() {
        final String endpointName = assertInput(IPARAM_ENDPOINTNAME) as String
        evaluate(ExecutionDetails.create("Getting input parameters")
                .expected("EndpointName input parameter exists or is null.")
                .received("Target endpoint name: '"+ endpointName + "'")
                .success(endpointName == null || (endpointName != null && !endpointName.isEmpty())));

        ClientEndpointManager manager = ClientEndpointManager.getInstance();
        ClientEndpoint endpoint = manager.getWebSocketEndpoint(endpointName);

        evaluate(ExecutionDetails.create("Getting client endpoint with name: [" + endpointName + "]")
                .received(endpoint.toString())
                .success(endpoint != null));

        //def disposed = getWebSocketEndpointManager().dispose(endpointName)
        evaluate(ExecutionDetails.create("Verify websocket endpoint disposed")
                .usedData(IPARAM_ENDPOINTNAME, endpointName)
                .success(endpoint.dispose()))
    }
}
