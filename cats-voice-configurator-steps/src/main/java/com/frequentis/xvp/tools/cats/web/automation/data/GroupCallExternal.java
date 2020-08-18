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

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.common.base.Objects;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class GroupCallExternal {

    private String name;
    private String displayName;
    private String location;
    private String organization;
    private String comment;
    private String sipAddress;

    @JsonCreator
    public GroupCallExternal(@JsonProperty("name") String name, @JsonProperty("displayName") String displayName, @JsonProperty("location") String location, @JsonProperty("organization") String organization, @JsonProperty("comment") String comment, @JsonProperty("sipAddress") String sipAddress) {

        this.name = name;
        this.displayName = displayName;
        this.location = location;
        this.organization = organization;
        this.comment = comment;
        this.sipAddress = sipAddress;
    }

    public GroupCallExternal(GroupCallsEntry entry) {
        this.name = entry.getName() == null ? "" : entry.getName();
        this.displayName = entry.getDisplayName() == null ? "" : entry.getDisplayName();
        this.location = entry.getLocation() == null ? "" : entry.getLocation();
        this.organization = entry.getOrganization() == null ? "" : entry.getOrganization();
        this.comment = entry.getComment() == null ? "" : entry.getComment();
        this.sipAddress = entry.getDestination() == null ? "" : entry.getDestination();

    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getOrganization() {
        return organization;
    }

    public void setOrganization(String organization) {
        this.organization = organization;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getSipAddress() {
        return sipAddress;
    }

    public void setSipAddress(String sipAddress) {
        this.sipAddress = sipAddress;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        GroupCallExternal that = (GroupCallExternal) o;
        return Objects.equal(name, that.name) &&
                Objects.equal(displayName, that.displayName) &&
                Objects.equal(location, that.location) &&
                Objects.equal(organization, that.organization) &&
                Objects.equal(comment, that.comment) &&
                Objects.equal(sipAddress, that.sipAddress);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(name, displayName, location, organization, comment, sipAddress);
    }

    @Override
    public String toString() {
        return "GroupCallExternal{" +
                "name='" + name + '\'' +
                ", displayName='" + displayName + '\'' +
                ", location='" + location + '\'' +
                ", organization='" + organization + '\'' +
                ", comment='" + comment + '\'' +
                ", sipAddress='" + sipAddress + '\'' +
                '}';
    }
}
