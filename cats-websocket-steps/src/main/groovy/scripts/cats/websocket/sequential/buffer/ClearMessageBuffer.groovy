package scripts.cats.websocket.sequential.buffer

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.common.impl.buffer.MessageBuffer
import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.cats.websocket.plugin.AbstractBufferScript


class ClearMessageBuffer extends AbstractBufferScript {
    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";
    public static final String IPARAM_BUFFERKEY = "websocket-target-buffer-key";

    @Override
    protected void script() {
        final String endpointName = assertInput(IPARAM_ENDPOINTNAME)
        final String bufferKey = assertInput(IPARAM_BUFFERKEY)

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

        if (usedBuffer != null) {
            usedBuffer.clearTextBuffer()
        }

        evaluate(ExecutionDetails.create("Clearing text messages from buffer")
                .expected("Buffer should contain no text messages. Number of messages in buffer: " + usedBuffer.textMessagesCount)
                .success(!usedBuffer.hasTextMessages()))
    }
}
