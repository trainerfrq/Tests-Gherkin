package com.frequentis.xvp.tools.cats.web.automation.steps;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.bdd.fluent.step.local.LocalStep;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.tools.cats.web.automation.data.CallRouteSelectorsEntry;
import com.frequentis.xvp.tools.cats.web.automation.data.ProfileToWebConfigurationReference;
import org.jbehave.core.annotations.*;
import scripts.cats.web.GlobalSettingsTelephone.AddUpdateCallRouteSelectorsEntry;
import scripts.cats.web.GlobalSettingsTelephone.VerifyCallRouteSelectorsEntryFields;

import java.util.List;

public class CallRouteSelectorsSteps extends AutomationSteps {

    private static final String CONFIGURATION_KEY = "config";

    @Given("the following call route selectors entries: $callRouteSelectorsEntries")
    public void namedCallRouteSelectors( final List<CallRouteSelectorsEntry> callRouteSelectorsEntries )
    {
        final LocalStep localStep = localStep( "Define the phone book entries" );
        for ( final CallRouteSelectorsEntry callRouteSelectorsEntry : callRouteSelectorsEntries )
        {
            final String key = callRouteSelectorsEntry.getKey();
            setStoryListData( key, callRouteSelectorsEntry );
            localStep
                    .details( ExecutionDetails.create( "Define call route selectors entries" ).usedData( key, callRouteSelectorsEntry ) );
        }

        record( localStep );
    }

    @When("the values are added in the call route selector editor using entry with <key>")
    @Alias("update values for the call route selector entry with <key>")
    public void createOrUpdateCallRouteSelectorsExamples(@Named("key") final String entry) {
        CallRouteSelectorsEntry callRouteEntry = getStoryListData(entry, CallRouteSelectorsEntry.class);
        createOrUpdateCallRouteSelectors(callRouteEntry);
    }

    @Then("call route selector editor was filled in with the expected values from entry with <key>")
    @Alias("call route selector contains the expected values from entry with <key>")
    public void verifyCallRouteSelectorsExamples(@Named("key") final String entry) {
        CallRouteSelectorsEntry callRouteEntry = getStoryListData(entry, CallRouteSelectorsEntry.class);
        verifyCallRouteSelectors(callRouteEntry);
    }

    @When("call route selector editor is filled in with the following values: $callRouteEntry")
    @Alias("update the call route selector entry following values: $callRouteEntry")
    public void createOrUpdateCallRouteSelectors(final CallRouteSelectorsEntry callRouteEntry) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);

        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Adding or updating call route selector")
                    .scriptOn(AddUpdateCallRouteSelectorsEntry.class, profile)
                    .input(AddUpdateCallRouteSelectorsEntry.IPARAM_FULL_NAME, callRouteEntry.getFullName())
                    .input(AddUpdateCallRouteSelectorsEntry.IPARAM_DISPLAY_NAME, callRouteEntry.getDisplayName())
                    .input(AddUpdateCallRouteSelectorsEntry.IPARAM_COMMENT, callRouteEntry.getComment())
                    .input(AddUpdateCallRouteSelectorsEntry.IPARAM_SIP_PREFIX, callRouteEntry.getSipPrefix())
                    .input(AddUpdateCallRouteSelectorsEntry.IPARAM_SIP_POSTFIX, callRouteEntry.getSipPostfix())
                    .input(AddUpdateCallRouteSelectorsEntry.IPARAM_SIP_DOMAIN, callRouteEntry.getSipDomain())
                    .input(AddUpdateCallRouteSelectorsEntry.IPARAM_SIP_PORT, callRouteEntry.getSipPort()));
        }
    }

    @Then("call route selector editor was filled in with the following expected values: $callRouteEntry")
    @Alias("call route selector contains the following expected values: $callRouteEntry")
    public void verifyCallRouteSelectors(final CallRouteSelectorsEntry callRouteEntry) {
        ProfileToWebConfigurationReference webAppConfig = getStoryData(CONFIGURATION_KEY, ProfileToWebConfigurationReference.class);

        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Verify call route selector fields")
                    .scriptOn(VerifyCallRouteSelectorsEntryFields.class, profile)
                    .input(VerifyCallRouteSelectorsEntryFields.IPARAM_FULL_NAME, callRouteEntry.getFullName())
                    .input(VerifyCallRouteSelectorsEntryFields.IPARAM_DISPLAY_NAME, callRouteEntry.getDisplayName())
                    .input(VerifyCallRouteSelectorsEntryFields.IPARAM_COMMENT, callRouteEntry.getComment())
                    .input(VerifyCallRouteSelectorsEntryFields.IPARAM_SIP_PREFIX, callRouteEntry.getSipPrefix())
                    .input(VerifyCallRouteSelectorsEntryFields.IPARAM_SIP_POSTFIX, callRouteEntry.getSipPostfix())
                    .input(VerifyCallRouteSelectorsEntryFields.IPARAM_SIP_DOMAIN, callRouteEntry.getSipDomain())
                    .input(VerifyCallRouteSelectorsEntryFields.IPARAM_SIP_PORT, callRouteEntry.getSipPort())
                    .input(VerifyCallRouteSelectorsEntryFields.IPARAM_RESULT, callRouteEntry.getSipResult()));
        }
    }
}
