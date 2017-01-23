/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.cats.websocket.plugin;

import com.frequentis.c4i.test.plugin.CatsPluginInterface;
import com.frequentis.c4i.test.plugin.PluginInitializationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

/**
 * Takes care of initialising the domain technology from the CATS agent.
 */
public class WebsocketPluginInterface extends CatsPluginInterface {

    private static final Logger LOGGER = LoggerFactory.getLogger(WebsocketPluginInterface.class);

    @Override
    public String getPluginName() {
        return "cats-websocket-plugin";
    }

    /**
     * The method invoked by the CATS agent to initialise the domain technology.
     *
     * @param agentArgs   the startup arguments.
     * @param agentConfig the agent config
     */
    @Override
    public void init(final String agentArgs, final Map<String, String> agentConfig) throws PluginInitializationException {
        LOGGER.info("Initializing websocket technology");
    }

    @Override
    public void shutdown() {
        LOGGER.info("Received plugin shutdown request - stopping websocket plugin");
    }
}
