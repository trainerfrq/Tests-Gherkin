package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.bdd.fluent.step.Profile;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.xvp.voice.test.automation.phone.data.ProfileToWebConfigurationReference;
import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import scripts.cats.web.OpenNewConfigurationBoxWebDriver;
import scripts.cats.web.SelectConfigurator;

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
    public void addNewConfiguration(){
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Add a new configuration")
                    .scriptOn(OpenNewConfigurationBoxWebDriver.class, profile));

        }
    }

    @When("configurator $configuratorName is selected")
    public void selectConfigurator(String configuratorName){
        ProfileToWebConfigurationReference webAppConfig = getStoryData("config-1", ProfileToWebConfigurationReference.class);
        if (webAppConfig != null) {
            Profile profile = getProfile(webAppConfig.getProfileName());
            evaluate(remoteStep("Select " + configuratorName + " configurator")
                    .scriptOn(SelectConfigurator.class, profile)
                    .input(SelectConfigurator.IPARAM_CONFIG_NAME, configuratorName));
        }
    }
}
