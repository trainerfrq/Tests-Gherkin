/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.cats.websocket.automation.steps;

import com.frequentis.c4i.test.agent.websocket.client.impl.models.ClientEndpointConfiguration;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.cats.websocket.dto.WebsocketAutomationSteps;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.slf4j.LoggerFactory;

import java.util.Map;

/**
 * Created by MAyar on 18.01.2017.
 */
public class WebsocketClientLocalSteps extends WebsocketAutomationSteps {
    private static org.slf4j.Logger LOG = LoggerFactory.getLogger(WebsocketClientLocalSteps.class.getName());

    @Given("named the websocket configurations: $connections")
    public void namedWebSocketClientConnection(final Map<String, ClientEndpointConfiguration> connections) {
        LOG.info ("Connections: " + connections);
        LocalStep step = localStep("Added named websocket client configurations to user named parameters");
        int count = 1;
        for (Map.Entry<String, ClientEndpointConfiguration> connectionsEntry : connections.entrySet()) {
            String key = connectionsEntry.getKey();
            ClientEndpointConfiguration config = connectionsEntry.getValue();
            setStoryListData(key, config);
            step.details(ExecutionDetails.create("Parse data table. Entry " + count + " of " + connections.size())
                    .expected("ExamplesTable can be parsed")
                    .receivedData(key, config)
                    .success(true));
            count++;
        }
        evaluate(step);
    }

    @Then("wait for $secs seconds")
    public void waitForSeconds(final int secs) {
        LocalStep step = localStep("Wait for " + secs + " seconds");

        try {
            Thread.sleep(secs * 1000);
            step.details(ExecutionDetails.create("Wait for " + secs + " seconds")
                        .received("Waited")
                        .success(true));
        } catch (Exception ex) {
            LOG.error("Error", ex);
            step.details(ExecutionDetails.create("Wait for " + secs + " seconds")
                    .received("Waited with error")
                    .success(false));
        }
        record(step);
    }
}
