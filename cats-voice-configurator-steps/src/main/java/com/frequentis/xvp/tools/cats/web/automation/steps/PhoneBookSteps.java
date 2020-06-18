package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.xvp.tools.cats.web.automation.data.PhoneBookEntry;
import com.frequentis.xvp.tools.cats.web.automation.data.ProfileToWebConfigurationReference;
import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.web.GlobalSettingsTelephone.AddUpdatePhoneBookEntry;
import scripts.cats.web.GlobalSettingsTelephone.CheckEntryIsInResultsListAfterSearch;
import scripts.cats.web.GlobalSettingsTelephone.VerifyPhoneBookEntryFields;
import scripts.cats.web.OperatorPositions.VerifyPhoneBookEntryWasCreated;

import java.util.List;

public class PhoneBookSteps extends AutomationSteps {

    private static final String CONFIGURATION_KEY = "config";

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
}
