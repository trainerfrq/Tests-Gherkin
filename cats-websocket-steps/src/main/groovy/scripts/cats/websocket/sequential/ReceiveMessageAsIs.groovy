package scripts.cats.websocket.sequential

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpointManager
import com.frequentis.c4i.test.agent.websocket.common.impl.message.RecordedMessage
import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.xvp.tools.cats.websocket.plugin.WebsocketScriptTemplate

/**
 * Created by MAyar on 19.01.2017.
 */
class ReceiveMessageAsIs extends WebsocketScriptTemplate {

    public static final String IPARAM_ENDPOINTNAME = "endpoint-name";
    public static final String OPARAM_ACTIONTIME = "action-time";
    public static final String OPARAM_RECEIVEDMESSAGE = "received-message";

    @Override
    protected void script() {

        final String endpointName = (String) assertInput(IPARAM_ENDPOINTNAME);
        evaluate(ExecutionDetails.create("Getting input parameters")
                .received("Target endpoint name: " + endpointName)
                .success(endpointName == null || (endpointName != null && !endpointName.isEmpty())))

        ClientEndpoint clientEndpoint = ClientEndpointManager.getInstance().getWebSocketEndpoint(endpointName);

        evaluate(ExecutionDetails.create("Geting client endpoint with name: [" + endpointName + "]")
                .success(clientEndpoint != null))

        clientEndpoint.startRecording()

        evaluate(ExecutionDetails.create("Stopping recording")
                .expected("Recording still started")
                .success(clientEndpoint.recordingStarted()))

        clientEndpoint.stopRecording();

        evaluate(ExecutionDetails.create("Stopping recording")
                .expected("Recording stopped")
                .success(!clientEndpoint.recordingStarted()))

        ArrayList<RecordedMessage> recordedMessages = clientEndpoint.getRecordedMessages();

        // Return the received TextMessage if it was a CustomWebsocketMessage.
        if (recordedMessages != null) {
            TextMessage recordedMessage = recordedMessages.get(0).getMessage() as TextMessage;
            setOutput(OPARAM_RECEIVEDMESSAGE, recordedMessage.toString())
            setOutput(OPARAM_ACTIONTIME, recordedMessage.getNanoTime())
        }
    }
}
