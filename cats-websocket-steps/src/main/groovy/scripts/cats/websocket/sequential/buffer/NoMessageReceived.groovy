package scripts.cats.websocket.sequential.buffer

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.common.impl.buffer.MessageBuffer
import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.cats.websocket.plugin.AbstractBufferScript

/**
 * Check that websocket buffer is empty
 */
class NoMessageReceived extends AbstractBufferScript {
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

        def map = endpoint.getMessageBufferMap(true)
        Integer mapSize = map.size()

        evaluate(ExecutionDetails.create("Verify websocket buffer numbers")
                .expected("Available buffers: " + mapSize)
                .success())

        //check that the buffer is not null
        MessageBuffer usedBuffer = endpoint.getMessageBuffer(bufferKey.trim())
        evaluate(ExecutionDetails.create("Verify the buffer")
                .expected("Buffer should not be null: ")
                .success(usedBuffer != null))

        // verify that there is no message received
        evaluate(ExecutionDetails.create("Verify the buffer length")
                .expected("there is no message stored in the buffer named: " + bufferKey)
                .success(receiveNrTextMessages(endpoint, bufferKey, 0, 10000)))
    }
}
