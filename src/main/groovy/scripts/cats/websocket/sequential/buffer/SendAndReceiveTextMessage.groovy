/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */


package scripts.cats.websocket.sequential.buffer

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.TimeKeeperUtil
import scripts.cats.websocket.plugin.AbstractBufferScript

import java.util.concurrent.TimeUnit

/**
 * Sends a single TextMessage on a given Endpoint and waits for Response
 */
class SendAndReceiveTextMessage extends AbstractBufferScript {
    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";
    public static final String IPARAM_RESPONSETYPE = "expected-message-type";
    public static final String IPARAM_MESSAGETOSEND = "message_to_send";

    public static final String OPARAM_RECEIVEDMESSAGE = "received_message";
    public static final String OPARAM_SENDRECEIVEDELAY = "send_receive_delay";

    private final String TempBufferKey = "SendAndReceiveTextMessage";
    private final Long MaxResponseTimeout = 30;

    @Override
    protected void script() {
        ClientEndpoint endpoint;
        try {
            // get input parameters
            final String endpointName = assertInput(IPARAM_ENDPOINTNAME) as String;
            final String expectedResponseType = assertInput(IPARAM_RESPONSETYPE) as String;
            final String request = assertInput(IPARAM_MESSAGETOSEND) as String;

            // validate input parameters
            evaluate(ExecutionDetails.create("Getting input parameters")
                    .expected("ExpectedResponseType input parameter exists")
                    .received("Expected response message type: '" + expectedResponseType + "'")
                    .success(expectedResponseType != null && !expectedResponseType.isEmpty()))
            evaluate(ExecutionDetails.create("Getting input parameters")
                    .expected("Request input parameter exists and is not null")
                    .usedData(IPARAM_MESSAGETOSEND, request)
                    .success(request != null))

            // get and assert endpoint
            endpoint = getWebSocketEndpointManager().getWebSocketEndpoint(endpointName);
            evaluate(ExecutionDetails.create("Verify websocket endpoint available")
                    .expected("WebSocket endpoint available: " + endpointName)
                    .success(endpoint != null))

            //Create Buffer for getting response
            Boolean bufferAndFilterCreated = createNewBuffer(endpoint, TempBufferKey, 10, 0, expectedResponseType)
            record(ExecutionDetails.create("Custom buffer created")
                    .usedData("Buffer key", TempBufferKey)
                    .usedData("Filtered message type", expectedResponseType)
                    .success(bufferAndFilterCreated))

            // Send the TextMessage
            def textMessageRequest = new TextMessage(request)
            evaluate(ExecutionDetails.create("Sending text message")
                    .expected("Text message successfully sent")
                    .usedData(IPARAM_MESSAGETOSEND, request)
                    .success(endpoint.sendText(textMessageRequest)))

            //Receive Response
            final TextMessage response = endpoint.getMessageBuffer(TempBufferKey).pollTextMessage(MaxResponseTimeout * 1000)

            Long delay;
            if (response != null) {
                delay = new TimeKeeperUtil(textMessageRequest.nanoTime, TimeUnit.NANOSECONDS).getElapsedTime(response.nanoTime, TimeUnit.NANOSECONDS)
            }

            record(ExecutionDetails.create("Receiving text message")
                    .expected(delay != null ? "Text message successfully received within: " + TimeUnit.NANOSECONDS.toMillis(delay) + " ms" : "Couldn't receive response message")
                    .usedData(OPARAM_RECEIVEDMESSAGE, pretty(response))
                    .success(response != null))

            // add received message to output parameters and send-receive delay
            setOutput(OPARAM_RECEIVEDMESSAGE, response.getContent())
            setOutput(OPARAM_SENDRECEIVEDELAY, delay)
        } finally {
            if (endpoint != null) {
                endpoint.removeMessageBuffer(TempBufferKey);
            }
        }
    }
}
