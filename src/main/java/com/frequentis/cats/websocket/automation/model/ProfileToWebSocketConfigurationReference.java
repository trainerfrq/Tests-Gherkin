/*
 * COPYRIGHT: FREQUENTIS AG. All rights reserved.
 *            Registered with Commercial Court Vienna,
 *            reg.no. FN 72.115b.
 */
package com.frequentis.cats.websocket.automation.model;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterClass;

import java.io.Serializable;

/**
 * Created by MAyar on 18.01.2017.
 */

@CatsCustomParameterClass
public class ProfileToWebSocketConfigurationReference extends CatsCustomParameterBase implements Serializable {
    @CatsCustomParameter(parameterName = "profile-name")
    private String profileName;
    @CatsCustomParameter(parameterName = "websocket-config-name")
    private String webSocketConfigurationName;

    public String getProfileName() {
        return profileName;
    }

    public void setProfileName(String profile) {
        this.profileName = profile;
    }

    public String getWebSocketConfigurationName() {
        return webSocketConfigurationName;
    }

    public void setWebSocketConfigurationName(String configurationName) {
        this.webSocketConfigurationName = configurationName;
    }

    @Override
    public String toString() {
        return "ProfileToWebSocketConfigurationReference{" +
                ", profileName='" + profileName + '\'' +
                ", webSocketConfigurationName='" + webSocketConfigurationName + '\'' +
                '}';
    }
}
