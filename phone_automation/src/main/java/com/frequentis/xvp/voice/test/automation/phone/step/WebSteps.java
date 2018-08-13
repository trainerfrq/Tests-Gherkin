package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.model.ExecutionDetails;
import org.jbehave.core.annotations.Given;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.adapter.controller.ConfiguratorMainPage;
import scripts.cats.web.*;

import java.util.List;

public class WebSteps extends AutomationSteps {

   @Given("defined XVP Configurator pages: $webAppConfigs")
    public void GivenFollowingSettings(final List<ProfileToWebConfigurationReference> webAppConfigs) {
        int i = 1;
        for (ProfileToWebConfigurationReference webAppConfig : webAppConfigs) {
            String info = "WebApplicationConfig: " + i++;
            setStoryData(webAppConfig.getKey(), webAppConfig);
            record(localStep(info).details(ExecutionDetails.create(info).received(webAppConfig.toString())));
        }
    }

    @Given("all expected elements are visible on the XVP Configurator main page")
    public void VerifyMainXVPConfiguratorPage(){
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if(webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Verify main XVP Configurator page is visible")
                    .scriptOn(VerifyMainPageIsVisible.class, profile));
        }
        else {
            evaluate(localStep("Profile " + webAppConfig.getProfileName()+ " not found")
                    .details(ExecutionDetails.create("Profile " + webAppConfig.getProfileName()+ " not found").failure()));
        }
    }

    @Given("XVP Configurator shows version $version and user $user")
    public void VerifyVersionAndUser(final String version, final String user){
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if(webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Verify user and version")
                    .scriptOn(VerifyUserAndVersion.class, profile)
                    .input(VerifyUserAndVersion.Username, user)
                    .input(VerifyUserAndVersion.Version, version));
        }
        else {
            evaluate(localStep("Profile " + webAppConfig.getProfileName()+ " not found")
                    .details(ExecutionDetails.create("Profile " + webAppConfig.getProfileName()+ " not found").failure()));
        }
    }

    @When("Applications item is selected")
    public void SelectItemFromLeftPanel() {
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Select first item from left side panel")
                    .scriptOn(SelectLeftPanelItem.class, profile));
        }
    }

    @When("configuration versions panel is verified and found empty")
    public void VerifyConfigurationVersions(){
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Verify configuration versions panel")
                    .scriptOn(VerifyConfigurationVersionsPanel.class, profile));
        }

    }

    @Then("add a new configuration")
    public void AddNewConfiguration(){
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Add a new configuration")
                    .scriptOn(OpenNewConfigurationBoxWebDriver.class, profile));


        }
    }

}
