package com.frequentis.xvp.tools.cats.web.automation.data;

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;

public class CallRouteSelectorsEntry extends CatsCustomParameterBase {

    private String id;
    @CatsCustomParameter(parameterName = "fullName")
    private String name;
    @CatsCustomParameter(parameterName = "displayName")
    private String displayName;
    @CatsCustomParameter(parameterName = "comment")
    private String comment;
    @CatsCustomParameter(parameterName = "sipPrefix")
    private String prefix;
    @CatsCustomParameter(parameterName = "sipPostfix")
    private String postfix;
    @CatsCustomParameter(parameterName = "sipDomain")
    private String domain;
    @CatsCustomParameter(parameterName = "sipPort")
    private String port;
    @CatsCustomParameter(parameterName = "sipResult")
    private String sipResult;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFullName() {
        return name;
    }

    public void setFullName(String fullName) {
        this.name = fullName;
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
        return prefix;
    }

    public void setSipPrefix(String sipPrefix) {
        this.prefix = sipPrefix;
    }

    public String getSipPostfix() {
        return postfix;
    }

    public void setSipPostfix(String sipPostfix) {
        this.postfix = sipPostfix;
    }

    public String getSipDomain() {
        return domain;
    }

    public void setSipDomain(String sipDomain) {
        this.domain = sipDomain;
    }

    public String getSipPort() {
        return port;
    }

    public void setSipPort(String sipPort) {
        this.port = sipPort;
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
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", displayName='" + displayName + '\'' +
                ", comment='" + comment + '\'' +
                ", prefix='" + prefix + '\'' +
                ", postfix='" + postfix + '\'' +
                ", domain='" + domain + '\'' +
                ", port='" + port + '\'' +
                ", sipResult='" + sipResult + '\'' +
                '}';
    }
}
