package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.ProfileToWebConfigurationReference;
import org.jbehave.core.annotations.*;
import scripts.cats.web.GlobalSettingsTelephone.AddPhoneBookEntry;
import scripts.cats.web.GlobalSettingsTelephone.VerifyPhoneBookTitleIsVisible;
import scripts.cats.web.*;
import scripts.cats.web.OperatorPositions.VerifyPhoneBookEntryWasCreated;

import java.util.List;

public class WebSteps extends AutomationSteps {

    @Given("defined XVP Configurator pages: $webAppConfigs")
    public void givenFollowingSettings(final List<ProfileToWebConfigurationReference> webAppConfigs) {
        int i = 1;
        for (ProfileToWebConfigurationReference webAppConfig : webAppConfigs) {
            String info = "WebApplicationConfig: " + i++;
            setStoryData(webAppConfig.getKey(), webAppConfig);
            record(localStep(info).details(ExecutionDetails.create(info).received(webAppConfig.toString())));
        }
    }

    @Then("add a new configuration")
    public void addNewConfiguration() {
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Add a new configuration")
                    .scriptOn(OpenNewConfigurationBoxWebDriver.class, profile));

        }
    }

    @When("configurator $configuratorName is selected")
    public void selectConfigurator(String configuratorName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Select " + configuratorName + " configurator")
                    .scriptOn(SelectConfigurator.class, profile)
                    .input(SelectConfigurator.IPARAM_CONFIG_NAME, configuratorName));
        }
    }

    @When("sub-configurator $subConfiguratorName is selected")
    public void selectSubConfigurator(String subConfiguratorName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Select " + subConfiguratorName + " sub-configurator")
                    .scriptOn(SelectSubConfigurator.class, profile)
                    .input(SelectSubConfigurator.IPARAM_SUBCONFIG_NAME, subConfiguratorName));
        }
    }

    @When("new button is pressed")
    public void pressNewButton() {
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Pressing New button")
                    .scriptOn(PressNewButton.class, profile));
        }
    }

    @Then("a new phonebook is created with Full Name $fullName, Display Name $displayName and Destination $destination")
    public void writeNewPhonebookRequiredFieldsData(String fullName, String displayName, String destination) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Creating new PhoneBook")
                    .scriptOn(AddPhoneBookEntry.class, profile)
                    .input(AddPhoneBookEntry.IPARAM_FULL_NAME, fullName)
                    .input(AddPhoneBookEntry.IPARAM_DISPLAY_NAME, displayName)
                    .input(AddPhoneBookEntry.IPARAM_DESTINATION, destination));
        }
    }

    @Then("json file $fileName contains phone book with Display Name $displayName and Destination $destination")
    public void checkFileContainsPhonebookData(String fileName, String displayName, String destination) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check json file " + fileName + " contains phonebook " + displayName)
                    .scriptOn(VerifyPhoneBookEntryWasCreated.class, profile)
                    .input(VerifyPhoneBookEntryWasCreated.IPARAM_FILE_NAME, fileName)
                    .input(VerifyPhoneBookEntryWasCreated.IPARAM_DISPLAY_NAME, displayName)
                    .input(VerifyPhoneBookEntryWasCreated.IPARAM_DESTINATION, destination));
        }
    }

    @When("wait $duration {second|seconds} for LoadingScreen to disappear")
    @Then("wait $duration {second|seconds} for LoadingScreen to disappear")
    @Aliases(values = {"wait $duration {second|seconds} for LoadingScreen to disappear",
            "wait $duration {second|seconds} for Config. Management page to be loaded"})
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
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check Configurator Management Home Page is visible")
                    .scriptOn(VerifyConfigManagementPageIsVisible.class, profile));
        }
    }

    @Then("$configuratorName sub-configurators are visible")
    public void checkSubConfiguratorsAreVisible(String configuratorName) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check " + configuratorName + " sub-configurators are visible")
                    .scriptOn(VerifySubConfiguratorsAreVisible.class, profile)
                    .input(VerifySubConfiguratorsAreVisible.IPARAM_CONFIGURATOR_NAME, configuratorName));
        }
    }

    @Then("Phone Book tree title is visible")
    public void chechPhoneBookTreeTitle() {
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Check Phonebook right hand side panel title")
                    .scriptOn(VerifyPhoneBookTitleIsVisible.class, profile));
        }
    }

    @When("write in search box $text")
    public void writeSearchBox(String text) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Writing " + text + " in Search Box")
                    .scriptOn(VerifyPhoneBookTitleIsVisible.class, profile)
                    .input(WriteInSearchBox.IPARAM_SEARCHED_ENTRY, text));
        }
    }

    @Then("phonebook entry $entryName is displayed in results list")
    public void checkEntryIsInResultsList(String entryName){
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Writing " + text + " in Search Box")
                    .scriptOn(CheckEntryInResultsList.class, profile)
                    .input(CheckEntryInResultsList.IPARAM_ENTRY_NAME, text));
        }
    }
}
