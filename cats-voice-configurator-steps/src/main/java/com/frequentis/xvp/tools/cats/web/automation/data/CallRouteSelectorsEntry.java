package com.frequentis.xvp.tools.cats.web.automation.data;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;

public class CallRouteSelectorsEntry extends CatsCustomParameterBase {

    @CatsCustomParameter(parameterName = "fullName")
    private String fullName;
    @CatsCustomParameter(parameterName = "displayName")
    private String displayName;
    @CatsCustomParameter(parameterName = "comment")
    private String comment;
    @CatsCustomParameter(parameterName = "sipPrefix")
    private String sipPrefix;
    @CatsCustomParameter(parameterName = "sipPostfix")
    private String sipPostfix;
    @CatsCustomParameter(parameterName = "sipDomain")
    private String sipDomain;
    @CatsCustomParameter(parameterName = "sipPort")
    private String sipPort;
    @CatsCustomParameter(parameterName = "sipResult")
    private String sipResult;


    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getSipPrefix() {
        return sipPrefix;
    }

    public void setSipPrefix(String sipPrefix) {
        this.sipPrefix = sipPrefix;
    }

    public String getSipPostfix() {
        return sipPostfix;
    }

    public void setSipPostfix(String sipPostfix) {
        this.sipPostfix = sipPostfix;
    }

    public String getSipDomain() {
        return sipDomain;
    }

    public void setSipDomain(String sipDomain) {
        this.sipDomain = sipDomain;
    }

    public String getSipPort() {
        return sipPort;
    }

    public void setSipPort(String sipPort) {
        this.sipPort = sipPort;
    }

    public String getSipResult() {
        return sipResult;
    }

    public void setSipResult(String sipResult) {
        this.sipResult = sipResult;
    }

    @Override
    public String toString() {
        return "CallRouteSelectorsEntry{" +
                "fullName='" + fullName + '\'' +
                ", displayName='" + displayName + '\'' +
                ", comment='" + comment + '\'' +
                ", sipPrefix='" + sipPrefix + '\'' +
                ", sipPostfix='" + sipPostfix + '\'' +
                ", sipDomain='" + sipDomain + '\'' +
                ", sipPort='" + sipPort + '\'' +
                ", sipResult='" + sipResult + '\'' +
                '}';
    }
}
