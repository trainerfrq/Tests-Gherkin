package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.PhoneBookEntry;
import com.frequentis.xvp.tools.cats.web.automation.data.ProfileToWebConfigurationReference;
import com.frequentis.xvp.tools.cats.web.automation.data.Role;
import org.jbehave.core.annotations.*;
import scripts.cats.web.*;
import scripts.cats.web.GlobalSettingsTelephone.AddUpdatePhoneBookEntry;
import scripts.cats.web.GlobalSettingsTelephone.CheckEntryIsInResultsListAfterSearch;
import scripts.cats.web.GlobalSettingsTelephone.VerifyPhoneBookEntryFields;
import scripts.cats.web.MissionsAndRoles.AddUpdateRole;
import scripts.cats.web.MissionsAndRoles.VerifyRoleFields;
import scripts.cats.web.OperatorPositions.VerifyPhoneBookEntryWasCreated;
import scripts.cats.web.common.leftHandSidePanel.*;

import java.util.List;

public class WebSteps extends AutomationSteps {
    private static final String CONFIGURATION_KEY = "config";

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
                    .scriptOn(VerifyPopUpMessage.class, profile)
                    .input(VerifyPopUpMessage.IPARAM_POPUP_MESSAGE, message));
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

    @When("deleting $subMenuName sub-menu entry: $entryName")
    public void deletePhonebookEntry(String subMenuName, String entryName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Delete phonebook entry " + entryName)
                    .scriptOn(DeleteItem.class, profile)
                    .input(DeleteItem.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(DeleteItem.IPARAM_ENTRY_NAME, entryName));
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
                    .input(VerifyRoleFields.IPARAM_DEFAULT_SOURCE_OUTGOING_CALLS, role.getDefaultSourceOutgoingCalls())
                    .input(VerifyRoleFields.IPARAM_DEFAULT_SIP_PRIORITY, role.getDefaultSipPriority()));
        }
    }

    @Then("role $roleName is displayed in $subMenuName list")
    public void checkRoleIsInRolesList(String roleName, String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Checking for " + roleName + " in results list")
                    .scriptOn(VerifyItemInItemsList.class, profile)
                    .input(VerifyItemInItemsList.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(VerifyItemInItemsList.IPARAM_ITEM_NAME, roleName));
        }
    }

    @When("select item $itemName from $subMenuName sub-menu items list")
    public void selectItemFromSubMenuItemsList(String itemName, String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Selecting " + itemName + " from " + subMenuName + " items")
                    .scriptOn(VerifyItemInItemsList.class, profile)
                    .input(VerifyItemInItemsList.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(VerifyItemInItemsList.IPARAM_ITEM_NAME, itemName));
        }
    }
}
