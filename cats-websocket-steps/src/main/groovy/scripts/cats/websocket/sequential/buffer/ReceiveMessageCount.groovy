package scripts.cats.websocket.sequential.buffer

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.common.impl.buffer.MessageBuffer
import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage
import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.cats.websocket.plugin.AbstractBufferScript


class ReceiveMessageCount extends AbstractBufferScript {
    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";
    public static final String IPARAM_BUFFERKEY = "websocket-target-buffer-key";
    public static final String IPARAM_MESSAGE_COUNT = "websocket-message-count";

    @Override
    protected void script() {
        final String endpointName = assertInput(IPARAM_ENDPOINTNAME)
        final String bufferKey = assertInput(IPARAM_BUFFERKEY)
        final Integer messageCount = assertInput(IPARAM_MESSAGE_COUNT) as Integer

        evaluate(ExecutionDetails.create("Getting input parameters")
                .expected("EndpointName input parameter exists or is null.")
                .received("Target endpoint name: '" + endpointName + "'")
                .success(endpointName == null || (endpointName != null && !endpointName.isEmpty())))

        ClientEndpoint endpoint = getWebSocketEndpointManager().getWebSocketEndpoint(endpointName);
        evaluate(ExecutionDetails.create("Verify websocket endpoint available")
                .expected("WebSocket endpoint available: " + endpointName)
                .success(endpoint != null))

        MessageBuffer usedBuffer = endpoint.getMessageBuffer(bufferKey.trim())
        evaluate(ExecutionDetails.create("Verify the buffer")
                .expected("Buffer should not be null ")
                .success(usedBuffer != null))

        List<TextMessage> allMessages = usedBuffer.peekAllTextMessages();

        allMessages.stream().forEach({ textMessage ->
            record(ExecutionDetails.create("Printing from the buffer message number" + allMessages.indexOf(textMessage))
                    .expected("Printing from the buffer message number" + allMessages.indexOf(textMessage), textMessage)
                    .success())
        })

        evaluate(ExecutionDetails.create("Verifying buffer length")
                .expected("Buffer should contain a number of " + messageCount + " message(s) in the buffer")
                .received("Number of message(s) in buffer: " + allMessages.size())
                .success(messageCount == allMessages.size()))
    }
}
