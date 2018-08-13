package scripts.cats.web

import scripts.adapter.controller.ConfiguratorMainPage
import scripts.adapter.controller.panel.AlertBox
import scripts.agent.selenium.adapter.controller.component.ButtonComponent
import scripts.agent.selenium.automation.WebScriptTemplate

class CancelAlertBox extends WebScriptTemplate {

    @Override
    void script() {
        ConfiguratorMainPage mainPage = ConfiguratorMainPage.getInstance();
        AlertBox box = mainPage.getAlertBox()
        box.attach()
        ButtonComponent cancelButton = box.getCancelButton()
        cancelButton.attach()

        record(recordComponentClicked(cancelButton, cancelButton.click()))
    }
}
