package scripts.cats.websocket.parallel

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.client.impl.models.ClientEndpointConfiguration
import com.frequentis.c4i.test.agent.websocket.common.impl.buffer.MessageBuffer
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.cats.websocket.plugin.WebsocketScriptTemplate

/**
 * Created by MAyar on 18.01.2017.
 */

class OpenWebSocketClientConnection extends WebsocketScriptTemplate {

    public static final String IPARAM_ENDPOINTCONFIGURATION = "endpoint-configuration";
    public static final String IPARAM_MULTIPLEENDPOINTNAMES = "multiple-endpointnames";

    @Override
    protected void script() {

        // get the target endpoint names. Can be null --> default websocket endpoint name is used on creation.
        List<String> endpointNames = assertInput(IPARAM_MULTIPLEENDPOINTNAMES) as List;

        if (endpointNames != null) {
            if (endpointNames.size() > 0) {
                evaluate(ExecutionDetails.create("Getting input parameter")
                        .received("EndpointNames input parameter exists. Count:" + endpointNames.size())
                        .success())
            } else {
                evaluate(ExecutionDetails.create("Getting input parameter")
                        .received("EndpointNames input parameter exists but is empty. Open websocket connection script will be applied for default websocket endpoint")
                        .success())
            }
        } else {
            evaluate(ExecutionDetails.create("Getting input parameter")
                    .received("EndpointNames input parameter is null. Open websocket connection script will be applied for default websocket endpoint")
                    .success())
        }

        if (endpointNames == null || endpointNames.size() < 1) {
            endpointNames = new ArrayList<String>();
            endpointNames.add(null);
        }

        final ClientEndpointConfiguration config = assertInput(IPARAM_ENDPOINTCONFIGURATION) as ClientEndpointConfiguration;
        evaluate(ExecutionDetails.create("Reading web socket configuration")
                .expected("Input parameters can be read")
                .received("Created config: " + config)
                .success(config != null))
        Integer count = 1;
        for (String endpointName : endpointNames) {
            ClientEndpoint webSocketEndpoint = createWebSocketEndpoint(endpointName, config);

            evaluate(ExecutionDetails.create("\"Creating a new WebSocketEndpoint instance" + count++)
                    .expected("Instance is not null")
                    .success( webSocketEndpoint != null))

            if (webSocketEndpoint != null) {

                evaluate(ExecutionDetails.create("Checking WebSocketEndpoint instance")
                        .received("Created WebSocketEndpoint instance:" + endpointName == null ? "Default endpoint" : endpointName)
                        .success( webSocketEndpoint != null))

                String uri = webSocketEndpoint.getUri();
                Boolean isRunning = webSocketEndpoint.isRunning();
                Boolean isConnected = webSocketEndpoint.isConnected();

                Boolean bOpen = isRunning && isConnected;

                record(ExecutionDetails.create("Checking running state of websocket connection to: " + uri)
                        .expected("Running: " + config.getStartAfterInitialization())
                        .received("Running [" + isRunning + "] Connected [" + isConnected + "]")
                        .success(config.getStartAfterInitialization() == bOpen)
                        .group(endpointName));

                final MessageBuffer buffer = webSocketEndpoint.getMessageBuffer();

                record(ExecutionDetails.create("Applying JSON message filter")
                        .expected("Filter can be applied to message buffer")
                        .success(buffer != null)
                        .group(endpointName));
            }
        }
    }
}