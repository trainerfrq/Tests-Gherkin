/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */


package scripts.cats.websocket.sequential.buffer

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.common.impl.buffer.MessageBuffer
import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage
import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.cats.websocket.plugin.AbstractBufferScript

import java.util.logging.Logger

/**
 * Receive a single text message on a given endpoint/buffer
 */
class ReceiveLastReceivedMessage extends AbstractBufferScript {
    private static Logger LOG = Logger.getLogger(ReceiveLastReceivedMessage.getName());

    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";
    public static final String IPARAM_BUFFERKEY = "websocket-target-buffer-key";
    public static final String IPARAM_MAXRESPONSETIMEOUTINSEC = "max_response_timeout_in_sec";

    public static final String OPARAM_RECEIVEDMESSAGE = "received_message";

    private final Long MaxResponseTimeout = 30;

    @Override
    protected void script() {
        final String endpointName = assertInput(IPARAM_ENDPOINTNAME)
        final String bufferKey = assertInput(IPARAM_BUFFERKEY)
        String maxResponseTimeoutInSec = getInput(IPARAM_MAXRESPONSETIMEOUTINSEC)

        // Set response latency defaults if necessary
        if (maxResponseTimeoutInSec == null || maxResponseTimeoutInSec < 1) {
            maxResponseTimeoutInSec = MaxResponseTimeout;
            LOG.severe("maxResponseTimeoutInSec = " + maxResponseTimeoutInSec.toString())
        }

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

        // verify that at least one message is in the buffer
        evaluate(ExecutionDetails.create("Verify the buffer length")
                .expected("there is at least one message stored in the buffer named: " + bufferKey)
                .success(receiveNrTextMessages(endpoint, bufferKey, 1, 10000)))

        List<TextMessage> allMessages = usedBuffer.pollAllTextMessages()
        // verify that at least one message is in the buffer
        evaluate(ExecutionDetails.create("Verify the nr. of stored messages")
                .expected("The number is: " + allMessages.size())
                .success())

        TextMessage lastReceivedMessage = allMessages.get(allMessages.size() - 1);

        record(ExecutionDetails.create("Print last received message")
                .usedData(OPARAM_RECEIVEDMESSAGE, pretty(lastReceivedMessage))
                .success())

        // add received message to output parameters
        setOutput(OPARAM_RECEIVEDMESSAGE, lastReceivedMessage.getContent())
    }
}
