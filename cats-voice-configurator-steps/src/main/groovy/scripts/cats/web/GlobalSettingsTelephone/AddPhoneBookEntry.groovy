package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.PhoneBook

import java.util.concurrent.TimeUnit

class AddPhoneBookEntry extends WebScriptTemplate {
    public static final String IPARAM_FULL_NAME= "full_name"
    public static final String IPARAM_DISPLAY_NAME= "display_name"
    public static final String IPARAM_DESTINATION= "destination"

    @Override
    protected void script() {
        String fullName = assertInput(IPARAM_FULL_NAME) as String
        String displayName = assertInput(IPARAM_DISPLAY_NAME) as String
        String destination = assertInput(IPARAM_DESTINATION) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS)

        PhoneBook newPhonebook = new PhoneBook(driver)

        newPhonebook.writeFullName(fullName)

        evaluate(ExecutionDetails.create("Full name " + fullName + " was entered")
                .expected(fullName)
                .received(newPhonebook.getContentFullNameTextArea())
                .success(fullName.equals(newPhonebook.getContentFullNameTextArea())))

        newPhonebook.writeDisplayName(displayName)

        evaluate(ExecutionDetails.create("Display name " + displayName + " was entered")
                .expected(displayName)
                .received(newPhonebook.getContentDisplayNameTextArea())
                .success(displayName.equals(newPhonebook.getContentDisplayNameTextArea())))

        newPhonebook.writeDestination(destination)

        evaluate(ExecutionDetails.create("Destination " + destination + " was entered")
                .expected(destination)
                .received(newPhonebook.getContentDestinationTextArea())
                .success(destination.equals(newPhonebook.getContentDestinationTextArea())))

        newPhonebook.clickSaveButton()
        sleep(5000)

        ///check save pop-up showed
        evaluate(ExecutionDetails.create("New phonebook was saved succesfully")
                .success(newPhonebook.getPopUpMessage().contains("Successfully saved the phonebook entry")));
    }
}
