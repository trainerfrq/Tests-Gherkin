/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *             Registered with Commercial Court Vienna,
 *             reg.no. FN 72.115b.
 */

package scripts.cats.websocket.sequential.buffer

import com.frequentis.c4i.test.agent.websocket.common.impl.buffer.MessageBuffer
import com.frequentis.c4i.test.agent.websocket.common.impl.message.BinaryMessage
import com.frequentis.c4i.test.agent.websocket.common.impl.message.TextMessage
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import com.google.gson.JsonParseException
import com.google.gson.JsonParser

import java.util.logging.Level
import java.util.logging.Logger


/**
 * Filter to be applied for buffering only JSON Text Messages.
 */
public class JsonMessageFilter implements MessageBuffer.Filter {

    /**
     * The logger to be used.
     */
    private static Logger LOG = Logger.getLogger(JsonMessageFilter.getName());

    /**
     * The message type to be allowed for buffering.
     */
    private final Set<String> filteredMessageTypes = Collections.synchronizedSet(new HashSet<String>());

    /**
     * The filter type specifies whether the filter collection contains allowed or ignored message types.
     */
    private JsonFilterType filterType = JsonFilterType.Allowed;

    /**
     * Initializes a new JsonMessageFilter.
     * @param filterType The FilterType.
     * @param messageTypes The message types to be considered by the filter.
     */
    public JsonMessageFilter() {
        setFilterType(filterType);
        setFilteredMessageTypes(null);
    }

    /**
     * Initializes a new JsonMessageFilter.
     * @param filterType The FilterType.
     * @param messageTypes The message types to be considered by the filter.
     */
    public JsonMessageFilter(final JsonFilterType filterType, final ArrayList<String> messageTypes) {
        setFilterType(filterType);
        setFilteredMessageTypes(messageTypes);
    }

    @Override
    TextMessage filterTextMessage(final String bufferKey, final TextMessage message) {
        LOG.log(Level.FINE, "Buffer [{}]: New Textmessage to filter arrived...", bufferKey);
        final JsonParser parser = new JsonParser(); //NOT THREAD SAFE
        try {
            final JsonElement jsonElement = parser.parse(message.getContent());
            if (jsonElement.isJsonObject()) {
                final JsonObject jsonObject = jsonElement.getAsJsonObject();
                final messageType = jsonObject.get("body").getAsJsonObject().entrySet().stream().findFirst().get().key;
                if (messageTypeAllowed(messageType)) {
                    return message;
                } else {
                    LOG.log(Level.FINE, "Buffer [{}]: Message type ignored - skip: [{}] [{}]", bufferKey, messageType, message);
                }
            } else {
                LOG.log(Level.FINE, "Buffer [{}]: Message not JSON - skip: [{}]", bufferKey, message);
            }
        } catch (JsonParseException ex) {
            LOG.log(Level.FINE, "Buffer [{}]: Message cannot be parsed - skip: [{}]", bufferKey, message, ex);
        } catch (Exception ex) {
            LOG.log(Level.WARNING, "Buffer [{}]: Message cannot be filtered - skip: [{}]", bufferKey, message, ex);
        }
        return null;
    }

    @Override
    BinaryMessage filterBinaryMessage(final String bufferKey, final BinaryMessage binaryMessage) {
        return null; //discard all binary messages
    }

    /**
     * Checks if the TextMessage should be added to the buffer according to the current filter options.
     * @param messageType The current message type.
     * @return True if the message type is currently allowed. Otherwise false.
     */
    private Boolean messageTypeAllowed(String messageType) {
        if (filteredMessageTypes.size() == 0) {
            return true;
        }

        Boolean isContained = filteredMessageTypes.contains(messageType);

        switch (filterType) {
            case JsonFilterType.Allowed:
                return isContained;
            case JsonFilterType.Ignored:
                return !isContained;
            default:
                return true;
        }
    }

    /**
     * Add message type to message type filter.
     */
    public void addFilteredMessageType(final String messageType) {
        if (messageType != null && !filteredMessageTypes.contains(messageType)) {
            filteredMessageTypes.add(messageType);
        }
    }

    /**
     * Remove message type from message type filter.
     */
    public void removeFilteredMessageType(final String messageType) {
        if (filteredMessageTypes.contains(messageType)) {
            filteredMessageTypes.remove(messageType);
        }
    }

    /**
     * Set allowed message types.
     */
    public void setFilteredMessageTypes(final ArrayList<String> messageTypes) {
        filteredMessageTypes.clear();
        if (messageTypes != null) {
            filteredMessageTypes.addAll(messageTypes);
        }
    }

    /**
     * Resets/Clears allowed message types.
     */
    public void resetMessageTypeFilter() {
        filteredMessageTypes.clear();
    }

    /**
     * Sets the current filter type.
     * @param type The FilterType.
     */
    public void setFilterType(JsonFilterType type) {
        filterType = type;
    }

    /**
     * Gets the current filter type.
     */
    public JsonFilterType getFilterType() {
        return filterType;
    }

    /**
     * Get considered message types.
     */
    public Set<String> getFilteredMessageTypes() {
        return filteredMessageTypes;
    }
}
