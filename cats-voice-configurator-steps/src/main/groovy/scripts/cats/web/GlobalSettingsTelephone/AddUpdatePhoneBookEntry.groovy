package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.PhoneBook.PhoneBookPage

class AddUpdatePhoneBookEntry extends WebScriptTemplate {
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
            phoneBookPage.phoneBookEditor.writeFullName(fullName)
            evaluate(ExecutionDetails.create("Full name " + fullName + " was entered")
                    .success(true))
        }

        if (displayName != null) {
            phoneBookPage.phoneBookEditor.writeDisplayName(displayName)
            evaluate(ExecutionDetails.create("Display name " + displayName + " was entered")
                    .success(true))
        }

        if (location != null) {
            phoneBookPage.phoneBookEditor.writeLocation(location)
            evaluate(ExecutionDetails.create("Location " + location + " was entered")
                    .success(true))
        }

        if (organization != null) {
            phoneBookPage.phoneBookEditor.writeOrganization(organization)
            evaluate(ExecutionDetails.create("Organization " + organization + " was entered")
                    .success(true))
        }

        if (comment != null) {
            phoneBookPage.phoneBookEditor.writeComment(comment)
            evaluate(ExecutionDetails.create("Comment " + comment + " was entered")
                    .success(true))
        }

        if (destination != null) {
            phoneBookPage.phoneBookEditor.writeDestination(destination)
            evaluate(ExecutionDetails.create("Destination " + destination + " was entered")
                    .success(true))
        }

        if (displayAddon != null) {
            phoneBookPage.phoneBookEditor.writeDisplayAddon(displayAddon)
            evaluate(ExecutionDetails.create("Display addon " + displayAddon + " was entered")
                    .success(true))
        }
    }
}
