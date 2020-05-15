package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.PhoneBook.PhoneBookPage


class VerifyPhoneBookEntryFields extends WebScriptTemplate {
    public static final String IPARAM_FULL_NAME = "full_name"
    public static final String IPARAM_DISPLAY_NAME = "display_name"
    public static final String IPARAM_LOCATION = "location"
    public static final String IPARAM_ORGANIZATION = "organization"
    public static final String IPARAM_COMMENT = "comment"
    public static final String IPARAM_DESTINATION = "destination"
    public static final String IPARAM_DISPLAY_ADDON = "display_addon"

    @Override
    protected void script() {

        String fullName = assertInputParameter(IPARAM_FULL_NAME)
        String displayName = assertInputParameter(IPARAM_DISPLAY_NAME)
        String location = assertInputParameter(IPARAM_LOCATION)
        String organization = assertInputParameter(IPARAM_ORGANIZATION)
        String comment = assertInputParameter(IPARAM_COMMENT)
        String destination = assertInputParameter(IPARAM_DESTINATION)
        String displayAddon = assertInputParameter(IPARAM_DISPLAY_ADDON)

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        PhoneBookPage phoneBookPage = new PhoneBookPage(driver)

        if (fullName != "-") {
            evaluate(ExecutionDetails.create("Verifying phonebook entry full name")
                    .expected(fullName)
                    .received(phoneBookPage.phoneBookEditor.getContentFullNameTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentFullNameTextArea().equals(fullName)))
        }

        if (displayName != "-") {
            evaluate(ExecutionDetails.create("Verifying phonebook entry display name")
                    .expected(displayName)
                    .received(phoneBookPage.phoneBookEditor.getContentDisplayNameTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentDisplayNameTextArea().equals(displayName)))
        }

        if (location != "-") {
            evaluate(ExecutionDetails.create("Verifying phonebook entry location")
                    .expected(location)
                    .received(phoneBookPage.phoneBookEditor.getContentLocationTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentLocationTextArea().equals(location)))
        }

        if (organization != "-") {
            evaluate(ExecutionDetails.create("Verifying phonebook entry organization")
                    .expected(organization)
                    .received(phoneBookPage.phoneBookEditor.getContentOrganizationTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentOrganizationTextArea().equals(organization)))
        }

        if (comment != "-") {
            evaluate(ExecutionDetails.create("Verifying phonebook entry comment")
                    .expected(comment)
                    .received(phoneBookPage.phoneBookEditor.getContentCommentTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentCommentTextArea().equals(comment)))
        }

        if (destination != "-") {
            evaluate(ExecutionDetails.create("Verifying phonebook entry destination")
                    .expected(displayName)
                    .received(phoneBookPage.phoneBookEditor.getContentDestinationTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentDestinationTextArea().equals(destination)))
        }

        if (displayAddon != "-") {
            evaluate(ExecutionDetails.create("Verifying phonebook entry display Addon")
                    .expected(displayAddon)
                    .received(phoneBookPage.phoneBookEditor.getContentAddonTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentAddonTextArea().equals(displayAddon)))
        }
    }

    String assertInputParameter(String parameter) {
        if (parameter == null)
            return null
        return assertInput(parameter) as String
    }
}
