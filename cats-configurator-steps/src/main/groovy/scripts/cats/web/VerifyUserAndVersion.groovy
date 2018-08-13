package scripts.cats.web

import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.adapter.controller.ConfiguratorMainPage
import scripts.adapter.controller.module.HeaderModule
import scripts.agent.selenium.adapter.controller.component.ElementComponent
import scripts.agent.selenium.automation.WebScriptTemplate

class VerifyUserAndVersion extends WebScriptTemplate {

    public static final String Username = "username"
    public static final String Version = "version"

    @Override
    void script() {
        ConfiguratorMainPage mainPage = ConfiguratorMainPage.getInstance();

        String username = assertInput(Username)
        String version = assertInput(Version)

        ElementComponent logo = mainPage.getHeaderModule().getLogoBigText();
        record(recordComponentClicked(logo, logo.click()))

        ElementComponent logoVersionPanel = mainPage.getHeaderModule().getLogoVersionPanel();
       evaluate(
                ExecutionDetails.create(appendAdapterDetails("Verify is the correct version of XVP Configurator", logoVersionPanel))
                        .expected(version)
                        .success(logoVersionPanel.contains(version))
        )

        record(recordComponentClicked(logo, logo.click()))

        ElementComponent userName = mainPage.getHeaderModule().getUserName()
        evaluate(
                ExecutionDetails.create(appendAdapterDetails("Verify is the correct username", userName))
                        .expected(username)
                        .success(userName.contains(username))
        )

        record(recordComponentClicked(logo, logo.click()))

    }
}
