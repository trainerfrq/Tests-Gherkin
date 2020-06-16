package scripts.cats.web.MissionsAndRoles

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.missionsAndRoles.Roles.RolesPage

class AddUpdateRole extends WebScriptTemplate {
    public static final String IPARAM_NAME = "Name"
    public static final String IPARAM_DISPLAY_NAME = "Display name"
    public static final String IPARAM_LOCATION = "Location"
    public static final String IPARAM_ORGANIZATION = "Organization"
    public static final String IPARAM_COMMENT = "Comment"
    public static final String IPARAM_NOTES = "Notes"
    public static final String IPARAM_LAYOUT = "Layout"
    public static final String IPARAM_CALL_ROUTE_SELECTOR = "Call Route Selector"
    public static final String IPARAM_DESTINATION = "Destination"
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
        String defaultSourceOutgoingCalls = getInput(IPARAM_DEFAULT_SOURCE_OUTGOING_CALLS, null)
        String defaultSipPriority = getInput(IPARAM_DEFAULT_SIP_PRIORITY, null)

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        RolesPage rolesPage = new RolesPage(driver)

        if (name != null) {
            rolesPage.writeInField(IPARAM_NAME, name)
            evaluate(ExecutionDetails.create("Full name " + name + " was entered")
                    .success(true))
        }

        if (displayName != null) {
            rolesPage.writeInField(IPARAM_DISPLAY_NAME, displayName)
            evaluate(ExecutionDetails.create("Display name " + displayName + " was entered")
                    .success(true))
        }

        if (location != null) {
            rolesPage.writeInField(IPARAM_LOCATION, location)
            evaluate(ExecutionDetails.create("Location " + location + " was entered")
                    .success(true))
        }

        if (organization != null) {
            rolesPage.writeInField(IPARAM_ORGANIZATION, organization)
            evaluate(ExecutionDetails.create("Organization " + organization + " was entered")
                    .success(true))
        }

        if (comment != null) {
            rolesPage.writeInField(IPARAM_COMMENT, comment)
            evaluate(ExecutionDetails.create("Comment " + comment + " was entered")
                    .success(true))
        }

        if (notes != null) {
            rolesPage.writeInField(IPARAM_NOTES, notes)
            evaluate(ExecutionDetails.create("Notes " + notes + " were entered")
                    .success(true))
        }

        if (layout != null) {
            rolesPage.selectFieldDropDownOption(IPARAM_LAYOUT, layout)
            evaluate(ExecutionDetails.create("Layout " + layout + " was selected")
                    .success(true))
        }

        if (callRouteSelector != null) {
            rolesPage.selectFieldDropDownOption(IPARAM_CALL_ROUTE_SELECTOR, callRouteSelector)
            evaluate(ExecutionDetails.create("Call Route Selector " + callRouteSelector + " was selected")
                    .success(true))
        }

        if (destination != null) {
            rolesPage.writeInField(IPARAM_DESTINATION, destination)
            evaluate(ExecutionDetails.create("Destination " + destination + " was entered")
                    .success(true))
        }

        if (defaultSourceOutgoingCalls != null) {
            rolesPage.selectFieldDropDownOption(IPARAM_DEFAULT_SOURCE_OUTGOING_CALLS, defaultSourceOutgoingCalls)
            evaluate(ExecutionDetails.create("Default Source For Outgoing Calls " + defaultSourceOutgoingCalls + " was selected")
                    .success(true))
        }

        if (defaultSipPriority != null) {
            rolesPage.selectFieldDropDownOption(IPARAM_DEFAULT_SIP_PRIORITY, defaultSipPriority)
            evaluate(ExecutionDetails.create("Default SIP Priority " + defaultSipPriority + " was selected")
                    .success(true))
        }
    }
}
