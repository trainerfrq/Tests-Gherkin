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
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.GroupCallExternal;
import com.frequentis.xvp.tools.cats.web.automation.data.GroupCallsEntry;
import org.apache.commons.io.FileUtils;
import org.jbehave.core.annotations.Aliases;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import javax.ws.rs.client.Entity;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.net.URI;
import java.util.*;
import java.util.stream.Collectors;

import static com.frequentis.xvp.tools.cats.web.automation.steps.UtilSteps.*;

public class GroupCallsBackendSteps extends AutomationSteps {
    private static final Integer MAX_NUMBER_GROUP_CALLS = 100;
    private static final String GROUP_CALLS_SUB_PATH = "/op-voice-service/groupcalls";
    private static final String GROUP_CALLS_CONFIGURATION_SUB_PATH = "/op-voice-service/generic/items/.groupcallaggregator%2FgroupCalls.json";

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
                        .success(receivedGroupCallsNames.equals(expectedGroupCallsNames))));
    }

    @Then("verifying group calls requested response $response contains group calls from table: $newGroupCall")
    public void verifyNewGroupCallExistsInGroupCallResponseMessage(String response, List<GroupCallsEntry> newGroupCall) throws IOException {
        List<GroupCallExternal> receivedGroupCalls = Arrays.asList(new ObjectMapper().readValue(response, GroupCallExternal[].class));

        List<GroupCallExternal> expectedGroupCalls = newGroupCall.stream().map(GroupCallExternal::new).collect(Collectors.toList());

        evaluate(localStep("Verifying issued response contains new added Group Calls")
                .details(ExecutionDetails.create("Verifying new Group Calls exists in received Group Calls list")
                        .expected(expectedGroupCalls.toString())
                        .received(receivedGroupCalls.toString())
                        .success(receivedGroupCalls.containsAll(expectedGroupCalls))));
    }

    @Given("the group calls ids for configurator $endpointUri are saved in list $listName")
    public void saveDefaultGroupCallsIds(final String endpointUri, final String listName) throws IOException {
        final LocalStep localStep = localStep("Execute GET request - save default group calls' ids");

        Response response =
                getConfigurationItemsWebTarget(endpointUri + GROUP_CALLS_SUB_PATH)
                        .request(MediaType.APPLICATION_JSON)
                        .get();

        String responseContent = response.readEntity(new GenericType<String>() {
        });

        localStep.details(ExecutionDetails.create("Executed GET request").expected("200 or 201")
                .received("Status: " + response.getStatus() + "\nMessage: " + responseContent)
                .success(responseWasSuccessful(response)));

        List<GroupCallsEntry> receivedGroupCalls = Arrays.asList(new ObjectMapper().readValue(responseContent, GroupCallsEntry[].class));

        ArrayList<String> groupCallIds = new ArrayList<>();

        for (GroupCallsEntry groupCall : receivedGroupCalls) {
            evaluate(localStep("Save group call id")
                    .details(ExecutionDetails.create("Save group call id")
                            .received("Group call " + groupCall.getName() + " with id: " + groupCall.getId())
                            .success(true)));
            groupCallIds.add(groupCall.getId());
        }

        setStoryListData(listName, groupCallIds);
    }

    @Then("using $endpointUri delete group calls with ids from list $listName")
    public void deleteGroupCalls(final String endpointUri, final String listName) throws Throwable {
        final LocalStep localStep = localStep("Execute DELETE request - delete default Group Calls");

        ArrayList<String> groupCallsListIds = getStoryListData(listName, ArrayList.class);

        if (!(groupCallsListIds == null)) {
            for (String groupCallId : groupCallsListIds) {
                final URI configurationURI = new URI(endpointUri);

                Response deleteResponse =
                        getConfigurationItemsWebTarget(configurationURI + GROUP_CALLS_SUB_PATH)
                                .path(groupCallId)
                                .request(MediaType.APPLICATION_JSON)
                                .delete();
                localStep.details(ExecutionDetails.create("Executed DELETE request - on Group Call with id: " + groupCallId).expected("200 or 201")
                        .received("Status: " + deleteResponse.getStatus() + "\nMessage: " + deleteResponse.readEntity(new GenericType<String>() {
                        }))
                        .success(responseWasSuccessful(deleteResponse)));
            }
        } else {
            localStep.details(ExecutionDetails.create("DELETE request wasn't necessary - no Group Calls found ")
                    .success(true));
        }
    }

    @Then("add group calls to $endpointUri using configurators with ids from lists $listName found in path $templatePath")
    public void addDefaultGroupCalls(final String endpointUri, final String listName, final String templatePath) throws Throwable {
        final LocalStep localStep = localStep("Execute POST request with payload");
        List<String> groupCallsListIds = getStoryListData(listName, List.class);

        for (String groupCallId : groupCallsListIds) {
            final URI configurationURI = new URI(endpointUri);
            final String templateContent = FileUtils.readFileToString(getConfigFile(templatePath + groupCallId + ".json"));
            Response response =
                    getConfigurationItemsWebTarget(configurationURI + GROUP_CALLS_SUB_PATH)
                            .request(MediaType.APPLICATION_JSON)
                            .post(Entity.json(templateContent));

            localStep.details(ExecutionDetails.create("\n" + templateContent + "\nExecuted POST request with payload - on call group calls area ").expected("200 or 201")
                    .received("Status: " + response.getStatus() + "\nMessage: " + response.readEntity(new GenericType<String>() {
                    }))
                    .success(responseWasSuccessful(response)));
        }
    }

    @When("adding $numberOfGroupCalls test group calls to endpoint $endpoint for system $systemName")
    public void addNumberOfGroupCallsWithRest(final Integer numberOfGroupCalls, String endpointUri, final String systemName) throws Throwable {
        ArrayList<String> groupCallsListIds = getStoryListData("defaultGroupCalls", ArrayList.class);

        final String savedGroupCallId = groupCallsListIds.get(0);
        final String templateContent = FileUtils.readFileToString(getConfigFile("/configuration-files/" + systemName + "/GroupCalls/" + savedGroupCallId + ".json"));

        for (int i = 11; i <= numberOfGroupCalls + 10; i++) {
            String groupCallNameReplaced = templateContent.replaceFirst("\"name\" : \".*\"", "\"name\" : \"" + "GroupCallTest" + i + "\"");
            String newUUid = UUID.randomUUID().toString();
            String groupCallToBeSend = groupCallNameReplaced.replaceFirst("\"id\" : \".*\"", "\"id\" : \"" + newUUid + "\"");

            final URI configurationURI = new URI(endpointUri);

            Response response =
                    getConfigurationItemsWebTarget(configurationURI + GROUP_CALLS_SUB_PATH)
                            .request(MediaType.APPLICATION_JSON)
                            .post(Entity.json(groupCallToBeSend));

            evaluate(localStep("Sending group call " + i).details(ExecutionDetails.create("\n" + groupCallToBeSend + "\nExecuted POST request with payload - on group calls area ").expected("200 or 201")
                    .received("Status: " + response.getStatus() + "\nMessage: " + response.readEntity(new GenericType<String>() {
                    }))
                    .success(responseWasSuccessful(response))));
        }
    }

    @Then("add 90 group calls to $endpointUri using configured file found in path $templatePath")
    @Aliases(values = {"replace existing group calls from $endpointUri using an empty group calls file found in path $templatePath",
            "add default group calls to $endpointUri using default group calls file found in path $templatePath"})
    public void add90GroupCalls(final String endpointUri, final String templatePath) throws Throwable {
        final LocalStep localStep = localStep("Execute PUT request with payload");

        final URI configurationURI = new URI(endpointUri);
        final String templateContent = FileUtils.readFileToString(getConfigFile(templatePath + "groupCalls.json"));
        Response response =
                getConfigurationItemsWebTarget(configurationURI + GROUP_CALLS_CONFIGURATION_SUB_PATH)
                        .request(MediaType.APPLICATION_JSON)
                        .put(Entity.json(templateContent));

        localStep.details(ExecutionDetails.create("\n" + templateContent + "\nExecuted PUT request with payload - on call group calls area ").expected("200 or 201")
                .received("Status: " + response.getStatus() + "\nMessage: " + response.readEntity(new GenericType<String>() {
                }))
                .success(responseWasSuccessful(response)));
    }
}
