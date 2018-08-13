package scripts.cats.web

import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.Dimension
import scripts.adapter.controller.ConfiguratorMainPage
import scripts.adapter.controller.module.LeftHandSidePanel
import scripts.agent.selenium.adapter.controller.component.ElementComponent
import scripts.agent.selenium.automation.WebScriptTemplate

class VerifyConfigurationVersionsPanel extends WebScriptTemplate {

    @Override
    void script() {
        ConfiguratorMainPage mainPage = ConfiguratorMainPage.getInstance();
        LeftHandSidePanel panel = mainPage.getLeftHandSidePanel();

        record(recordComponentClicked(panel.versionsContainer, panel.versionsContainer.click()))

        ElementComponent container = panel.getConfigurationVersions();

        evaluate(
                ExecutionDetails.create(appendAdapterDetails("Verify container is empty", container))
                        .expected("container is empty")
                        .received("${container.text().isEmpty()}")
                        .success(container.text().isEmpty())
        )
        pause(5)

        record(recordComponentClicked(panel.versionsContainer, panel.versionsContainer.click()))
    }
}
