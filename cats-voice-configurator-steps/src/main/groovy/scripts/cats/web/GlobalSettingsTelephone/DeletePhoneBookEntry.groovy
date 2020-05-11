package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.PhoneBook

class DeletePhoneBookEntry  extends WebScriptTemplate {
    public static final String IPARAM_ENTRY_NAME = "entry_name"

    @Override
    protected void script() {
        String entryName = assertInput(IPARAM_ENTRY_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()

        PhoneBook phoneBook = new PhoneBook(driver)

        WebElement searchedItem = driver.findElement(By.cssSelector("div[title='"+entryName+"']"))

        evaluate(ExecutionDetails.create("Check entry " + entryName + " is in list")
                .expected(entryName + " was found")
                .success(searchedItem != null))

        searchedItem.click()

        evaluate(ExecutionDetails.create("Select entry " + entryName)
                .expected(entryName + " was clicked")
                .success(true))

        evaluate(ExecutionDetails.create("Check delete button is displayed")
                .expected("Display button is displayed")
                .success(phoneBook.isDeleteButtonDisplayed()))

        phoneBook.clickDeleteButton()
    }
}
