package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import elements.ConfiguratorGeneralElements
import elements.configurators.globalSettingsTelephone.PhoneBook
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate

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

        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);
        ConfiguratorGeneralElements
        PhoneBook newPhonebook = new PhoneBook(driver);

        newPhonebook.write_FullName(fullName)

        //asert full name was entered

        newPhonebook.write_DisplayName(displayName)

        //asert display name was entered

        newPhonebook.write_Destination(destination)

        //asert destination was entered

        newPhonebook.clickSaveButton()

        ///check save pop-up showed
        newPhonebook.isPhonebooKSaved()

    }
}
