/************************************************************************
 ** PROJECT:   XVP
 ** LANGUAGE:  Java, J2SE JDK 1.8
 **
 ** COPYRIGHT: FREQUENTIS AG
 **            Innovationsstrasse 1
 **            A-1100 VIENNA
 **            AUSTRIA
 **            tel +43 1 811 50-0
 **
 ** The copyright to the computer program(s) herein
 ** is the property of Frequentis AG, Austria.
 ** The program(s) shall not be used and/or copied without
 ** the written permission of Frequentis AG.
 **
 ************************************************************************/
package com.frequentis.xvp.tools.cats.web.automation.data;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameter;
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase;

@JsonIgnoreProperties(ignoreUnknown = true)
public class GroupCallsEntry extends CatsCustomParameterBase {

    private String id;
    @CatsCustomParameter(parameterName = "name")
    private String name;
    @CatsCustomParameter(parameterName = "displayName")
    private String displayName;
    @CatsCustomParameter(parameterName = "location")
    private String location;
    @CatsCustomParameter(parameterName = "organization")
    private String organization;
    @CatsCustomParameter(parameterName = "comment")
    private String comment;
    @CatsCustomParameter(parameterName = "callRouteSelector")
    private String callRouteSelector;
    @CatsCustomParameter(parameterName = "destination")
    private String destination;
    @CatsCustomParameter(parameterName = "resultingSipUri")
    private String resultingSipUri;

    public String getId() {
        return id;
    }

    public void setId(String id) { this.id = id; }

    public String getName() { return name; }

    public void setName(String name) { this.name = name; }

    public String getDisplayName() { return displayName; }

    public void setDisplayName(String displayName) { this.displayName = displayName; }

    public String getLocation() { return location; }

    public void setLocation(String location) { this.location = location; }

    public String getOrganization() { return organization; }

    public void setOrganization(String organization) { this.organization = organization; }

    public String getComment() { return comment; }

    public void setComment(String comment) { this.comment = comment; }

    public String getCallRouteSelector() { return callRouteSelector; }

    public void setCallRouteSelector(String callRouteSelector) { this.callRouteSelector = callRouteSelector; }

    public String getDestination() { return destination; }

    public void setDestination(String destination) { this.destination = destination; }

    public String getResultingSipUri() { return resultingSipUri; }

    public void setResultingSipUri(String resultingSipUri) { this.resultingSipUri = resultingSipUri; }

    @Override
    public String toString() {
        return "GroupCallsEntry{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", displayName='" + displayName + '\'' +
                ", location='" + location + '\'' +
                ", organization='" + organization + '\'' +
                ", comment='" + comment + '\'' +
                ", callRouteSelector='" + callRouteSelector + '\'' +
                ", destination='" + destination + '\'' +
                ", resultingSipUri='" + resultingSipUri + '\'' +
                '}';
    }
}
