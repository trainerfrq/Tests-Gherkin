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
package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.xvp.tools.cats.web.automation.data.GroupCallsEntry;
import com.frequentis.xvp.tools.cats.web.automation.data.ProfileToWebConfigurationReference;
import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.web.GlobalSettingsTelephone.GroupCalls.AddUpdateGroupCallsEntry;
import scripts.cats.web.GlobalSettingsTelephone.GroupCalls.VerifyGroupCallsEntryFields;
import scripts.cats.web.common.leftHandSidePanel.VerifyItemIsVisible;

import java.util.List;

public class GroupCallsWebSteps extends AutomationSteps {

    private static final String CONFIGURATION_KEY = "config";

    @When("add a new group call with: $groupCallDetails")
    @Alias("update a group call with: $groupCallDetails")
    public void createOrUpdateGroupCall(final List<GroupCallsEntry> groupCallDetails) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        GroupCallsEntry groupCall = groupCallDetails.get(0);

        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Adding or updating group call")
                    .scriptOn(AddUpdateGroupCallsEntry.class, profile)
                    .input(AddUpdateGroupCallsEntry.IPARAM_NAME, groupCall.getName())
                    .input(AddUpdateGroupCallsEntry.IPARAM_DISPLAY_NAME, groupCall.getDisplayName())
                    .input(AddUpdateGroupCallsEntry.IPARAM_LOCATION, groupCall.getLocation())
                    .input(AddUpdateGroupCallsEntry.IPARAM_ORGANIZATION, groupCall.getOrganization())
                    .input(AddUpdateGroupCallsEntry.IPARAM_COMMENT, groupCall.getComment())
                    .input(AddUpdateGroupCallsEntry.IPARAM_CALL_ROUTE_SELECTOR, groupCall.getCallRouteSelector())
                    .input(AddUpdateGroupCallsEntry.IPARAM_DESTINATION, groupCall.getDestination()));
        }
    }

    @Then("verify group call fields contain: $groupCallDetails")
    public void verifyGroupCallFields(final List<GroupCallsEntry> groupCallDetails) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        GroupCallsEntry groupCall = groupCallDetails.get(0);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Verify group call entry fields")
                    .scriptOn(VerifyGroupCallsEntryFields.class, profile)
                    .input(VerifyGroupCallsEntryFields.IPARAM_NAME, groupCall.getName())
                    .input(VerifyGroupCallsEntryFields.IPARAM_DISPLAY_NAME, groupCall.getDisplayName())
                    .input(VerifyGroupCallsEntryFields.IPARAM_LOCATION, groupCall.getLocation())
                    .input(VerifyGroupCallsEntryFields.IPARAM_ORGANIZATION, groupCall.getOrganization())
                    .input(VerifyGroupCallsEntryFields.IPARAM_COMMENT, groupCall.getComment())
                    .input(VerifyGroupCallsEntryFields.IPARAM_CALL_ROUTE_SELECTOR, groupCall.getCallRouteSelector())
                    .input(VerifyGroupCallsEntryFields.IPARAM_DESTINATION, groupCall.getDestination())
                    .input(VerifyGroupCallsEntryFields.IPARAM_RESULTING_SIP_URI, groupCall.getResultingSipUri()));
        }
    }

    @Then("group call $groupCallName is $visibility in $subMenuName list")
    public void checkGroupCallIsInGroupCallsList(String groupCallName, String visibility, String subMenuName) {
        boolean isVisible = true;
        if (visibility.contains("not")) {
            isVisible = false;
        }

        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Checking for " + groupCallName + " in results list")
                    .scriptOn(VerifyItemIsVisible.class, profile)
                    .input(VerifyItemIsVisible.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(VerifyItemIsVisible.IPARAM_ITEM_NAME, groupCallName)
                    .input(VerifyItemIsVisible.IPARAM_VISIBILITY, isVisible));
        }
    }
}
