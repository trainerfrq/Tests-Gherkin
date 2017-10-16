package scripts.cats.websocket.parallel

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.xvp.tools.cats.websocket.plugin.WebsocketScriptTemplate

/**
 * Created by MAyar on 19.01.2017.
 */
class SendTextMessageAsIsParallel extends WebsocketScriptTemplate {

    public static final String IPARAM_ENDPOINTNAME = "endpoint-name";
    public static final String IPARAM_MESSAGETOSEND = "message-tosend";

    @Override
    protected void script() {

        final String endpointName = assertInput(IPARAM_ENDPOINTNAME);
        final ClientEndpoint endpoint = getWebSocketEndpoint(endpointName);

        evaluate(ExecutionDetails.create("Getting input paramaeters")
                .received("Endpoint name: " + endpointName)
                .success(endpointName == null || (endpointName != null && !endpointName.isEmpty())));

        List<String> messageToSendList = assertInput(IPARAM_MESSAGETOSEND) as List;

        for (String messageToSend : messageToSendList) {
            evaluate(ExecutionDetails.create("Reading text message parameter")
                    .received(messageToSend)
                    .success(messageToSend != null))

            TextMessage sendMessage = new TextMessage(messageToSend);
            endpoint.sendText(sendMessage);
            TextMessage sentMessage = endpoint.getRecordedMessages().get(0).getMessage() as TextMessage;

            record(ExecutionDetails.create("Sending Text message")
                    .expected("Text message successfully sent")
                    .received("Sent message: " + sentMessage.toString())
                    .success(true))
        }
    }
}
