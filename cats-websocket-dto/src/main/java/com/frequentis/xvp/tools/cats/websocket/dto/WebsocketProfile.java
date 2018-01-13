/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.xvp.tools.cats.websocket.dto;

import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.bdd.instrumentation.error.UnsupportedProfileError;

import java.io.Serializable;

/**
 * The VoIP Profile.
 */
public class WebsocketProfile extends Profile implements Serializable {

    public static final long serialVersionUID = 24L;

    public static WebsocketProfile fromProfile(final Profile profile) {
        WebsocketProfile websocketUIProfile = new WebsocketProfile();
        websocketUIProfile.setCatsComponent(profile.getCatsComponent());
        websocketUIProfile.checkValidity();
        return websocketUIProfile;
    }

    @Override
    public void checkValidity() {
        super.checkValidity();
        // TODO validate agent type instead of profile name!
        if (! getName().contains("websocket")) {
            throw new UnsupportedProfileError("Expected profile name containing [websocket] or [mep]");
        }
    }
}
