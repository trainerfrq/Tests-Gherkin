package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementGeneral

import java.util.concurrent.TimeUnit


class WriteInSearchBox extends WebScriptTemplate {
    public static final String IPARAM_SEARCHED_ENTRY = "searched_entry"

    @Override
    protected void script() {
        String searchedEntry = assertInput(IPARAM_SEARCHED_ENTRY) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS)

        ConfigManagementGeneral configurator = new ConfigManagementGeneral(driver)

        evaluate(ExecutionDetails.create("Check for Search Box")
                .expected("Search Box was found")
                .success(configurator.isSearchBoxDisplayed()))

        configurator.writeInSearchBox(searchedEntry)

        evaluate(ExecutionDetails.create("Check Search Box contains entered text")
                .expected(searchedEntry)
                .received(configurator.getContentSearchBoxTextArea())
                .success(searchedEntry.equals(configurator.getContentSearchBoxTextArea())))
    }
}
