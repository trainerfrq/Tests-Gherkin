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

/**
 * Receive a single text message on a given endpoint/buffer
 */
class ReceiveFirstReceivedMessage extends AbstractBufferScript {
    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";
    public static final String IPARAM_BUFFERKEY = "websocket-target-buffer-key";
    public static final String IPARAM_DISCARDALLMESSAGES = "discard-all-messages";

    public static final String OPARAM_RECEIVEDMESSAGE = "received_message";

    @Override
    protected void script() {
        final String endpointName = assertInput(IPARAM_ENDPOINTNAME)
        final String bufferKey = assertInput(IPARAM_BUFFERKEY)
        Boolean shallBeDeleted = getInput(IPARAM_DISCARDALLMESSAGES, true) as Boolean

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

        List<TextMessage> allMessages
        if (shallBeDeleted) {
            allMessages = usedBuffer.pollAllTextMessages()
        } else {
            allMessages = usedBuffer.peekAllTextMessages()
        }

        // verify that at least one message is in the buffer
        evaluate(ExecutionDetails.create("Verify the nr. of stored messages")
                .expected("The number is: " + allMessages.size())
                .success())

        TextMessage firstReceivedMessage = allMessages.get(0);

        record(ExecutionDetails.create("Print first received message")
                .usedData(OPARAM_RECEIVEDMESSAGE, pretty(firstReceivedMessage))
                .success())

        // add received message to output parameters
        setOutput(OPARAM_RECEIVEDMESSAGE, firstReceivedMessage.getContent())
    }
}
