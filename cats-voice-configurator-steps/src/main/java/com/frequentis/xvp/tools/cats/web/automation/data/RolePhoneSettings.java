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

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class RolePhoneSettings {

    private String sipAddress;
    private List<String> roleAliases = null;
    private List<Object> telephoneGroups = null;
    private String defaultSipPriority;
    private String routeSelectorId;

    public String getSipAddress() {
        return sipAddress;
    }

    public void setSipAddress(String sipAddress) {
        this.sipAddress = sipAddress;
    }

    public List<String> getRoleAliases() {
        return roleAliases;
    }

    public void setRoleAliases(List<String> roleAliases) {
        this.roleAliases = roleAliases;
    }

    public List<Object> getTelephoneGroups() {
        return telephoneGroups;
    }

    public void setTelephoneGroups(List<Object> telephoneGroups) {
        this.telephoneGroups = telephoneGroups;
    }

    public String getDefaultSipPriority() {
        return defaultSipPriority;
    }

    public void setDefaultSipPriority(String defaultSipPriority) {
        this.defaultSipPriority = defaultSipPriority;
    }

    public String getRouteSelectorId() {
        return routeSelectorId;
    }

    public void setRouteSelectorId(String routeSelectorId) {
        this.routeSelectorId = routeSelectorId;
    }

    @Override
    public String toString() {
        return "PhoneSettings{" +
                "sipAddress='" + sipAddress + '\'' +
                ", roleAliases=" + roleAliases +
                ", telephoneGroups=" + telephoneGroups +
                ", defaultSipPriority='" + defaultSipPriority + '\'' +
                ", routeSelectorId='" + routeSelectorId + '\'' +
                '}';
    }
}
