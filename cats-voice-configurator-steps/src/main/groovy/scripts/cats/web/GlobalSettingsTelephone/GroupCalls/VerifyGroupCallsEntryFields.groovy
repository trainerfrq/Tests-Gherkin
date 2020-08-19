package scripts.cats.web.GlobalSettingsTelephone.GroupCalls

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.GroupCalls.GroupCallsPage

class VerifyGroupCallsEntryFields extends WebScriptTemplate {
    public static final String IPARAM_NAME = "Name"
    public static final String IPARAM_DISPLAY_NAME = "Display name"
    public static final String IPARAM_LOCATION = "Location"
    public static final String IPARAM_ORGANIZATION = "Organization"
    public static final String IPARAM_COMMENT = "Comment"
    public static final String IPARAM_CALL_ROUTE_SELECTOR = "Call Route Selector"
    public static final String IPARAM_DESTINATION = "Destination"
    public static final String IPARAM_RESULTING_SIP_URI = "Resulting SIP URI"

    @Override
    protected void script() {

        String name = getInput(IPARAM_NAME, null)
        String displayName = getInput(IPARAM_DISPLAY_NAME, null)
        String location = getInput(IPARAM_LOCATION, null)
        String organization = getInput(IPARAM_ORGANIZATION, null)
        String comment = getInput(IPARAM_COMMENT, null)
        String callRouteSelector = getInput(IPARAM_CALL_ROUTE_SELECTOR, null)
        String destination = getInput(IPARAM_DESTINATION, null)
        String resultingSipUri = getInput(IPARAM_RESULTING_SIP_URI, null)

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        GroupCallsPage groupCallsPage = new GroupCallsPage(driver)

        if (name != null) {
            evaluate(ExecutionDetails.create("Verifying role name")
                    .expected(name)
                    .received(groupCallsPage.getEditor().getFieldContent(IPARAM_NAME))
                    .success(groupCallsPage.getEditor().getFieldContent(IPARAM_NAME).equals(name)))
        }

        if (displayName != null) {
            evaluate(ExecutionDetails.create("Verifying role display name")
                    .expected(displayName)
                    .received(groupCallsPage.getEditor().getFieldContent(IPARAM_DISPLAY_NAME))
                    .success(groupCallsPage.getEditor().getFieldContent(IPARAM_DISPLAY_NAME).equals(displayName)))
        }

        if (location != null) {
            evaluate(ExecutionDetails.create("Verifying role location")
                    .expected(location)
                    .received(groupCallsPage.getEditor().getFieldContent(IPARAM_LOCATION))
                    .success(groupCallsPage.getEditor().getFieldContent(IPARAM_LOCATION).equals(location)))
        }

        if (organization != null) {
            evaluate(ExecutionDetails.create("Verifying role organization")
                    .expected(organization)
                    .received(groupCallsPage.getEditor().getFieldContent(IPARAM_ORGANIZATION))
                    .success(groupCallsPage.getEditor().getFieldContent(IPARAM_ORGANIZATION).equals(organization)))
        }

        if (comment != null) {
            evaluate(ExecutionDetails.create("Verifying role comment")
                    .expected(comment)
                    .received(groupCallsPage.getEditor().getFieldContent(IPARAM_COMMENT))
                    .success(groupCallsPage.getEditor().getFieldContent(IPARAM_COMMENT).equals(comment)))
        }

        if (callRouteSelector != null) {
            evaluate(ExecutionDetails.create("Verifying role call route selector")
                    .expected(callRouteSelector)
                    .received(groupCallsPage.getEditor().getFieldContent(IPARAM_CALL_ROUTE_SELECTOR))
                    .success(groupCallsPage.getEditor().getFieldContent(IPARAM_CALL_ROUTE_SELECTOR).equals(callRouteSelector)))
        }

        if (destination != null) {
            evaluate(ExecutionDetails.create("Verifying role destination")
                    .expected(destination)
                    .received(groupCallsPage.getEditor().getFieldContent(IPARAM_DESTINATION))
                    .success(groupCallsPage.getEditor().getFieldContent(IPARAM_DESTINATION).equals(destination)))
        }

        if (resultingSipUri != null) {
            evaluate(ExecutionDetails.create("Verifying Resulting SIP URI")
                    .expected(resultingSipUri)
                    .received(groupCallsPage.getEditor().getFieldContent(IPARAM_RESULTING_SIP_URI))
                    .success(groupCallsPage.getEditor().getFieldContent(IPARAM_RESULTING_SIP_URI).equals(resultingSipUri)))
        }
    }
}

