package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage

class CleanupDiscardAlertBox extends WebScriptTemplate {
    @Override
    protected void script() {

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        if (configManagementObject.discardAlertBox.isAlertBoxDisplayed()) {
            evaluate(ExecutionDetails.create("Alert box is visible")
                    .success(true))

            configManagementObject.discardAlertBox.clickDiscardChangesButton()
            sleep(500)

            evaluate(ExecutionDetails.create("Unsaved changes were discarded")
                    .success(!configManagementObject.discardAlertBox.isAlertBoxDisplayed()))
        } else {
            evaluate(ExecutionDetails.create("Alert box is not visible. No action taken")
                    .success(true))
        }
    }
}
