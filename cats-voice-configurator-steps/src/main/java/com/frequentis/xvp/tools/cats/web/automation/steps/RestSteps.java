package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.CallRouteSelectorsEntry;
import com.frequentis.xvp.tools.cats.web.automation.data.Mission;
import com.frequentis.xvp.tools.cats.web.automation.data.Role;
import com.frequentis.xvp.voice.common.gson.GsonFactory;
import com.frequentis.xvp.voice.opvoice.config.JsonCallRouteSelectorDataElement;
import com.frequentis.xvp.voice.opvoice.config.JsonMissionData;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import org.apache.commons.io.FileUtils;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;

import javax.ws.rs.client.Entity;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import static com.frequentis.xvp.tools.cats.web.automation.steps.UtilSteps.*;


public class RestSteps extends AutomationSteps {
    private static final String CALL_ROUTE_SELECTORS_SUB_PATH = "/op-voice-service/callRouteSelectors";
    private static final String CALL_ROUTE_SELECTORS_ORDER_SUB_PATH = "/op-voice-service/callRouteSelectors/order";
    private static final String MISSIONS_SUB_PATH = "/op-voice-service/missions";
    private static final String MISSIONS_DIAGNOSTIC_SUB_PATH = "/op-voice-service/generic/items/missions.json";
    private static final String MISSIONS_CONFIGURATION_SUB_PATH = "/op-voice-service/generic/items/missionconfiguration%2F";
    private static final String ROLES_SUB_PATH = "/op-voice-service/roles";
    private static final String ROLES_CONFIGURATION_SUB_PATH = "/op-voice-service/generic/items/roleconfiguration%2F";


    @Then("using $endpointUri verify that call route selectors order sent to the Op Voice service as in the below table:$callRouteEntries")
    public void getCallRouteSelectorsOrderInMissionJson(final String endpointUri, final List<CallRouteSelectorsEntry> callRouteEntries) throws IOException {
        final LocalStep localStep = localStep("Execute GET request - Call Route selectors");
        localStep.details(ExecutionDetails.create("Get call route selectors from: " + endpointUri + MISSIONS_DIAGNOSTIC_SUB_PATH).success());

        Response response =
                getConfigurationItemsWebTarget(endpointUri + MISSIONS_DIAGNOSTIC_SUB_PATH)
                        .request(MediaType.APPLICATION_JSON)
                        .get();

        String responseContent = response.readEntity(new GenericType<String>() {
        });

        localStep.details(ExecutionDetails.create("Executed GET request").expected("200 or 201")
                .received("Status: " + response.getStatus() + "\nMessage: " + responseContent)
                .success(responseWasSuccessful(response)));

        final Gson gson = GsonFactory.createInstance();
        final JsonMissionData[] jsonMissionData = gson.fromJson(reader(responseContent), JsonMissionData[].class);

        //is enough to verify call route selectors used for the first mission, as is the same for all missions
        final List<JsonCallRouteSelectorDataElement> jsonCallRouteSelectorDataElements = jsonMissionData[0].getMissionAssignedCallRouteSelectors();
        List<String> receivedCallRouteSelectorsNames = new ArrayList<>();
        List<String> expectedCallRouteSelectorsNames = new ArrayList<>();
        for (JsonCallRouteSelectorDataElement jsonCallRouteSelectorDataElement : jsonCallRouteSelectorDataElements) {
            String receivedName = jsonCallRouteSelectorDataElement.getName();
            receivedCallRouteSelectorsNames.add(receivedName);
        }
        for (CallRouteSelectorsEntry callRouteSelectorsEntry : callRouteEntries) {
            String expectedName = callRouteSelectorsEntry.getDisplayName();
            expectedCallRouteSelectorsNames.add(expectedName);
        }
        localStep.details(ExecutionDetails.create("Verify call route selectors order sent to Op voice service")
                .expected(expectedCallRouteSelectorsNames.toString())
                .received(receivedCallRouteSelectorsNames.toString())
                .success(expectedCallRouteSelectorsNames.equals(receivedCallRouteSelectorsNames)));
    }

    @Given("the call route selectors ids for configurator $endpointUri are saved in list $listName")
    public void saveDefaultCallRouteSelectorIds(final String endpointUri, final String listName) throws IOException {
        final LocalStep localStep = localStep("Execute GET request - save default call route selectors ids");

        Response response =
                getConfigurationItemsWebTarget(endpointUri + CALL_ROUTE_SELECTORS_SUB_PATH)
                        .request(MediaType.APPLICATION_JSON)
                        .get();

        String responseContent = response.readEntity(new GenericType<String>() {
        });

        localStep.details(ExecutionDetails.create("Executed GET request").expected("200 or 201")
                .received("Status: " + response.getStatus() + "\nMessage: " + responseContent)
                .success(responseWasSuccessful(response)));

        final JsonParser jsonParser = new JsonParser();
        final JsonArray jsonResponse = (JsonArray) jsonParser.parse(responseContent);
        List<String> callRouteSelectorListIds = new ArrayList<>();
        for (JsonElement jsonElement : jsonResponse) {
            Gson jsonSerializer = new Gson();
            CallRouteSelectorsEntry output = jsonSerializer.fromJson(jsonElement.toString(), CallRouteSelectorsEntry.class);
            String receivedId = output.getId();
            callRouteSelectorListIds.add(receivedId);
        }
        setStoryListData(listName, new ArrayList<>(callRouteSelectorListIds));

    }

    @Then("using $endpointUri delete call route selectors with ids in list $listName except item with $id")
    public void deleteCallRouteSelector(final String endpointUri, final String listName, final String id) throws Throwable {
        final LocalStep localStep = localStep("Execute DELETE request - delete default call route selectors except one");
        List<String> callRouteSelectorListIds = getStoryListData(listName, List.class);

        callRouteSelectorListIds.stream().filter(callRouteSelectorId -> !callRouteSelectorId.equals(id)).forEach(callRouteSelectorId -> {
            Response deleteResponse =
                    getConfigurationItemsWebTarget(endpointUri + CALL_ROUTE_SELECTORS_SUB_PATH)
                            .path(callRouteSelectorId)
                            .request(MediaType.APPLICATION_JSON)
                            .delete();
            localStep.details(ExecutionDetails.create("Executed DELETE request - on call route selectors list").expected("200 or 201")
                    .received("Status: " + deleteResponse.getStatus() + "\nMessage: " + deleteResponse.readEntity(new GenericType<String>() {
                    }))
                    .success(responseWasSuccessful(deleteResponse)));
        });
    }

    @Then("add call route selectors to $endpointUri using configurators with ids from list $listName found in path $templatePath")
    public void addDefaultCallRouteSelectors(final String endpointUri, final String listName, final String templatePath) throws Throwable {
        final LocalStep localStep = localStep("Execute POST request with payload");
        List<String> callRouteSelectorListIds = getStoryListData(listName, List.class);

        for (String callRouteSelectorId : callRouteSelectorListIds) {
            final URI configurationURI = new URI(endpointUri);
            final String templateContent = FileUtils.readFileToString(getConfigFile(templatePath + callRouteSelectorId + ".json"));
            Response response =
                    getConfigurationItemsWebTarget(configurationURI + CALL_ROUTE_SELECTORS_SUB_PATH)
                            .request(MediaType.APPLICATION_JSON)
                            .post(Entity.json(templateContent));
            //this get on the Call Route Selectors order is acting as a refresh on the list. If is missing the call route selectors wil be added, but not in the order from list callRouteSelectorListIds
            Response responseCallRouteSelectorsOrder =
                    getConfigurationItemsWebTarget(configurationURI + CALL_ROUTE_SELECTORS_ORDER_SUB_PATH)
                            .request(MediaType.APPLICATION_JSON)
                            .get();

            localStep.details(ExecutionDetails.create("Executed POST request with payload - on call route selectors area ").expected("200 or 201")
                    .received("Status: " + response.getStatus() + "\nMessage: " + response.readEntity(new GenericType<String>() {
                    }))
                    .success(responseWasSuccessful(response)));
        }
    }

    @Given("the roles ids for configurator $endpointUri are saved in list $listName")
    public void saveDefaultRolesIds(final String endpointUri, final String listName) throws IOException {
        final LocalStep localStep = localStep("Execute GET request - save default roles' ids");

        Response response =
                getConfigurationItemsWebTarget(endpointUri + ROLES_SUB_PATH)
                        .request(MediaType.APPLICATION_JSON)
                        .get();
        String responseContent = response.readEntity(new GenericType<String>() {
        });

        localStep.details(ExecutionDetails.create("Executed GET request").expected("200 or 201")
                .received("Status: " + response.getStatus() + "\nMessage: " + responseContent)
                .success(responseWasSuccessful(response)));


        List<Role> receivedRoles = Arrays.asList(new ObjectMapper().readValue(responseContent, Role[].class));

        ArrayList<String> rolesIds = new ArrayList<>();

        for (Role role : receivedRoles) {
            evaluate(localStep("Save role id")
                    .details(ExecutionDetails.create("Save role id")
                            .received("Role " + role.getName() + " with id: " + role.getId())
                            .success(true)));
            rolesIds.add(role.getId());
        }

        setStoryListData(listName, rolesIds);
    }

    @Then("add roles to $endpointUri using configurators with ids from lists $listName found in path $templatePath")
    public void addDefaultRoles(final String endpointUri, final String listName, final String templatePath) throws Throwable {
        URI configurationURI = new URI(endpointUri);
        String templateContent;
        Response response;
        final LocalStep localStep = localStep("Execute PUT/POST request with payload");

        ArrayList<String> rolesListIds = getStoryListData(listName, ArrayList.class);

        for (int i = 0; i < rolesListIds.size(); i++) {
            if (i == rolesListIds.size() - 1) {
                configurationURI = new URI(endpointUri);


                templateContent = FileUtils.readFileToString(getConfigFile(templatePath + rolesListIds.get(i) + ".json"));
                localStep.details(ExecutionDetails.create("See path: " + templatePath + rolesListIds.get(i) + ".json").expected("200 or 201")
                        .received(templateContent).success(true));
                response =
                        getConfigurationItemsWebTarget(configurationURI + ROLES_SUB_PATH)
                                .request(MediaType.APPLICATION_JSON)
                                .post(Entity.json(templateContent));

                localStep.details(ExecutionDetails.create("Executed POST request with payload - on Roles area, using role id: " + rolesListIds.get(i)).expected("200 or 201")
                        .received("Status: " + response.getStatus() + "\nMessage: " + response.readEntity(new GenericType<String>() {
                        })).success(responseWasSuccessful(response)));
                continue;
            }
            configurationURI = new URI(endpointUri);

            templateContent = FileUtils.readFileToString(getConfigFile(templatePath + rolesListIds.get(i) + ".json"));
            response =
                    getConfigurationItemsWebTarget(configurationURI + ROLES_CONFIGURATION_SUB_PATH + rolesListIds.get(i) + ".json")
                            .request(MediaType.APPLICATION_JSON)
                            .put(Entity.json(templateContent));

            localStep.details(ExecutionDetails.create("Executed PUT request with payload - on Roles area, using role id: " + rolesListIds.get(i)).expected("200 or 201")
                    .received("Status: " + response.getStatus() + "\nMessage: " + response.readEntity(new GenericType<String>() {
                    }))
                    .success(responseWasSuccessful(response)));
        }
    }

    @Given("the missions ids for configurator $endpointUri are saved in list $listName")
    public void saveDefaultMissionsIds(final String endpointUri, final String listName) throws IOException {
        final LocalStep localStep = localStep("Execute GET request - save default missions' ids");

        Response response =
                getConfigurationItemsWebTarget(endpointUri + MISSIONS_SUB_PATH)
                        .request(MediaType.APPLICATION_JSON)
                        .get();

        String responseContent = response.readEntity(new GenericType<String>() {
        });

        localStep.details(ExecutionDetails.create("Executed GET request").expected("200 or 201")
                .received("Status: " + response.getStatus() + "\nMessage: " + responseContent)
                .success(responseWasSuccessful(response)));


        List<Mission> receivedMissions = Arrays.asList(new ObjectMapper().readValue(responseContent, Mission[].class));

        ArrayList<String> missionsIds = new ArrayList<>();

        for (Mission mission : receivedMissions) {
            evaluate(localStep("Save mission id")
                    .details(ExecutionDetails.create("Save mission id")
                            .received("Mission " + mission.getName() + " with id: " + mission.getId())
                            .success(true)));
            missionsIds.add(mission.getId());
        }

        setStoryListData(listName, missionsIds);
    }

    @Then("using $endpointUri delete roles with ids from list $listName")
    public void deleteRoles(final String endpointUri, final String listName) throws Throwable {
        final LocalStep localStep = localStep("Execute DELETE request - delete default Roles");

        ArrayList<String> rolesListIds = getStoryListData(listName, ArrayList.class);

        for (String roleId : rolesListIds) {
            final URI configurationURI = new URI(endpointUri);

            Response deleteResponse =
                    getConfigurationItemsWebTarget(configurationURI + ROLES_SUB_PATH)
                            .path(roleId)
                            .request(MediaType.APPLICATION_JSON)
                            .delete();
            localStep.details(ExecutionDetails.create("Executed DELETE request - on role with id: " + roleId).expected("200 or 201")
                    .received("Status: " + deleteResponse.getStatus() + "\nMessage: " + deleteResponse.readEntity(new GenericType<String>() {
                    }))
                    .success(responseWasSuccessful(deleteResponse)));
        }
    }

    @When("adding $number test roles to endpoint $endpoint for system $systemName")
    public void addNumberOfRolesWithRest(final Integer numberOfRoles, String endpointUri, final String systemName) throws Throwable {
        ArrayList<String> rolesListIds = getStoryListData("defaultRoles", ArrayList.class);

        final String savedRoleId = rolesListIds.get(0);
        final String templateContent = FileUtils.readFileToString(getConfigFile("/configuration-files/" + systemName + "/Roles_default/roleconfiguration/" + savedRoleId + ".json"));


        for (int i = 11; i <= numberOfRoles + 10; i++) {
            String roleNameReplaced = templateContent.replaceFirst("\"name\" : \".*\"", "\"name\" : \"" + "RoleTest" + i + "\"");
            String newUUid = UUID.randomUUID().toString();
            String roleToBeSend = roleNameReplaced.replaceFirst("\"id\" : \".*\"", "\"id\" : \"" + newUUid + "\"");

            final URI configurationURI = new URI(endpointUri);

            Response response =
                    getConfigurationItemsWebTarget(configurationURI + ROLES_CONFIGURATION_SUB_PATH + newUUid + ".json")
                            .request(MediaType.APPLICATION_JSON)
                            .put(Entity.json(roleToBeSend));

            evaluate(localStep("Sending role " + i).details(ExecutionDetails.create("Executed POST request with payload - on call route selectors area ").expected("200 or 201")
                    .received("Status: " + response.getStatus() + "\nMessage: " + response.readEntity(new GenericType<String>() {
                    }))
                    .success(responseWasSuccessful(response))));
        }

    }

    @Then("add missions to $endpointUri using configurators with ids from lists $listName found in path $templatePath")
    public void addDefaultMissions(final String endpointUri, final String listName, final String templatePath) throws Throwable {
        final LocalStep localStep = localStep("Execute PUT request with payload");

        ArrayList<String> missionsListIds = getStoryListData(listName, ArrayList.class);

        for (String missionId : missionsListIds) {
            final URI configurationURI = new URI(endpointUri);

            final String templateContent = FileUtils.readFileToString(getConfigFile(templatePath + missionId + ".json"));
            Response response =
                    getConfigurationItemsWebTarget(configurationURI + MISSIONS_CONFIGURATION_SUB_PATH + missionId + ".json")
                            .request(MediaType.APPLICATION_JSON)
                            .put(Entity.json(templateContent));

            localStep.details(ExecutionDetails.create("Executed PUT request with payload - on missions, using id " + missionId).expected("200 or 201")
                    .received("Status: " + response.getStatus() + "\nMessage: " + response.readEntity(new GenericType<String>() {
                    }))
                    .success(responseWasSuccessful(response)));
        }
    }

    @When("issuing http GET request to endpoint $endpointUri and path $resourcePath")
    public String issueGetRequest(final String endpointUri, final String resourcePath) throws Throwable {

        if (endpointUri != null) {
            final URI configurationURI = new URI(endpointUri);

            Response obtainedResponse =
                    getConfigurationItemsWebTarget(configurationURI + resourcePath).request(MediaType.APPLICATION_JSON).get();

            String response = obtainedResponse.readEntity(new GenericType<String>() {
            });

            evaluate(localStep("Execute GET request")
                    .details(ExecutionDetails.create("Check Response status")
                            .expected("200 or 201")
                            .received("Status: " + obtainedResponse.getStatus() + "\nMessage: " + response)
                            .success(responseWasSuccessful(obtainedResponse))));

            evaluate(localStep("Displaying server's response")
                    .details(ExecutionDetails.create("Response's content is: ")
                            .received(response)
                            .success(responseWasSuccessful(obtainedResponse))));

            return response;

        } else {
            evaluate(localStep("Execute GET request")
                    .details(ExecutionDetails.create("Executed GET request! ")
                            .expected("Success")
                            .received("Endpoint is not present", endpointUri != null)
                            .failure()));
            return null;
        }
    }
}
