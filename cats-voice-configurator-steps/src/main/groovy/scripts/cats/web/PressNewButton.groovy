package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementGeneral

import java.util.concurrent.TimeUnit

class PressNewButton extends WebScriptTemplate {
    @Override
    protected void script() {

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS)

        ConfigManagementGeneral configManagementGeneral = new ConfigManagementGeneral(driver)

        evaluate(ExecutionDetails.create("Check for New button")
                .expected("New button was found")
                .success(configManagementGeneral.isNewButtonDisplayed()))

        configManagementGeneral.clickNewButton()

        evaluate(ExecutionDetails.create("New button was clicked")
                .success(true))
    }
}
