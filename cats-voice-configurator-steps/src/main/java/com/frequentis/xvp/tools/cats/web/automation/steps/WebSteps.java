package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.CallRouteSelectorsEntry;
import com.frequentis.xvp.tools.cats.web.automation.data.ProfileToWebConfigurationReference;
import org.jbehave.core.annotations.*;
import scripts.cats.web.*;
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

    @Then("press Save button when no changes were done")
    public void pressSaveButtonWithoutDoingChanges() {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Pressing Save button")
                    .scriptOn(PressSaveButtonWhenNoChangesDone.class, profile));
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

    @Then("list size for $subMenuName is: $size")
    public void subMenuListSize(String subMenuName, Integer size) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Sub menu list size is " + size)
                    .scriptOn(VerifyListSize.class, profile)
                    .input(VerifyListSize.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(VerifyListSize.IPARAM_SUB_MENU_LIST_SIZE, size));
        }
    }

    @Then("in $subMenuName list scroll until name of entry <key> is visible")
    public void subMenuListScrollUntilItemVisibleExamples(String subMenuName, @Named("key") final String entry) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        CallRouteSelectorsEntry callRouteEntry = getStoryListData(entry, CallRouteSelectorsEntry.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Sub menu list item is scrolled ")
                    .scriptOn(ScrollElementListIntoView.class, profile)
                    .input(ScrollElementListIntoView.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(ScrollElementListIntoView.IPARAM_ENTRY_NAME, callRouteEntry.getFullName()));
        }
    }

    @Then("in $subMenuName list scroll until item $name is visible")
    public void subMenuListScrollUntilItemVisible(String subMenuName, String name) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Sub menu list item is scrolled ")
                    .scriptOn(ScrollElementListIntoView.class, profile)
                    .input(ScrollElementListIntoView.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(ScrollElementListIntoView.IPARAM_ENTRY_NAME, name));
        }
    }

    @Then("in $subMenuName list verify that last item has name from entry <key>")
    public void subMenuLastItemListExamples(String subMenuName, @Named("key") final String entry) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        CallRouteSelectorsEntry callRouteEntry = getStoryListData(entry, CallRouteSelectorsEntry.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("verify last item in list is " + callRouteEntry.getFullName())
                    .scriptOn(VerifyLastItemInList.class, profile)
                    .input(VerifyLastItemInList.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(VerifyLastItemInList.IPARAM_ENTRY_NAME, callRouteEntry.getFullName()));
        }
    }

    @Then("in $subMenuName list verify that last item is $name")
    public void subMenuLastItemList(String subMenuName, String name) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("verify last item in list is " + name)
                    .scriptOn(VerifyLastItemInList.class, profile)
                    .input(VerifyLastItemInList.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(VerifyLastItemInList.IPARAM_ENTRY_NAME, name));
        }
    }

    @Then("in $subMenuName list verify that items are in the following order: $entriesList")
    public void subMenuVerifyOrderList(String subMenuName, String entriesList) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("verify items " + entriesList + " are in the correct order")
                    .scriptOn(VerifyListItemsOrder.class, profile)
                    .input(VerifyListItemsOrder.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(VerifyListItemsOrder.IPARAM_ENTRIES_LIST, entriesList));
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

    @When("selecting $subMenuName sub-menu entry: $entryName")
    public void selectItemList(String subMenuName, String entryName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Select entry " + entryName)
                    .scriptOn(SelectItem.class, profile)
                    .input(SelectItem.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(SelectItem.IPARAM_ENTRY_NAME, entryName));
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

    @When("select item $itemName from $subMenuName sub-menu items list")
    public void selectItemFromSubMenuItemsList(String itemName, String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Selecting " + itemName + " from " + subMenuName + " items")
                    .scriptOn(SelectItemByName.class, profile)
                    .input(SelectItemByName.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(SelectItemByName.IPARAM_ITEM_NAME, itemName));
        }
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
                    .scriptOn(CleanupItem.class, profile)
                    .input(CleanupItem.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(CleanupItem.IPARAM_ITEM_NAME, itemName));
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
    public void checkWarningMessageForASpecificField(String warningMessage, String fieldName, String subMenuName) {
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
    public void clearInputFieldContent(String inputFieldName, String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Clear content of the input field " + inputFieldName)
                    .scriptOn(ClearInputFieldContent.class, profile)
                    .input(ClearInputFieldContent.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(ClearInputFieldContent.IPARAM_FIELD_NAME, inputFieldName));
        }
    }

    @When("in $subMenuName move item from position $from to position $to")
    public void deletePhonebookEntry(String subMenuName, Integer from, Integer to) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Drag and drop ")
                    .scriptOn(DragAndDropItemInList.class, profile)
                    .input(DragAndDropItemInList.IPARAM_SUB_MENU_NAME, subMenuName)
                    .input(DragAndDropItemInList.IPARAM_FROM_POSITION, from)
                    .input(DragAndDropItemInList.IPARAM_TO_POSITION, to));
        }
    }

    @Then("refresh Configurator")
    public void refreshConfigurator() {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Refresh Configurator ")
                    .scriptOn(RefreshPage.class, profile));
        }
    }

    @Then("delete last $numberOfCharacters characters from input field $inputFieldName of $subMenuName sub menu")
    public void deleteCharactersFromInputField(Integer numberOfCharacters, String inputFieldName, String subMenuName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Clear content of the input field " + inputFieldName)
                    .scriptOn(DeleteLastCharactersOfInputField.class, profile)
                    .input(DeleteLastCharactersOfInputField.IPARAM_NUMBER_OF_CHARACTERS, numberOfCharacters)
                    .input(DeleteLastCharactersOfInputField.IPARAM_FIELD_NAME, inputFieldName)
                    .input(DeleteLastCharactersOfInputField.IPARAM_SUB_MENU_NAME, subMenuName));
        }
    }
}
