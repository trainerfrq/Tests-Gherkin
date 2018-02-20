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
import java.util.stream.Collectors

/**
 * Receive a single text message on a given endpoint/buffer
 */
class ReceiveAllReceivedMessages extends AbstractBufferScript {
    private static Logger LOG = Logger.getLogger(ReceiveAllReceivedMessages.getName());

    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";
    public static final String IPARAM_BUFFERKEY = "websocket-target-buffer-key";
    public static final String IPARAM_MAXRESPONSETIMEOUTINSEC = "max_response_timeout_in_sec";

    public static final String RECEIVEDMESSAGE = "received_message";

    public static final String OPARAM_RECEIVEDMESSAGES = "received_messages";
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
                .expected("Buffer should not be null")
                .success(usedBuffer != null))

        // verify that at least one message is in the buffer
        evaluate(ExecutionDetails.create("Verify the buffer length")
                .expected("Verify if there is at least one message stored in the buffer named: " + bufferKey)
                .success(receiveNrTextMessages(endpoint, bufferKey, 1, 10000)))

        List<TextMessage> allMessages = usedBuffer.peekAllTextMessages()
        // verify that at least one message is in the buffer
        evaluate(ExecutionDetails.create("Verify the nr. of stored messages")
                .expected("The number is: " + allMessages.size())
                .success())

        evaluate(ExecutionDetails.create("Printing all received message").success())

        allMessages.stream().forEach({ textMessage ->
            record(ExecutionDetails.create("Printing from the buffer message number" + allMessages.indexOf(textMessage))
                    .usedData(RECEIVEDMESSAGE, textMessage)
                    .success())
        })

        // add received message to output parameters
        ArrayList<String> outputList = allMessages.stream().map({ textMessage -> textMessage.getContent() }).collect(Collectors.toList());
        setOutput(OPARAM_RECEIVEDMESSAGES, outputList)
    }
}
