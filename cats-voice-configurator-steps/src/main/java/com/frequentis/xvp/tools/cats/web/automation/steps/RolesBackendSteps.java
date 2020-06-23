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
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.PhoneBookEntry;
import com.frequentis.xvp.tools.cats.web.automation.data.Role;
import org.jbehave.core.annotations.Then;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class RolesBackendSteps extends AutomationSteps {
    private static final Integer MAX_NUMBER_ROLES = 50;

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
