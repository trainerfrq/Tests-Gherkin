package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.PhoneBook

class VerifyPhoneBookTitleIsVisible extends WebScriptTemplate {

    @Override
    protected void script() {
        WebDriver driver = WebDriverManager.getInstance().getWebDriver();

        PhoneBook phoneBook = new PhoneBook(driver)

        evaluate(ExecutionDetails.create("Verifying Phonebook right hand side Title")
                .expected("Title is visible")
                .success(phoneBook.isRightHandTreeTitleDisplayed()));


    }
}
