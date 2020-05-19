package com.frequentis.xvp.tools.cats.web.automation.data;


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

    public String getProfileName() {
        return profileName;
    }

    public void setProfileName(String profileName) {
        this.profileName = profileName;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
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
