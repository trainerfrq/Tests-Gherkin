package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.PhoneBook

import java.util.concurrent.TimeUnit

class DeletePhoneBookEntry  extends WebScriptTemplate {
    public static final String IPARAM_ENTRY_NAME = "entry_name"

    @Override
    protected void script() {
        String entryName = assertInput(IPARAM_ENTRY_NAME) as String
        String warningMessage = "Are you sure you want to delete the phone book entry "+entryName+"?"

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS)

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

        evaluate(ExecutionDetails.create("Check alert box is displayed")
                .expected("Alert box is displayed")
                .success(phoneBook.isAlertBoxDisplayed()))

        evaluate(ExecutionDetails.create("Check alert box displayed message")
                .expected(warningMessage)
                .success(phoneBook.getAlertBoxText().contains(warningMessage)))

        WebElement yesButton = driver.findElement(By.xpath("//button[contains(text(),'Yes')]"))

        yesButton.click()
        sleep(5000)

        evaluate(ExecutionDetails.create("Verify PopUp message")
                .expected("File was successfully deleted")
                .success(phoneBook.getPopUpMessage().contains("The file was successfully deleted")))
    }
}
