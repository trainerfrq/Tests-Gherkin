package scripts.cats.web

import com.frequentis.c4i.test.model.ExecutionData
import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.adapter.controller.ConfiguratorMainPage
import scripts.adapter.controller.panel.AlertBox
import scripts.agent.selenium.adapter.controller.component.ButtonComponent
import scripts.agent.selenium.adapter.controller.component.ElementComponent
import scripts.agent.selenium.adapter.controller.component.TextComponent
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.automation.ConfiguratorConfig


class OpenNewConfigurationBox extends WebScriptTemplate {

    public static final String ConfigurationKey = "Configuration"

    @Override
    void script() {
        String config = assertInput(ConfigurationKey)

        ConfiguratorMainPage mainPage = ConfiguratorMainPage.getInstance();

        ButtonComponent addButton = mainPage.getLeftHandSidePanel().addButton

        record(recordComponentClicked(addButton, addButton.click()))
        pause(5)

        AlertBox box = mainPage.getAlertBox()
        evaluate(
                ExecutionDetails.create(appendAdapterDetails("Alert Box is visible", box))
                        .expected("alert box is visible")
                        .received("${box.isDisplayed()}")
                        .success(box.isDisplayed())
        )
        pause(5)

       /* ButtonComponent cancelButton = box.getCancelButton()
        record(recordComponentClicked(cancelButton, cancelButton.click()))*/

        TextComponent inputField = box.getInputField()
        inputField.attach()


        record(recordTextEntered(inputField,
                new ExecutionData(ConfigurationKey, config),
                       inputField.enterText(config)))

    }

}
