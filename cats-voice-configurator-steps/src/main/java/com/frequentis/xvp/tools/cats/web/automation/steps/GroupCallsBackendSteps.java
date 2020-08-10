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
import com.frequentis.xvp.tools.cats.web.automation.data.GroupCallsEntry;
import org.jbehave.core.annotations.Then;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class GroupCallsBackendSteps extends AutomationSteps {
    private static final Integer MAX_NUMBER_GROUP_CALLS = 100;

    @Then("verifying group calls requested response $response contains new added maximum number of group calls")
    public void verifyAddedGroupCallsExistInResponseMessage(String response) throws IOException {
        List<String> expectedGroupCallsNames = new ArrayList<>();

        for (int i = 1; i <= MAX_NUMBER_GROUP_CALLS; i++) {
            expectedGroupCallsNames.add("GroupCallTest" + i);
        }

        List<GroupCallsEntry> receivedGroupCalls = Arrays.asList(new ObjectMapper().readValue(response, GroupCallsEntry[].class));

        List<String> receivedGroupCallsNames = receivedGroupCalls.stream().map(GroupCallsEntry::getName).collect(Collectors.toList());

        evaluate(localStep("Verifying issued response contains added Group Calls")
                .details(ExecutionDetails.create("Verifying Group Calls names are the same")
                        .received(receivedGroupCallsNames.toString())
                        .expected(expectedGroupCallsNames.toString())
                        .success(receivedGroupCallsNames.containsAll(expectedGroupCallsNames) && receivedGroupCallsNames.size() == expectedGroupCallsNames.size())));
    }

    @Then("verifying group calls requested response $response contains group calls from table: $newGroupCall")
    public void verifyNewGroupCallExistsInGroupCallResponseMessage(String response, List<GroupCallsEntry> newGroupCall) throws IOException {
        List<GroupCallsEntry> receivedGroupCalls = Arrays.asList(new ObjectMapper().readValue(response, GroupCallsEntry[].class));
        List<String> receivedGroupCallsNames = receivedGroupCalls.stream().map(GroupCallsEntry::getName).collect(Collectors.toList());

        List<String> expectedGroupCallsNames = new ArrayList<>();

        for (GroupCallsEntry groupCall : newGroupCall) {
            expectedGroupCallsNames.add(groupCall.getName());
        }

        evaluate(localStep("Verifying issued response contains new added Group Calls")
                .details(ExecutionDetails.create("Verifying new Group Calls exists in received Group Calls list")
                        .received(receivedGroupCallsNames.toString())
                        .expected(expectedGroupCallsNames.toString() + " exists among received Group Calls")
                        .success(receivedGroupCallsNames.containsAll(expectedGroupCallsNames))));
    }
}

