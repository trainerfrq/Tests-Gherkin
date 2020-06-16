package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage

class ClosePopUpMessage extends WebScriptTemplate {
    @Override
    protected void script() {

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        evaluate(ExecutionDetails.create("Check for pop-up message close button ")
                .expected("Close button was found")
                .success(configManagementObject.popUpMessageBox.isCloseButtonDisplayed()))

        configManagementObject.popUpMessageBox.clickOnCloseButton()

        evaluate(ExecutionDetails.create("Pop-up message Close button was clicked")
                .success(true))
    }
}
