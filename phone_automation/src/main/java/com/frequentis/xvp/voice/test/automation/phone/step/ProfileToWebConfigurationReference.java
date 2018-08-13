package com.frequentis.xvp.voice.test.automation.phone.step;


import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterClass;

import java.io.Serializable;

@CatsCustomParameterClass
public class ProfileToWebConfigurationReference extends CatsCustomParameterBase implements Serializable {

    @CatsCustomParameter(parameterName = "profile")
    private String profileName;
    @CatsCustomParameter(parameterName = "url")
    private String url;

    String getProfileName() {
        return profileName;
    }

    void setProfileName(String profileName) {
        this.profileName = profileName;
    }

    String getUrl() {
        return url;
    }

    void setUrl(String url) {
        this.url = url;
    }

    @Override
    public String toString() {
        return "ProfileToWebAppConfigurationReference{" +
                ", profileName='" + profileName + '\'' +
                ", url='" + url + '\'' +
                '}';
    }
}
