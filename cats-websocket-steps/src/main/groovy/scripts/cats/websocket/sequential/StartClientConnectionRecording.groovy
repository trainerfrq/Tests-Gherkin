package scripts.cats.websocket.sequential

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpointManager
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.xvp.tools.cats.websocket.plugin.WebsocketScriptTemplate

/**
 * Created by MAyar on 19.01.2017.
 */
class StartClientConnectionRecording extends WebsocketScriptTemplate {

    public static final String IPARAM_ENDPOINTNAME = "endpoint-name";
    public static final String IPARAM_BUFFERSIZE = "buffer-size";

    @Override
    protected void script() {
        final String endpointName = (String) assertInput(IPARAM_ENDPOINTNAME);
        final Integer recordingBufferSize = (Integer) assertInput(IPARAM_BUFFERSIZE);
        evaluate(ExecutionDetails.create("Getting input parameters")
                .received("Endpoint name: " + endpointName)
                .received("Buffer size: " + recordingBufferSize))

        ClientEndpointManager manager = ClientEndpointManager.getInstance();
        ClientEndpoint endpoint = manager.getWebSocketEndpoint(endpointName);

        evaluate(ExecutionDetails.create("Getting client endpoint name with: [" + endpointName + "]")
                .received("Endpoint: " + endpoint)
                .success(endpoint != null))

        endpoint.startRecording(recordingBufferSize);
        record(ExecutionDetails.create("Recording started")
                .success(endpoint.recordingStarted()))
    }
}
