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

        String fullName = getInput(IPARAM_FULL_NAME, null)
        String displayName = getInput(IPARAM_DISPLAY_NAME, null)
        String location = getInput(IPARAM_LOCATION, null)
        String organization = getInput(IPARAM_ORGANIZATION, null)
        String comment = getInput(IPARAM_COMMENT, null)
        String destination = getInput(IPARAM_DESTINATION, null)
        String displayAddon = getInput(IPARAM_DISPLAY_ADDON, null)

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        PhoneBookPage phoneBookPage = new PhoneBookPage(driver)

        if (fullName != null) {
            evaluate(ExecutionDetails.create("Verifying phonebook entry full name")
                    .expected(fullName)
                    .received(phoneBookPage.phoneBookEditor.getContentFullNameTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentFullNameTextArea().equals(fullName)))
        }

        if (displayName != null) {
            evaluate(ExecutionDetails.create("Verifying phonebook entry display name")
                    .expected(displayName)
                    .received(phoneBookPage.phoneBookEditor.getContentDisplayNameTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentDisplayNameTextArea().equals(displayName)))
        }

        if (location != null) {
            evaluate(ExecutionDetails.create("Verifying phonebook entry location")
                    .expected(location)
                    .received(phoneBookPage.phoneBookEditor.getContentLocationTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentLocationTextArea().equals(location)))
        }

        if (organization != null) {
            evaluate(ExecutionDetails.create("Verifying phonebook entry organization")
                    .expected(organization)
                    .received(phoneBookPage.phoneBookEditor.getContentOrganizationTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentOrganizationTextArea().equals(organization)))
        }

        if (comment != null) {
            evaluate(ExecutionDetails.create("Verifying phonebook entry comment")
                    .expected(comment)
                    .received(phoneBookPage.phoneBookEditor.getContentCommentTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentCommentTextArea().equals(comment)))
        }

        if (destination != null) {
            evaluate(ExecutionDetails.create("Verifying phonebook entry destination")
                    .expected(destination)
                    .received(phoneBookPage.phoneBookEditor.getContentDestinationTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentDestinationTextArea().equals(destination)))
        }

        if (displayAddon != null) {
            evaluate(ExecutionDetails.create("Verifying phonebook entry display Addon")
                    .expected(displayAddon)
                    .received(phoneBookPage.phoneBookEditor.getContentAddonTextArea())
                    .success(phoneBookPage.phoneBookEditor.getContentAddonTextArea().equals(displayAddon)))
        }
    }
}
