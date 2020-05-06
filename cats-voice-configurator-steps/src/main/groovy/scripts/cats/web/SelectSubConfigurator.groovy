package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate

import java.util.concurrent.TimeUnit

class SelectSubConfigurator extends WebScriptTemplate{
    public static final String IPARAM_SUBCONFIG_NAME = "SubConfigurator_name"

    @Override
    protected void script() {
        String subConfiguratorName =  assertInput(IPARAM_SUBCONFIG_NAME) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);

        WebElement subConfigurator = driver.findElement(By.cssSelector("div[title='"+ subConfiguratorName + "'" ))

        evaluate(ExecutionDetails.create("Check for " + subConfiguratorName)
                .expected(subConfiguratorName + " was found")
                .success(subConfigurator.isDisplayed()));

        subConfigurator.click()

        evaluate(ExecutionDetails.create("SubConfigurator " + subConfiguratorName + " was clicked")
                .success(true));

    }
}
