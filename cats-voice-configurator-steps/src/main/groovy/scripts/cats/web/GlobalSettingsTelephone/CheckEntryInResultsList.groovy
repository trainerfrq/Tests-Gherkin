package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate

import java.util.concurrent.TimeUnit

class CheckEntryInResultsList extends WebScriptTemplate {
    public static final String IPARAM_ENTRY_NAME = "entry_name"

    @Override
    protected void script() {
        String entryName = assertInput(IPARAM_ENTRY_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS)

        WebElement searchedItem = driver.findElement(By.cssSelector("div[title='" + entryName + "']"))

        evaluate(ExecutionDetails.create("Check if " + entryName + " is in results list")
                .expected(entryName + " was found")
                .success(searchedItem != null))
    }
}
