/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.cats.websocket.dto;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;

/**
 * Created by MAyar on 18.01.2017.
 */
public class WebsocketAutomationSteps extends AutomationSteps {

    public WebsocketProfile requireProfile(final String profileIdentifier) {
        return WebsocketProfile.fromProfile(assertProfile(profileIdentifier));
    }

    public WebsocketProfile requireCurrentPlaygroundProfile() {
        return requireProfile(null);
    }

}
