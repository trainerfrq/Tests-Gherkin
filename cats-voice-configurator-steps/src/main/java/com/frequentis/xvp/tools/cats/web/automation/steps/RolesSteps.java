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

import com.fasterxml.jackson.databind.ObjectMapper;
import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.PhoneBookEntry;
import com.frequentis.xvp.tools.cats.web.automation.data.ProfileToWebConfigurationReference;
import com.frequentis.xvp.tools.cats.web.automation.data.Role;
import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.web.MissionsAndRoles.AddUpdateRole;
import scripts.cats.web.MissionsAndRoles.VerifyRoleFields;
import scripts.cats.web.common.leftHandSidePanel.VerifyItemIsVisibleInItemsList;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class RolesSteps  extends AutomationSteps {
    private static final String CONFIGURATION_KEY = "config";
    private static final Integer MAX_NUMBER_ROLES = 50;

    @When("add a new role with: $roleDetails")
    @Alias("update a role with: $roleDetails")
    public void createOrUpdateRole(final List<Role> roleDetails) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        Role role = roleDetails.get(0);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Adding or updating role")
                    .scriptOn(AddUpdateRole.class, profile)
                    .input(AddUpdateRole.IPARAM_NAME, role.getName())
                    .input(AddUpdateRole.IPARAM_DISPLAY_NAME, role.getDisplayName())
                    .input(AddUpdateRole.IPARAM_LOCATION, role.getLocation())
                    .input(AddUpdateRole.IPARAM_ORGANIZATION, role.getOrganization())
                    .input(AddUpdateRole.IPARAM_COMMENT, role.getComment())
                    .input(AddUpdateRole.IPARAM_NOTES, role.getNotes())
                    .input(AddUpdateRole.IPARAM_LAYOUT, role.getLayout())
                    .input(AddUpdateRole.IPARAM_CALL_ROUTE_SELECTOR, role.getCallRouteSelector())
                    .input(AddUpdateRole.IPARAM_DESTINATION, role.getDestination())
                    .input(AddUpdateRole.IPARAM_DEFAULT_SOURCE_OUTGOING_CALLS, role.getDefaultSourceOutgoingCalls())
                    .input(AddUpdateRole.IPARAM_DEFAULT_SIP_PRIORITY, role.getDefaultSipPriority()));
        }
    }

    @Then("verify role fields contain: $roleDetails")
    public void verifyRoleFields(final List<Role> roleDetails) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        Role role = roleDetails.get(0);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Verify phonebook entry fields")
                    .scriptOn(VerifyRoleFields.class, profile)
                    .input(VerifyRoleFields.IPARAM_NAME, role.getName())
                    .input(VerifyRoleFields.IPARAM_DISPLAY_NAME, role.getDisplayName())
                    .input(VerifyRoleFields.IPARAM_LOCATION, role.getLocation())
                    .input(VerifyRoleFields.IPARAM_ORGANIZATION, role.getOrganization())
                    .input(VerifyRoleFields.IPARAM_COMMENT, role.getComment())
                    .input(VerifyRoleFields.IPARAM_NOTES, role.getNotes())
                    .input(VerifyRoleFields.IPARAM_LAYOUT, role.getLayout())
                    .input(VerifyRoleFields.IPARAM_CALL_ROUTE_SELECTOR, role.getCallRouteSelector())
                    .input(VerifyRoleFields.IPARAM_DESTINATION, role.getDestination())
                    .input(VerifyRoleFields.IPARAM_RESULTING_SIP_URI, role.getResultingSipUri())
                    .input(VerifyRoleFields.IPARAM_DEFAULT_SOURCE_OUTGOING_CALLS, role.getDefaultSourceOutgoingCalls())
                    .input(VerifyRoleFields.IPARAM_DEFAULT_SIP_PRIORITY, role.getDefaultSipPriority()));
        }
    }

    @Then("role $roleName is $visibility in $subMenuName list")
    public void checkRoleIsInRolesList(String roleName, String visibility, String subMenuName) {
        boolean isVisible = true;
        if (visibility.contains("not")) {
            isVisible = false;
        }

        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Checking for " + roleName + " in results list")
                    .scriptOn(VerifyItemIsVisibleInItemsList.class, profile)
                    .input(VerifyItemIsVisibleInItemsList.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(VerifyItemIsVisibleInItemsList.IPARAM_ITEM_NAME, roleName)
                    .input(VerifyItemIsVisibleInItemsList.IPARAM_VISIBILITY, isVisible));
        }
    }

    @Then("verifying roles requested response $response contains new added maximum number of roles")
    public void verifyAddedRolesExistsInResponseMessage(String response) throws IOException {
        List<String> expectedRolesNames = new ArrayList<>();

        for (int i = 1; i <= MAX_NUMBER_ROLES; i++) {
            expectedRolesNames.add("RoleTest" + i);
        }

        List<Role> receivedRoles = Arrays.asList(new ObjectMapper().readValue(response, Role[].class));

        List<String> receivedRolesNames = receivedRoles.stream().map(Role::getName).collect(Collectors.toList());

        evaluate(localStep("Verifying issued response contains added Roles")
                .details(ExecutionDetails.create("Verifying Roles names are the same")
                        .received(receivedRolesNames.toString())
                        .expected(expectedRolesNames.toString())
                        .success(receivedRolesNames.containsAll(expectedRolesNames) && receivedRolesNames.size() == expectedRolesNames.size())));
    }

    @Then("verifying roles requested response $response contains roles from table: $newRole")
    public void verifyNewRoleExistsInRoleResponseMessage(String response, List<Role> newRole) throws IOException {
        List<Role> receivedRoles = Arrays.asList(new ObjectMapper().readValue(response, Role[].class));
        List<String> receivedRolesNames = receivedRoles.stream().map(Role::getName).collect(Collectors.toList());

        List<String> expectedRolesNames = new ArrayList<>();

        for (Role role : newRole) {
            expectedRolesNames.add(role.getName());
        }

        evaluate(localStep("Verifying issued response contains new added Roles")
                .details(ExecutionDetails.create("Verifying new Role exists in received Roles list")
                        .received(receivedRolesNames.toString())
                        .expected(expectedRolesNames.toString() + " exists among received Roles")
                        .success(receivedRolesNames.containsAll(expectedRolesNames))));
    }

    @Then("verifying phoneBook requested response $response contains new added maximum number of roles")
    public void verifyAddedRolesExistsInPhonebookResponseMessage(String response) throws IOException {
        final int ROLES_NUMBER_ADDED_USING_UI = 10;

        List<String> expectedRolesNames = new ArrayList<>();

        for (int i = 1; i <= ROLES_NUMBER_ADDED_USING_UI; i++) {
            expectedRolesNames.add("RoleTest" + i);
        }

        List<PhoneBookEntry> receivedPhonebookEntries = Arrays.asList(new ObjectMapper().readValue(response, PhoneBookEntry[].class));

        List<String> receivedPhonebookEntriesNames = receivedPhonebookEntries.stream().map(PhoneBookEntry::getFullName).collect(Collectors.toList());

        evaluate(localStep("Verifying issued response contains added Roles")
                .details(ExecutionDetails.create("Verifying received response contains Roles")
                        .received(receivedPhonebookEntriesNames.toString())
                        .expected(expectedRolesNames.toString())
                        .success(receivedPhonebookEntriesNames.containsAll(expectedRolesNames))));

    }

    @Then("verifying phoneBook requested response $response contains roles from table: $neRole")
    public void verifyNewRoleExistsInPhonebookResponseMessage(String response, List<Role> newRole) throws IOException {

        List<PhoneBookEntry> receivedPhonebookEntries = Arrays.asList(new ObjectMapper().readValue(response, PhoneBookEntry[].class));
        List<String> receivedPhonebookEntriesNames = receivedPhonebookEntries.stream().map(PhoneBookEntry::getFullName).collect(Collectors.toList());

        List<String> expectedRolesNames = new ArrayList<>();

        for (Role role : newRole) {
            expectedRolesNames.add(role.getName());
        }

        evaluate(localStep("Verifying issued response contains new added Roles")
                .details(ExecutionDetails.create("Verifying new Role exists in received Phonebook list")
                        .received(receivedPhonebookEntriesNames.toString())
                        .expected(expectedRolesNames.toString() + " exists among received Phonebook entries")
                        .success(receivedPhonebookEntriesNames.containsAll(expectedRolesNames))));

    }

}
