package scripts.cats.websocket.parallel

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.client.impl.models.ClientEndpointConfiguration
import com.frequentis.c4i.test.agent.websocket.common.impl.buffer.MessageBuffer
import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.xvp.tools.cats.websocket.plugin.WebsocketScriptTemplate


class OpenAndVerifyWebSocketClientConnection extends WebsocketScriptTemplate {

    public static final String IPARAM_ENDPOINTCONFIGURATION = "endpoint-configuration";
    public static final String IPARAM_MULTIPLEENDPOINTNAMES = "multiple-endpointnames";
    public static final String IPARAM_STATE = "state";

    public static final String OPARAM_RECEIVEDMESSAGE = "received_message";

    @Override
    protected void script() {

// get the target endpoint names. Can be null --> default websocket endpoint name is used on creation.
        List<String> endpointNames = assertInput(IPARAM_MULTIPLEENDPOINTNAMES) as List<String>;

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
        String state = assertInput(IPARAM_STATE) as String;
        evaluate(ExecutionDetails.create("Reading web socket configuration")
                .expected("Input parameters can be read")
                .received("Created config: " + config)
                .success(config != null))
        Integer count = 1;
        for (String endpointName : endpointNames) {
            while (!waitForState(endpointName, config, state)){
                WaitTimer.pause(300);
                if(waitForState(endpointName, config, state))
                    break
            }
            ClientEndpoint webSocketEndpoint = createWebSocketEndpoint(endpointName, config);

            evaluate(ExecutionDetails.create("Creating a new WebSocketEndpoint instance" + count++)
                    .expected("Instance is not null")
                    .success(webSocketEndpoint != null))

            if (webSocketEndpoint != null) {

                evaluate(ExecutionDetails.create("Checking WebSocketEndpoint instance")
                        .received("Created WebSocketEndpoint instance:" + endpointName == null ? "Default endpoint" : endpointName)
                        .success(webSocketEndpoint != null))

                String uri = webSocketEndpoint.getUri();
                Boolean isRunning = webSocketEndpoint.isRunning();
                Boolean isConnected = webSocketEndpoint.isConnected();

                Boolean bOpen = isRunning && isConnected;

                record(ExecutionDetails.create("Checking running state of websocket connection to: " + uri)
                        .expected("Running: " + config.getStartAfterInitialization())
                        .received("Running [" + isRunning + "] Connected [" + isConnected + "]")
                        .success(config.getStartAfterInitialization() == bOpen)
                        .group(endpointName));

                MessageBuffer buffer = webSocketEndpoint.getMessageBuffer();
                TextMessage message = buffer.pollTextMessage();

                record(ExecutionDetails.create("Applying JSON message filter")
                        .expected("Filter can be applied to message buffer")
                        .success(buffer != null)
                        .group(endpointName));

                setOutput(OPARAM_RECEIVEDMESSAGE, reportMessage(message.getContent()))
            }
        }
    }

    protected boolean waitForState(String endpointName, ClientEndpointConfiguration config, String state) {

        //open websocket connection
        ClientEndpoint webSocketEndpoint = createWebSocketEndpoint(endpointName, config);
        evaluate(ExecutionDetails.create("Creating a new WebSocketEndpoint instance")
                .expected("Instance is not null")
                .success(webSocketEndpoint != null))
        MessageBuffer buffer = webSocketEndpoint.getMessageBuffer();
        evaluate(ExecutionDetails.create("Get message buffer for the WebSocketEndpoint instance")
                .expected("Buffer is not null")
                .success(buffer != null))
        TextMessage message = buffer.pollTextMessage();
        evaluate(ExecutionDetails.create("Get message text from the buffer message")
                .expected("Text is not null " + message.toString())
                .success(message != null))
        if(message != null){
            String shortenMessage = reportMessage(message.getContent())
            record(ExecutionDetails.create("Redundancy state")
                    .expected("Redundancy state is"+state)
                    .received(shortenMessage)
                    .success(true))

            //close websocket connection
            webSocketEndpoint.dispose();

            return shortenMessage.contains(state);
        }
        else {
            List<TextMessage> listMessages = buffer.pollAllTextMessages()
            evaluate(ExecutionDetails.create("Get list of messages from the buffer message")
                    .expected("Text is not null " + listMessages.toString())
                    .success(message != null))
            for(TextMessage otherMessage:listMessages){
                String shortenMessage = reportMessage(otherMessage.getContent())
                record(ExecutionDetails.create("Redundancy state")
                        .expected("Redundancy state is"+state)
                        .received(shortenMessage)
                        .success(true))

                //close websocket connection
                webSocketEndpoint.dispose();

                return shortenMessage.contains(state);
            }
        }

    }

    public static String reportMessage(String message) {
        if (message.length() > 100) {
            message = message.substring(message.indexOf("redundancy"), message.length())
        }
        return message
    }
}
