package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.PhoneBook.PhoneBookPage

class CheckEntryIsInResultsListAfterSearch extends WebScriptTemplate {
    public static final String IPARAM_ENTRY_NAME = "entry_name"

    @Override
    protected void script() {
        String entryName = assertInput(IPARAM_ENTRY_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        PhoneBookPage phoneBookObject = new PhoneBookPage(driver)

        evaluate(ExecutionDetails.create("Check if " + entryName + " is in results list")
                .expected(entryName + " was found")
                .success(phoneBookObject.leftHandSidePanel.findItem(entryName).isDisplayed()))
    }
}
