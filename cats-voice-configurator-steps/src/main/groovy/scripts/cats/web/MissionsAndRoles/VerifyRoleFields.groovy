package scripts.cats.web.MissionsAndRoles

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.missionsAndRoles.Roles.RolesPage


class VerifyRoleFields extends WebScriptTemplate{
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
            evaluate(ExecutionDetails.create("Verifying role name")
                    .expected(name)
                    .received(rolesPage.rolesEditor.getContentNameTextArea())
                    .success(rolesPage.rolesEditor.getContentNameTextArea().equals(name)))
        }

        if (displayName != null) {
            evaluate(ExecutionDetails.create("Verifying role display name")
                    .expected(displayName)
                    .received(rolesPage.rolesEditor.getContentDisplayNameTextArea())
                    .success(rolesPage.rolesEditor.getContentDisplayNameTextArea().equals(displayName)))
        }

        if (location != null) {
            evaluate(ExecutionDetails.create("Verifying role location")
                    .expected(location)
                    .received(rolesPage.rolesEditor.getContentLocationTextArea())
                    .success(rolesPage.rolesEditor.getContentLocationTextArea().equals(location)))
        }

        if (organization != null) {
            evaluate(ExecutionDetails.create("Verifying role organization")
                    .expected(organization)
                    .received(rolesPage.rolesEditor.getContentOrganizationTextArea())
                    .success(rolesPage.rolesEditor.getContentOrganizationTextArea().equals(organization)))
        }

        if (comment != null) {
            evaluate(ExecutionDetails.create("Verifying role comment")
                    .expected(comment)
                    .received(rolesPage.rolesEditor.getContentCommentTextArea())
                    .success(rolesPage.rolesEditor.getContentCommentTextArea().equals(comment)))
        }

        if (notes != null) {
            evaluate(ExecutionDetails.create("Verifying role notes")
                    .expected(notes)
                    .received(rolesPage.rolesEditor.getContentNotesTextArea())
                    .success(rolesPage.rolesEditor.getContentNotesTextArea().equals(notes)))
        }

        if (layout != null) {
            evaluate(ExecutionDetails.create("Verifying role layout")
                    .expected(layout)
                    .received(rolesPage.rolesEditor.getLayoutDropDownValue())
                    .success(rolesPage.rolesEditor.getLayoutDropDownValue().equals(layout)))
        }

        if (callRouteSelector != null) {
            evaluate(ExecutionDetails.create("Verifying role call route selector")
                    .expected(callRouteSelector)
                    .received(rolesPage.rolesEditor.getCallRouteSelectorValue())
                    .success(rolesPage.rolesEditor.getCallRouteSelectorValue().equals(callRouteSelector)))
        }

        if (destination != null) {
            evaluate(ExecutionDetails.create("Verifying role destination")
                    .expected(destination)
                    .received(rolesPage.rolesEditor.getContentDestinationTextArea())
                    .success(rolesPage.rolesEditor.getContentDestinationTextArea().equals(destination)))
        }

        if (defaultSourceOutgoingCalls != null) {
            evaluate(ExecutionDetails.create("Verifying role default source for outgoing calls")
                    .expected(defaultSourceOutgoingCalls)
                    .received(rolesPage.rolesEditor.getDefaultSourceForOutgoingCallsValue())
                    .success(rolesPage.rolesEditor.getDefaultSourceForOutgoingCallsValue().equals(defaultSourceOutgoingCalls)))
        }

        if (defaultSipPriority != null) {
            evaluate(ExecutionDetails.create("Verifying role default sip priority")
                    .expected(defaultSipPriority)
                    .received(rolesPage.rolesEditor.getDefaultSipPriorityValue())
                    .success(rolesPage.rolesEditor.getDefaultSipPriorityValue().equals(defaultSipPriority)))
        }
    }
}
