package scripts.cats.web

import com.frequentis.c4i.test.model.ExecutionData
import com.frequentis.c4i.test.model.ExecutionDetails
import scripts.adapter.controller.ConfiguratorMainPage
import scripts.adapter.controller.panel.AlertBox
import scripts.agent.selenium.adapter.controller.component.TextComponent
import scripts.agent.selenium.automation.WebScriptTemplate

class InsertTextInAlertBox extends WebScriptTemplate {

    @Override
    void script() {
        ConfiguratorMainPage mainPage = ConfiguratorMainPage.getInstance();
        AlertBox box = mainPage.getAlertBox()
        TextComponent inputField = box.getInputField()
        inputField.attach()
          evaluate(
                  ExecutionDetails.create(appendAdapterDetails("Alert Box is visible", inputField))
                          .expected("alert box is visible")
                          .received("${inputField.isDisplayed()}")
                          .success(inputField.isDisplayed())
          )
          record(recordComponentClicked(inputField, inputField.click()))

          record(recordTextEntered(inputField,
          new ExecutionData("Value to be entered: ", "aaa", ExecutionData.Context.USED),
          inputField.enterText("aaa")))

        pause(5)

    }
}
