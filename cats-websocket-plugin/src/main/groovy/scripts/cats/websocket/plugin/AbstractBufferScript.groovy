package scripts.cats.websocket.plugin

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.agent.websocket.client.impl.ClientEndpoint
import com.frequentis.c4i.test.agent.websocket.common.impl.buffer.MessageBuffer
import com.frequentis.c4i.test.agent.websocket.common.impl.message.BinaryMessage
import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.DateTimeUtil
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import com.frequentis.xvp.tools.cats.websocket.plugin.WebsocketScriptTemplate
import com.google.gson.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory

abstract class AbstractBufferScript extends WebsocketScriptTemplate {
    private static final Logger LOG = LoggerFactory.getLogger(AbstractBufferScript.getName());

    protected Boolean createNewBuffer(ClientEndpoint endpoint, String bufferKey, int nTextBufferSize, int nBinaryBufferSize, MessageBuffer.Filter filter) {
        if (endpoint == null) {
            LOG.warn("Given endpoint is null. Can not create buffer with key [" + bufferKey + "]");
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
            LOG.warn("Buffer with key [" + bufferKey + "] could not be created");
            return false;
        } else {
            LOG.info("Buffer with key [" + bufferKey + "] created");
        }

        return true;
    }

    protected Boolean createNewBuffer(ClientEndpoint endpoint, String bufferKey, int nTextBufferSize, int nBinaryBufferSize, String filteredMessageType) {
        ArrayList<String> filteredMessageTypes = new ArrayList<>(1);
        filteredMessageTypes.add(filteredMessageType);
        createNewBuffer(endpoint, bufferKey, nTextBufferSize, nBinaryBufferSize, filteredMessageTypes);
    }

    protected Boolean createNewBuffer(ClientEndpoint endpoint, String key, Integer nTextBufferSize, Integer nBinaryBufferSize, ArrayList<String> filteredMessageTypes) {
        MessageBuffer.Filter bufferFilter = new MessageBuffer.Filter() {
            @Override
            TextMessage filterTextMessage(final String bufferKey, final TextMessage message) {
                LOG.debug("Buffer [{}]: New Textmessage to filter arrived...", bufferKey);
                final JsonParser parser = new JsonParser(); //NOT THREAD SAFE
                try {
                    final JsonElement jsonElement = parser.parse(message.getContent());
                    if (jsonElement.isJsonObject()) {
                        final JsonObject jsonObject = jsonElement.getAsJsonObject();
                        final messageType = jsonObject.get("body").getAsJsonObject().entrySet().stream().findFirst().get().key;
                        if (filteredMessageTypes.contains(messageType)) {
                            return message;
                        } else {
                            LOG.debug("Buffer [{}]: Message type ignored - skip: [{}] [{}]", bufferKey, messageType, message);
                        }
                    } else {
                        LOG.debug("Buffer [{}]: Message not JSON - skip: [{}]", bufferKey, message);
                    }
                } catch (JsonParseException ex) {
                    LOG.debug("Buffer [{}]: Message cannot be parsed - skip: [{}]", bufferKey, message, ex);
                } catch (Exception ex) {
                    LOG.debug("Buffer [{}]: Message cannot be filtered - skip: [{}]", bufferKey, message, ex);
                }
                return null;
            }

            @Override
            BinaryMessage filterBinaryMessage(final String s, final BinaryMessage binaryMessage) {
                // Don't handle binary messages.
                return null;
            }
        };

        return createNewBuffer(endpoint, key, nTextBufferSize, nBinaryBufferSize, bufferFilter);
    }

    protected String pretty(final TextMessage message) {
        Objects.requireNonNull(message);

        try {
            final JsonParser jsonParser = new JsonParser();
            final JsonElement jsonElement = jsonParser.parse(message.getContent());
            final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSX").create();
            String stringMessage = gson.toJson(jsonElement);
            Date resultdate = new Date(message.getTimestamp());
            stringMessage += " [" + DateTimeUtil.getFormattedDate(resultdate) + "]";
            return stringMessage;
        } catch (Exception ignore) {
            return message.getContent();
        }
    }

    protected boolean receiveNrTextMessages(ClientEndpoint endpoint, String bufferKey, int nrExpectedMessages, long nWait) {
        final MessageBuffer buffer = endpoint.getMessageBuffer(bufferKey);
        WaitCondition condition = new WaitCondition("Wait until the buffer has " + nrExpectedMessages + "messages") {
            @Override
            boolean test() {
                DSLSupport.evaluate(ExecutionDetails.create("Verifying nr of messages")
                        .expected("Expected nr: " + nrExpectedMessages)
                        .received("Found nr: " + buffer.getTextMessagesCount())
                        .success())
                return buffer.getTextMessagesCount() >= nrExpectedMessages;

            }
        }
        return WaitTimer.pause(condition, nWait, 200);
    }
}
