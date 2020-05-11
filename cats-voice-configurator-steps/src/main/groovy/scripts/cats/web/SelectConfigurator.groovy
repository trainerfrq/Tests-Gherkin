package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate

class SelectConfigurator extends WebScriptTemplate {
    public static final String IPARAM_CONFIG_NAME = "configurator_name"

    @Override
    protected void script() {
        String configuratorName = assertInput(IPARAM_CONFIG_NAME) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()

        WebElement configurator = driver.findElement(By.cssSelector("div[title='" + configuratorName + "'"))

        evaluate(ExecutionDetails.create("Check for " + configuratorName)
                .expected(configuratorName + " was found")
                .success(configurator.isDisplayed()))

        configurator.click()

        evaluate(ExecutionDetails.create("Configurator " + configuratorName + " was clicked")
                .success(true))
    }
}
