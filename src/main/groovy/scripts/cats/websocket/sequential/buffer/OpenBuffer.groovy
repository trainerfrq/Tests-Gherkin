/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */

package scripts.cats.websocket.sequential.buffer

import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.common.impl.buffer.MessageBuffer
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.xvp.tools.cats.websocket.plugin.WebsocketScriptTemplate

import java.util.logging.Logger

/**
 * Opens buffer with filter set depemding on the message type
 */
class OpenBuffer extends WebsocketScriptTemplate {
    private static Logger LOG = Logger.getLogger(OpenBuffer.getName());

    public static final String IPARAM_ENDPOINTNAME = "websocket-endpoint-name";
    public static final String IPARAM_BUFFERKEY = "websocket-target-buffer-key";
    public static final String IPARAM_MESSAGETYPE = "message_type";

    @Override
    protected void script() {
        // get input parameters
        final String endpointName = assertInput(IPARAM_ENDPOINTNAME);
        final String bufferKey = assertInput(IPARAM_BUFFERKEY);
        final String messageType = assertInput(IPARAM_MESSAGETYPE) as String;

        // validate input parameters
        evaluate(ExecutionDetails.create("Getting input parameters")
                .expected("EndpointName input parameter exists or is null.")
                .received("Target endpoint name: '" + endpointName + "'")
                .success(endpointName == null || (endpointName != null && !endpointName.isEmpty())))

        // get and assert endpoint
        ClientEndpoint endpoint = getWebSocketEndpointManager().getWebSocketEndpoint(endpointName);
        evaluate(ExecutionDetails.create("Verify websocket endpoint available")
                .expected("WebSocket endpoint available: " + endpointName)
                .success(endpoint != null))

        def map = endpoint.getMessageBufferMap(true)
        Integer mapSize = map.size()

        evaluate(ExecutionDetails.create("Verify websocket buffer numbers")
                .expected("Available buffers: " + mapSize)
                .success(true))

        //Create Buffer for getting response
        Boolean notificationBufferCreated = createNewBuffer(endpoint, bufferKey.trim(), 30, 0, messageType, JsonFilterType.Allowed);

        evaluate(ExecutionDetails.create("Notification buffer created")
                .usedData("Buffer key", bufferKey)
                .usedData("Filtered message types", messageType)
                .usedData("Filter type", JsonFilterType.Allowed)
                .success(notificationBufferCreated))

        evaluate(ExecutionDetails.create("Verify websocket buffer numbers")
                .expected("Available buffers: " + endpoint.getMessageBufferMap(true).size())
                .success(true))
    }

    private Boolean createNewBuffer(ClientEndpoint endpoint, String bufferKey, int nTextBufferSize, int nBinaryBufferSize, MessageBuffer.Filter filter) {
        if (endpoint == null) {
            LOG.warning("Given endpoint is null. Can not create buffer with key [" + bufferKey + "]");
            return false;
        }

        LOG.info("Creating buffer on endpoint ID " + endpoint.getIdentifier() + " URI " + endpoint.getUri());

        // create new message buffer
        MessageBuffer buffer = endpoint.getMessageBuffer(bufferKey);
        if (buffer == null) {

            LOG.info("No existing buffer with key [" + bufferKey + "] found. Creating new buffer...");
            buffer = new MessageBuffer(nTextBufferSize, nBinaryBufferSize, -1);
            endpoint.useMessageBuffer(bufferKey, buffer);
            LOG.info("New buffer not null " + (buffer != null));
        }

        if (filter != null) {
            LOG.info("Using custom filter for buffer " + (filter != null));
            buffer.useFilter(filter);
        }

        buffer.clearTextBuffer();

        if (buffer == null) {
            LOG.warning("Buffer with key [" + bufferKey + "] could not be created");
            return false;
        } else {
            LOG.info("Buffer with key [" + bufferKey + "] created");
        }

        return true;
    }

    private Boolean createNewBuffer(ClientEndpoint endpoint, String bufferKey, int nTextBufferSize, int nBinaryBufferSize, String filteredMessageType, JsonFilterType filterType) {
        ArrayList<String> filteredMessageTypes = new ArrayList<>(1);
        filteredMessageTypes.add(filteredMessageType);
        createNewBuffer(endpoint, bufferKey, nTextBufferSize, nBinaryBufferSize, filteredMessageTypes, filterType);
    }

    private Boolean createNewBuffer(ClientEndpoint endpoint, String bufferKey, Integer nTextBufferSize, Integer nBinaryBufferSize, ArrayList<String> filteredMessageTypes, JsonFilterType filterType) {
        return createNewBuffer(endpoint, bufferKey, nTextBufferSize, nBinaryBufferSize, new JsonMessageFilter(filterType, filteredMessageTypes));
    }
}


