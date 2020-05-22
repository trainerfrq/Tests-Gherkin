package scripts.cats.web.MissionsAndRoles

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.missionsAndRoles.Roles.RolesPage

class AddUpdateRole extends WebScriptTemplate {
    public static final String IPARAM_NAME = "name"
    public static final String IPARAM_DISPLAY_NAME = "display_name"
    public static final String IPARAM_LOCATION = "location"
    public static final String IPARAM_ORGANIZATION = "organization"
    public static final String IPARAM_COMMENT = "comment"
    public static final String IPARAM_NOTES = "notes"
    public static final String IPARAM_LAYOUT = "layout"
    public static final String IPARAM_CALL_ROUTE_SELECTOR = "call_route_selector"
    public static final String IPARAM_DESTINATION = "destination"
    public static final String IPARAM_DEFAULT_SOURCE_OUTGOING_CALLS = "default_source_outgoing_calls"
    public static final String IPARAM_DEFAULT_SIP_PRIORITY = "default_sip_priority"

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
            rolesPage.rolesEditor.writeName(name)
            evaluate(ExecutionDetails.create("Full name " + name + " was entered")
                    .success(true))
        }

        if (displayName != null) {
            rolesPage.rolesEditor.writeDisplayName(displayName)
            evaluate(ExecutionDetails.create("Display name " + displayName + " was entered")
                    .success(true))
        }

        if (location != null) {
            rolesPage.rolesEditor.writeLocation(location)
            evaluate(ExecutionDetails.create("Location " + location + " was entered")
                    .success(true))
        }

        if (organization != null) {
            rolesPage.rolesEditor.writeOrganization(organization)
            evaluate(ExecutionDetails.create("Organization " + organization + " was entered")
                    .success(true))
        }

        if (comment != null) {
            rolesPage.rolesEditor.writeComment(comment)
            evaluate(ExecutionDetails.create("Comment " + comment + " was entered")
                    .success(true))
        }

        if (notes != null) {
            rolesPage.rolesEditor.writeNotes(notes)
            evaluate(ExecutionDetails.create("Notes " + notes + " were entered")
                    .success(true))
        }

        if (layout != null) {
            rolesPage.rolesEditor.clickOnLayoutDropDownItem(layout)
            evaluate(ExecutionDetails.create("Layout " + layout + " was selected")
                    .success(true))
        }

        if (callRouteSelector != null) {
            rolesPage.rolesEditor.clickOnCallRouteSelectorItem(callRouteSelector)
            evaluate(ExecutionDetails.create("Call Route Selector " + callRouteSelector + " was selected")
                    .success(true))
        }

        if (destination != null) {
            rolesPage.rolesEditor.writeDestination(destination)
            evaluate(ExecutionDetails.create("Destination " + destination + " was entered")
                    .success(true))
        }

        if (defaultSourceOutgoingCalls != null) {
            rolesPage.rolesEditor.clickOnDefaultSourceForOutgoingCallsItem(defaultSourceOutgoingCalls)
            evaluate(ExecutionDetails.create("Default Source For Outgoing Calls " + defaultSourceOutgoingCalls + " was selected")
                    .success(true))
        }

        if (defaultSipPriority != null) {
            rolesPage.rolesEditor.clickOnDefaultSipPriorityItem(defaultSipPriority)
            evaluate(ExecutionDetails.create("Default SIP Priority " + defaultSipPriority + " was selected")
                    .success(true))
        }
    }
}
