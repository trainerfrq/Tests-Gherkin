package scripts.cats.web.MissionsAndRoles

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.missionsAndRoles.Roles.RolesPage

class VerifyRoleFields extends WebScriptTemplate{
    public static final String IPARAM_NAME = "Name"
    public static final String IPARAM_DISPLAY_NAME = "Display name"
    public static final String IPARAM_LOCATION = "Location"
    public static final String IPARAM_ORGANIZATION = "Organization"
    public static final String IPARAM_COMMENT = "Comment"
    public static final String IPARAM_NOTES = "Notes"
    public static final String IPARAM_LAYOUT = "Layout"
    public static final String IPARAM_CALL_ROUTE_SELECTOR = "Call Route Selector"
    public static final String IPARAM_DESTINATION = "Destination"
    public static final String IPARAM_RESULTING_SIP_URI = "Resulting SIP URI"
    public static final String IPARAM_DEFAULT_SOURCE_OUTGOING_CALLS = "Default Source for outgoing calls"
    public static final String IPARAM_DEFAULT_SIP_PRIORITY = "Default SIP Priority"

    @Override
    protected void script() {

        String name = getInput(IPARAM_NAME, null)
        String displayName = getInput(IPARAM_DISPLAY_NAME, null)
        String location = getInput(IPARAM_LOCATION, null)
        String organization = getInput(IPARAM_ORGANIZATION, null)
        String comment = getInput(IPARAM_COMMENT, null)
        String notes = getInput(IPARAM_NOTES, null)
        String layout = getInput(IPARAM_LAYOUT, null)
        String callRouteSelector = getInput(IPARAM_CALL_ROUTE_SELECTOR, null)
        String destination = getInput(IPARAM_DESTINATION, null)
        String resultingSipUri = getInput(IPARAM_RESULTING_SIP_URI, null)
        String defaultSourceOutgoingCalls = getInput(IPARAM_DEFAULT_SOURCE_OUTGOING_CALLS, null)
        String defaultSipPriority = getInput(IPARAM_DEFAULT_SIP_PRIORITY, null)

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        RolesPage rolesPage = new RolesPage(driver)

        if (name != null) {
            evaluate(ExecutionDetails.create("Verifying role name")
                    .expected(name)
                    .received(rolesPage.getFieldContent(IPARAM_NAME))
                    .success(rolesPage.getFieldContent(IPARAM_NAME).equals(name)))
        }

        if (displayName != null) {
            evaluate(ExecutionDetails.create("Verifying role display name")
                    .expected(displayName)
                    .received(rolesPage.getFieldContent(IPARAM_DISPLAY_NAME))
                    .success(rolesPage.getFieldContent(IPARAM_DISPLAY_NAME).equals(displayName)))
        }

        if (location != null) {
            evaluate(ExecutionDetails.create("Verifying role location")
                    .expected(location)
                    .received(rolesPage.getFieldContent(IPARAM_LOCATION))
                    .success(rolesPage.getFieldContent(IPARAM_LOCATION).equals(location)))
        }

        if (organization != null) {
            evaluate(ExecutionDetails.create("Verifying role organization")
                    .expected(organization)
                    .received(rolesPage.getFieldContent(IPARAM_ORGANIZATION))
                    .success(rolesPage.getFieldContent(IPARAM_ORGANIZATION).equals(organization)))
        }

        if (comment != null) {
            evaluate(ExecutionDetails.create("Verifying role comment")
                    .expected(comment)
                    .received(rolesPage.getFieldContent(IPARAM_COMMENT))
                    .success(rolesPage.getFieldContent(IPARAM_COMMENT).equals(comment)))
        }

        if (notes != null) {
            evaluate(ExecutionDetails.create("Verifying role notes")
                    .expected(notes)
                    .received(rolesPage.getFieldContent(IPARAM_NOTES))
                    .success(rolesPage.getFieldContent(IPARAM_NOTES).equals(notes)))
        }

        if (layout != null) {
            evaluate(ExecutionDetails.create("Verifying role layout")
                    .expected(layout)
                    .received(rolesPage.getFieldContent(IPARAM_LAYOUT))
                    .success(rolesPage.getFieldContent(IPARAM_LAYOUT).equals(layout)))
        }

        if (callRouteSelector != null) {
            evaluate(ExecutionDetails.create("Verifying role call route selector")
                    .expected(callRouteSelector)
                    .received(rolesPage.getFieldContent(IPARAM_CALL_ROUTE_SELECTOR))
                    .success(rolesPage.getFieldContent(IPARAM_CALL_ROUTE_SELECTOR).equals(callRouteSelector)))
        }

        if (destination != null) {
            evaluate(ExecutionDetails.create("Verifying role destination")
                    .expected(destination)
                    .received(rolesPage.getFieldContent(IPARAM_DESTINATION))
                    .success(rolesPage.getFieldContent(IPARAM_DESTINATION).equals(destination)))
        }

        if (resultingSipUri != null) {
            evaluate(ExecutionDetails.create("Verifying Resulting SIP URI")
                    .expected(resultingSipUri)
                    .received(rolesPage.getFieldContent(IPARAM_RESULTING_SIP_URI))
                    .success(rolesPage.getFieldContent(IPARAM_RESULTING_SIP_URI).equals(resultingSipUri)))
        }

        if (defaultSourceOutgoingCalls != null) {
            evaluate(ExecutionDetails.create("Verifying role default source for outgoing calls")
                    .expected(defaultSourceOutgoingCalls)
                    .received(rolesPage.getFieldContent(IPARAM_DEFAULT_SOURCE_OUTGOING_CALLS))
                    .success(rolesPage.getFieldContent(IPARAM_DEFAULT_SOURCE_OUTGOING_CALLS).equals(defaultSourceOutgoingCalls)))
        }

        if (defaultSipPriority != null) {
            evaluate(ExecutionDetails.create("Verifying role default sip priority")
                    .expected(defaultSipPriority)
                    .received(rolesPage.getFieldContent(IPARAM_DEFAULT_SIP_PRIORITY))
                    .success(rolesPage.getFieldContent(IPARAM_DEFAULT_SIP_PRIORITY).equals(defaultSipPriority)))
        }
    }
}
