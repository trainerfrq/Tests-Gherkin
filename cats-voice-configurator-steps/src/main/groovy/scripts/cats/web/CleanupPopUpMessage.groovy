package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage


class CleanupPopUpMessage extends WebScriptTemplate {
    @Override
    protected void script() {

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        if (configManagementObject.popUpMessageBox.isPopUpMessageDisplayed()) {
            while(configManagementObject.popUpMessageBox.isPopUpMessageDisplayed()){
                evaluate(ExecutionDetails.create("Pop-up message is visible")
                        .success(true))
                configManagementObject.popUpMessageBox.clickOnCloseButton()

                evaluate(ExecutionDetails.create("A pop-up message was closed")
                        .success(true))
            }
            evaluate(ExecutionDetails.create("All pop-ups were closed")
                    .success(!configManagementObject.popUpMessageBox.isPopUpMessageDisplayed()))
        } else {
            evaluate(ExecutionDetails.create("Pop-up message is not visible. No action taken")
                    .success(true))
        }
    }
}
