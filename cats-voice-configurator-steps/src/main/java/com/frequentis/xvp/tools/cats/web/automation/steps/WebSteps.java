package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.PhoneBookEntry;
import com.frequentis.xvp.tools.cats.web.automation.data.ProfileToWebConfigurationReference;
import com.frequentis.xvp.tools.cats.web.automation.data.Role;
import org.glassfish.jersey.client.JerseyClientBuilder;
import org.jbehave.core.annotations.*;
import scripts.cats.web.*;
import scripts.cats.web.GlobalSettingsTelephone.AddUpdatePhoneBookEntry;
import scripts.cats.web.GlobalSettingsTelephone.CheckEntryIsInResultsListAfterSearch;
import scripts.cats.web.GlobalSettingsTelephone.VerifyPhoneBookEntryFields;
import scripts.cats.web.MissionsAndRoles.AddUpdateRole;
import scripts.cats.web.MissionsAndRoles.VerifyRoleFields;
import scripts.cats.web.OperatorPositions.VerifyPhoneBookEntryWasCreated;
import scripts.cats.web.common.leftHandSidePanel.*;
import scripts.cats.web.common.leftHandSidePanel.PressNewButton;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.io.IOException;
import java.net.URI;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

public class WebSteps extends AutomationSteps {
    private static final Integer MAX_NUMBER_ROLES = 50;
    private static final String CONFIGURATION_KEY = "config";
    private static final List<Integer> SUCCESS_RESPONSES = Arrays.asList(200, 201);

    @Given("defined XVP Configurator: $webAppConfig")
    public void givenFollowingSettings(final List<ProfileToWebConfigurationReference> webAppConfiguration) {
        int i = 1;
        for (ProfileToWebConfigurationReference webAppConfig : webAppConfiguration) {
            String info = "WebApplicationConfig: " + i++;
            setStoryData(webAppConfig.getKey(), webAppConfig);
            record(localStep(info).details(ExecutionDetails.create(info).received(webAppConfig.toString())));
        }
    }

    @When("selecting $mainMenuItem item in main menu")
    public void selectMainMenuItem(String mainMenuItem) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Select " + mainMenuItem + " item in main menu")
                    .scriptOn(SelectMainMenuItem.class, profile)
                    .input(SelectMainMenuItem.IPARAM_MAIN_MENU_ITEM_NAME, mainMenuItem));
        }
    }

    @When("selecting $subMenuName sub-menu item")
    public void selectSubMenuItem(String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Select " + subMenuName + " sub-menu item")
                    .scriptOn(SelectSubMenuItem.class, profile)
                    .input(SelectSubMenuItem.IPARAM_SUB_MENU_NAME, subMenuName));
        }
    }

    @When("New button is pressed in $subMenuName sub-menu")
    public void pressNewButton(String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Pressing New button in sub-menu " + subMenuName)
                    .scriptOn(PressNewButton.class, profile)
                    .input(PressNewButton.IPARAM_SUB_MENU_NAME, subMenuName));
        }
    }

    @Then("editor page $subMenuName is visible")
    public void checkSubMenuEditorPageVisibility(String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check " + subMenuName + " editor page is visible")
                    .scriptOn(VerifyEditorPageIsVisible.class, profile)
                    .input(VerifyEditorPageIsVisible.IPARAM_SUB_MENU_NAME, subMenuName));
        }
    }

    @When("add a phonebook entry with: $phonebookEntryDetails")
    @Alias("update a phonebook entry with: $phonebookEntryDetails")
    public void createOrUpdatePhoneBook(final List<PhoneBookEntry> phoneBookEntryDetails) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        PhoneBookEntry phoneBookEntry = phoneBookEntryDetails.get(0);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Adding or updating phonebook")
                    .scriptOn(AddUpdatePhoneBookEntry.class, profile)
                    .input(AddUpdatePhoneBookEntry.IPARAM_FULL_NAME, phoneBookEntry.getFullName())
                    .input(AddUpdatePhoneBookEntry.IPARAM_DISPLAY_NAME, phoneBookEntry.getDisplayName())
                    .input(AddUpdatePhoneBookEntry.IPARAM_LOCATION, phoneBookEntry.getLocation())
                    .input(AddUpdatePhoneBookEntry.IPARAM_ORGANIZATION, phoneBookEntry.getOrganization())
                    .input(AddUpdatePhoneBookEntry.IPARAM_COMMENT, phoneBookEntry.getComment())
                    .input(AddUpdatePhoneBookEntry.IPARAM_DESTINATION, phoneBookEntry.getDestination())
                    .input(AddUpdatePhoneBookEntry.IPARAM_DISPLAY_ADDON, phoneBookEntry.getDisplayAddon()));
        }
    }

    @Then("verify phonebook entry fields contain: $phonebookEntryDetails")
    public void verifyPhoneBookEntryFields(final List<PhoneBookEntry> phoneBookEntryDetails) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        PhoneBookEntry phoneBookEntry = phoneBookEntryDetails.get(0);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Verify phonebook entry fields")
                    .scriptOn(VerifyPhoneBookEntryFields.class, profile)
                    .input(VerifyPhoneBookEntryFields.IPARAM_FULL_NAME, phoneBookEntry.getFullName())
                    .input(VerifyPhoneBookEntryFields.IPARAM_DISPLAY_NAME, phoneBookEntry.getDisplayName())
                    .input(VerifyPhoneBookEntryFields.IPARAM_LOCATION, phoneBookEntry.getLocation())
                    .input(VerifyPhoneBookEntryFields.IPARAM_ORGANIZATION, phoneBookEntry.getOrganization())
                    .input(VerifyPhoneBookEntryFields.IPARAM_COMMENT, phoneBookEntry.getComment())
                    .input(VerifyPhoneBookEntryFields.IPARAM_DESTINATION, phoneBookEntry.getDestination())
                    .input(VerifyPhoneBookEntryFields.IPARAM_DISPLAY_ADDON, phoneBookEntry.getDisplayAddon()));
        }
    }

    @Then("Save button is pressed in $subMenuName editor")
    public void pressSaveButtonInEditorPage(String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Pressing Save button in " + subMenuName)
                    .scriptOn(PressSaveButton.class, profile)
                    .input(PressSaveButton.IPARAM_SUB_MENU_NAME, subMenuName));
        }
    }

    @Then("verifying pop-up displays message: $message")
    public void checkPopUpMessage(String message) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check pop-up displayed message")
                    .scriptOn(VerifyPopUpMessageContent.class, profile)
                    .input(VerifyPopUpMessageContent.IPARAM_POPUP_MESSAGE, message));
        }
    }

    @Then("json file $fileName contains phone book with Display Name $displayName and Destination $destination")
    public void checkFileContainsPhonebookData(String fileName, String displayName, String destination) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check file " + fileName + " contains phonebook " + displayName)
                    .scriptOn(VerifyPhoneBookEntryWasCreated.class, profile)
                    .input(VerifyPhoneBookEntryWasCreated.IPARAM_CONFIGURATION_FILE_NAME, fileName)
                    .input(VerifyPhoneBookEntryWasCreated.IPARAM_DISPLAY_NAME, displayName)
                    .input(VerifyPhoneBookEntryWasCreated.IPARAM_DESTINATION, destination));
        }
    }

    @When("waiting $duration {second|seconds} for LoadingScreen to disappear")
    @Then("waiting $duration {second|seconds} for LoadingScreen to disappear")
    @Aliases(values = {"waiting $duration {second|seconds} for LoadingScreen to disappear",
            "waiting $duration {second|seconds} for Config. Management page to be loaded"})
    public void waitUntilActionTakePlace(@Named("duration") int secs) {
        final LocalStep step = localStep("Wait for " + secs + " seconds");

        try {
            Thread.sleep((int) secs * 1000);
            step.details(
                    ExecutionDetails.create("Wait for " + secs + " seconds").received("Waited").success(true));
        } catch (final Exception ex) {
            step.details(ExecutionDetails.create("Wait for " + secs + " seconds").received("Waited with error")
                    .success(false));
        }
        record(step);
    }

    @Then("configurator management page is visible")
    public void checkConfigManagementVisibility() {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check Configurator Management Home Page is visible")
                    .scriptOn(VerifyConfigManagementPageIsVisible.class, profile));
        }
    }

    @Then("$mainMenuItem menu item contains following sub-menu items: $subMenuItemsList")
    public void checkMainMenuContainsSubMenuItems(String mainMenuItem, String subMenuItemsList) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check sub-menu items of " + mainMenuItem + " are visible")
                    .scriptOn(VerifySubMenuItems.class, profile)
                    .input(VerifySubMenuItems.IPARAM_MAIN_MENU_ITEM_NAME, mainMenuItem)
                    .input(VerifySubMenuItems.IPARAM_SUB_MENU_ITEMS_LIST, subMenuItemsList));
        }
    }

    @Then("sub-menu title is displaying: $subMenuName")
    public void checkDisplayedSubMenuTitle(String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check sub-menu title")
                    .scriptOn(VerifySubMenuTitle.class, profile)
                    .input(VerifySubMenuTitle.IPARAM_SUB_MENU_TITLE, subMenuName));
        }
    }

    @When("writing in $subMenuName search box: $text")
    public void writeInSearchBox(String subMenuName, String text) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Writing " + text + " in " + subMenuName + " Search Box")
                    .scriptOn(WriteInSearchBox.class, profile)
                    .input(WriteInSearchBox.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(WriteInSearchBox.IPARAM_TEXT, text));
        }
    }

    @Then("phonebook entry $entryName is displayed in results list after search")
    public void checkEntryIsInResultsList(String entryName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Checking for " + entryName + " in results list")
                    .scriptOn(CheckEntryIsInResultsListAfterSearch.class, profile)
                    .input(CheckEntryIsInResultsListAfterSearch.IPARAM_ENTRY_NAME, entryName));
        }
    }

    @When("deleting $subMenuName sub-menu item: $itemName")
    public void deleteSubMenuItem(String subMenuName, String itemName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Delete " + subMenuName + " sub menu item: " + itemName)
                    .scriptOn(DeleteItem.class, profile)
                    .input(DeleteItem.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(DeleteItem.IPARAM_ITEM_NAME, itemName));
        }
    }

    @Then("an alert box dialog pops-up with message: $message")
    public void checkAlertBoxDialogMessage(String warningMessage) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check alert box displayed message")
                    .scriptOn(VerifyAlertBoxDialogMessage.class, profile)
                    .input(VerifyAlertBoxDialogMessage.IPARAM_ALERT_BOX_MESSAGE, warningMessage));
        }
    }

    @When("clicking on $buttonName button of $warningType alert box dialog")
    public void clickOnButtonOfAlertBoxDialog(String buttonName, String alertType) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Click on " + buttonName + " button of the alert box dialog")
                    .scriptOn(ClickButtonAlertBoxDialog.class, profile)
                    .input(ClickButtonAlertBoxDialog.IPARAM_BUTTON_NAME, buttonName)
                    .input(ClickButtonAlertBoxDialog.IPARAM_DIALOG_ALERT_TYPE, alertType));
        }
    }

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

    @When("select item $itemName from $subMenuName sub-menu items list")
    public void selectItemFromSubMenuItemsList(String itemName, String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Selecting " + itemName + " from " + subMenuName + " items")
                    .scriptOn(SelectItemFromItemsList.class, profile)
                    .input(SelectItemFromItemsList.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(SelectItemFromItemsList.IPARAM_ITEM_NAME, itemName));
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
                            .received(String.valueOf(obtainedResponse.getStatus()))
                            .success(requestWithSuccess(obtainedResponse))));

            evaluate(localStep("Displaying server's response")
                    .details(ExecutionDetails.create("Response's content is: ")
                            .received(response)
                            .success(requestWithSuccess(obtainedResponse))));

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

    @Then("verifying roles requested response $response contains roles $roles and new added roles")
    public void verifyAddedRolesExistsInResponseMessage(String response, String roles) throws IOException {

        List<String> expectedRolesNames = new LinkedList<>(Arrays.asList(roles.split(",")));

        int numberOfAddedRoles = MAX_NUMBER_ROLES - expectedRolesNames.size();

        for (int i = 1; i <= numberOfAddedRoles; i++) {
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

    @Then("verifying roles requested response $response contains roles $roles and role $newRole")
    public void verifyNewRoleExistsInResponseMessage(String response, String roles, String newRole) throws IOException {

        List<String> expectedRolesNames = new LinkedList<>(Arrays.asList(roles.split(",")));
        expectedRolesNames.add(newRole);

        List<Role> receivedRoles = Arrays.asList(new ObjectMapper().readValue(response, Role[].class));

        List<String> receivedRolesNames = receivedRoles.stream().map(Role::getName).collect(Collectors.toList());

        evaluate(localStep("Verifying issued response contains new added Role")
                .details(ExecutionDetails.create("Verifying Roles names are the same")
                        .received(receivedRolesNames.toString())
                        .expected(expectedRolesNames.toString())
                        .success(receivedRolesNames.containsAll(expectedRolesNames) && receivedRolesNames.size() == expectedRolesNames.size())));
    }

    @Then("verifying phoneBook requested response $response contains roles $roles and new added roles")
    public void verifyAddedRolesExistsInPhonebookResponseMessage(String response, String roles) throws IOException {

        List<String> expectedRolesNames = new LinkedList<>(Arrays.asList(roles.split(",")));

        int numberOfAddedRoles = MAX_NUMBER_ROLES - expectedRolesNames.size();

        for (int i = 1; i <= numberOfAddedRoles; i++) {
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

    @Then("verifying phoneBook requested response $response contains roles $roles and role $neRole")
    public void verifyNewRoleExistsInPhonebookResponseMessage(String response, String roles, String newRole) throws IOException {

        List<String> expectedRolesNames = new LinkedList<>(Arrays.asList(roles.split(",")));
        expectedRolesNames.add(newRole);

        List<PhoneBookEntry> receivedPhonebookEntries = Arrays.asList(new ObjectMapper().readValue(response, PhoneBookEntry[].class));

        List<String> receivedPhonebookEntriesNames = receivedPhonebookEntries.stream().map(PhoneBookEntry::getFullName).collect(Collectors.toList());

        evaluate(localStep("Verifying issued response contains new added Role")
                .details(ExecutionDetails.create("Verifying received response contains Roles")
                        .received(receivedPhonebookEntriesNames.toString())
                        .expected(expectedRolesNames.toString())
                        .success(receivedPhonebookEntriesNames.containsAll(expectedRolesNames))));

    }

    @When("clicking on close button of pop-up message")
    public void clickPopUpCloseButton() {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Pressing pop-up close button ")
                    .scriptOn(ClosePopUpMessage.class, profile));
        }
    }

    @Then("pop-up message is $visibility")
    public void checkPopUpMessageIsVisible(String visibility) {
        boolean isVisible = true;
        if (visibility.contains("not")) {
            isVisible = false;
        }

        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Checking if pop-up message is visible")
                    .scriptOn(VerifyPopUpMessageIsVisible.class, profile)
                    .input(VerifyPopUpMessageIsVisible.IPARAM_VISIBILITY, isVisible));
        }
    }

    @Then("discard changes if discard alert box is visible")
    public void discardChangesIfAlertBoxIsVisible() {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Discard unsaved changes if Alert Box is visible")
                    .scriptOn(CleanupDiscardAlertBox.class, profile));
        }
    }

    @When("clicking on close button of pop-up message if message is visible")
    public void clickCloseButtonPopUpMessageIfVisible() {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Discard unsaved changes if Alert Box is visible")
                    .scriptOn(CleanupPopUpMessage.class, profile));
        }
    }

    @When("deleting item $itemName from $subMenuName sub-menu if visible")
    public void deleteSubMenuItemIfVisible(String itemName, String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Delete " + subMenuName + " sub menu item: " + itemName)
                    .scriptOn(CleanupDeleteAddedItem.class, profile)
                    .input(CleanupDeleteAddedItem.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(CleanupDeleteAddedItem.IPARAM_ITEM_NAME, itemName));
        }
    }

    @Then("click on $mainMenu menu if $subMenu sub-menu is not visible")
    public void clickOnMenuItemIfSubMenuNotVisible(String mainMenuName, String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Click on " + mainMenuName + " if sub menu " + subMenuName + " is not visible")
                    .scriptOn(ClickOnMainMenuIfSubMenuIsNotVisible.class, profile)
                    .input(ClickOnMainMenuIfSubMenuIsNotVisible.IPARAM_MAIN_MENU_NAME, mainMenuName)
                    .input(ClickOnMainMenuIfSubMenuIsNotVisible.IPARAM_SUB_MENU_NAME, subMenuName));
        }
    }

    @Then("warning message $warningMessage is displayed for field $fieldName from $subMenu editor")
    public void checkWarningMessageForASpecificField(String warningMessage, String fieldName, String subMenuName){
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check warning message " + warningMessage + " is displayed for " + fieldName + " field")
                    .scriptOn(VerifyFieldWarningMessage.class, profile)
                    .input(VerifyFieldWarningMessage.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(VerifyFieldWarningMessage.IPARAM_FIELD_NAME, fieldName)
                    .input(VerifyFieldWarningMessage.IPARAM_WARNING_MESSAGE, warningMessage));
        }
    }

    @Then("clear content of $inputFieldName input field from $subMenuName sub menu")
    public void clearInputFieldContent(String inputFieldName, String subMenuName){
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Clear content of the input field " + inputFieldName)
                    .scriptOn(ClearInputFieldContent.class, profile)
                    .input(ClearInputFieldContent.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(ClearInputFieldContent.IPARAM_FIELD_NAME, inputFieldName));
        }
    }

    private WebTarget getConfigurationItemsWebTarget(final String uri) {
        final JerseyClientBuilder clientBuilder = ignoreCerts();
        return clientBuilder.build().target(uri);
    }

    private JerseyClientBuilder ignoreCerts() {
        final TrustManager[] certs = new TrustManager[]{new X509TrustManager() {
            @Override
            public X509Certificate[] getAcceptedIssuers() {
                return null;
            }


            @Override
            public void checkServerTrusted(final X509Certificate[] chain, final String authType)
                    throws CertificateException {
            }


            @Override
            public void checkClientTrusted(final X509Certificate[] chain, final String authType)
                    throws CertificateException {
            }
        }};

        SSLContext ctx = null;
        try {
            ctx = SSLContext.getInstance("TLS");
            ctx.init(null, certs, new SecureRandom());
        } catch (final java.security.GeneralSecurityException e) {
            System.out.println("" + e);
        }

        HttpsURLConnection.setDefaultSSLSocketFactory(ctx.getSocketFactory());

        final JerseyClientBuilder clientBuilder = new JerseyClientBuilder();
        try {
            clientBuilder.sslContext(ctx);
            clientBuilder.hostnameVerifier((hostname, session) -> true);
        } catch (final Exception e) {
            System.out.println("" + e);
        }
        return clientBuilder;
    }

    private boolean requestWithSuccess(final Response response) {
        return SUCCESS_RESPONSES.contains(response.getStatus());
    }
}
