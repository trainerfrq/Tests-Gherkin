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
public class PhoneBookEntry extends CatsCustomParameterBase{

    @CatsCustomParameter(parameterName = "fullName")
    private String fullName;
    @CatsCustomParameter(parameterName = "displayName")
    private String displayName;
    @CatsCustomParameter(parameterName = "location")
    private String location;
    @CatsCustomParameter(parameterName = "organization")
    private String organization;
    @CatsCustomParameter(parameterName = "comment")
    private String comment;
    @CatsCustomParameter(parameterName = "destination")
    private String destination;
    @CatsCustomParameter(parameterName = "displayAddon")
    private String displayAddon;


    public String getFullName() { return fullName; }

    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getDisplayName() { return displayName; }

    public void setDisplayName(String displayName) { this.displayName = displayName; }

    public String getLocation() { return location; }

    public void setLocation(String location) { this.location = location; }

    public String getOrganization() { return organization; }

    public void setOrganization(String organization) { this.organization = organization; }

    public String getComment() { return comment; }

    public void setComment(String comment) { this.comment = comment; }

    public String getDestination() { return destination; }

    public void setDestination(String destination) { this.destination = destination; }

    public String getDisplayAddon() { return displayAddon; }

    public void setDisplayAddon(String displayAddon) { this.displayAddon = displayAddon; }

    @Override
    public String toString() {
        return "PhoneBookEntry{" +
                "fullName='" + fullName + '\'' +
                ", displayName='" + displayName + '\'' +
                ", location='" + location + '\'' +
                ", organization='" + organization + '\'' +
                ", comment='" + comment + '\'' +
                ", destination='" + destination + '\'' +
                ", displayAddon='" + displayAddon + '\'' +
                "} " + super.toString();
    }
}
