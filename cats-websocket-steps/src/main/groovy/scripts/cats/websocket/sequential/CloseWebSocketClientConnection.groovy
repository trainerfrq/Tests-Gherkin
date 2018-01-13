/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */


package scripts.cats.websocket.sequential

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.xvp.tools.cats.websocket.plugin.WebsocketScriptTemplate

/**
 * Close an open web socket connection.
 */
class CloseWebSocketClientConnection extends WebsocketScriptTemplate {
    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";

    @Override
    protected void script() {
        final String endpointName = assertInput(IPARAM_ENDPOINTNAME)

        def disposed = getWebSocketEndpointManager().dispose(endpointName)
        evaluate(ExecutionDetails.create("Verify websocket endpoint disposed")
                .usedData(IPARAM_ENDPOINTNAME, endpointName)
                .success(disposed))
    }
}
