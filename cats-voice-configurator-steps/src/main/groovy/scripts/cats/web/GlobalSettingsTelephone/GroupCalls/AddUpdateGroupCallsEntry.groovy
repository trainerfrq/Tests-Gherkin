package scripts.cats.web.GlobalSettingsTelephone.GroupCalls

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.GroupCalls.GroupCallsPage

class AddUpdateGroupCallsEntry extends WebScriptTemplate {
    public static final String IPARAM_NAME = "Name"
    public static final String IPARAM_DISPLAY_NAME = "Display name"
    public static final String IPARAM_LOCATION = "Location"
    public static final String IPARAM_ORGANIZATION = "Organization"
    public static final String IPARAM_COMMENT = "Comment"
    public static final String IPARAM_CALL_ROUTE_SELECTOR = "Call Route Selector"
    public static final String IPARAM_DESTINATION = "Destination"

    @Override
    protected void script() {

        String name = getInput(IPARAM_NAME, null)
        String displayName = getInput(IPARAM_DISPLAY_NAME, null)
        String location = getInput(IPARAM_LOCATION, null)
        String organization = getInput(IPARAM_ORGANIZATION, null)
        String comment = getInput(IPARAM_COMMENT, null)
        String callRouteSelector = getInput(IPARAM_CALL_ROUTE_SELECTOR, null)
        String destination = getInput(IPARAM_DESTINATION, null)

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        GroupCallsPage groupCallsPage = new GroupCallsPage(driver)

        if (name != null) {
            groupCallsPage.getEditor().writeInField(IPARAM_NAME, name)
            evaluate(ExecutionDetails.create("Full name " + name + " was entered")
                    .success(true))
        }

        if (displayName != null) {
            groupCallsPage.getEditor().writeInField(IPARAM_DISPLAY_NAME, displayName)
            evaluate(ExecutionDetails.create("Display name " + displayName + " was entered")
                    .success(true))
        }

        if (location != null) {
            groupCallsPage.getEditor().writeInField(IPARAM_LOCATION, location)
            evaluate(ExecutionDetails.create("Location " + location + " was entered")
                    .success(true))
        }

        if (organization != null) {
            groupCallsPage.getEditor().writeInField(IPARAM_ORGANIZATION, organization)
            evaluate(ExecutionDetails.create("Organization " + organization + " was entered")
                    .success(true))
        }

        if (comment != null) {
            groupCallsPage.getEditor().writeInField(IPARAM_COMMENT, comment)
            evaluate(ExecutionDetails.create("Comment " + comment + " was entered")
                    .success(true))
        }

        if (callRouteSelector != null) {
            groupCallsPage.getEditor().selectFieldDropDownOption(IPARAM_CALL_ROUTE_SELECTOR, callRouteSelector)
            evaluate(ExecutionDetails.create("Call Route Selector " + callRouteSelector + " was selected")
                    .success(true))
        }

        if (destination != null) {
            groupCallsPage.getEditor().writeInField(IPARAM_DESTINATION, destination)
            evaluate(ExecutionDetails.create("Destination " + destination + " was entered")
                    .success(true))
        }
    }
}
