package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.CallRouteSelectors.CallRouteSelectorsPage

class AddUpdateCallRouteSelectorsEntry extends WebScriptTemplate {
    public static final String IPARAM_FULL_NAME = "full_name"
    public static final String IPARAM_DISPLAY_NAME = "display_name"
    public static final String IPARAM_COMMENT = "comment"
    public static final String IPARAM_SIP_PREFIX = "sipPrefix"
    public static final String IPARAM_SIP_POSTFIX = "sipPostfix"
    public static final String IPARAM_SIP_DOMAIN = "sipDomain"
    public static final String IPARAM_SIP_PORT = "sipPort"
    public static final String IPARAM_USER_PART = "userPart"

    @Override
    protected void script() {
        String fullName = getInput(IPARAM_FULL_NAME, null)
        String displayName = getInput(IPARAM_DISPLAY_NAME, null)
        String comment = getInput(IPARAM_COMMENT, null)
        String sipPrefix = getInput(IPARAM_SIP_PREFIX, null)
        String sipPostfix = getInput(IPARAM_SIP_POSTFIX, null)
        String sipDomain = getInput(IPARAM_SIP_DOMAIN, null)
        String sipPort = getInput(IPARAM_SIP_PORT, null)
        String userPart = getInput(IPARAM_USER_PART, null)

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        CallRouteSelectorsPage callRouteSelectorsPage = new CallRouteSelectorsPage(driver)

        if (fullName != null) {
            callRouteSelectorsPage.callRouteSelectorsEditor.writeFullName(fullName)
            evaluate(ExecutionDetails.create("Full name " + fullName + " was entered")
                    .success(true))
        }

        if (displayName != null) {
            callRouteSelectorsPage.callRouteSelectorsEditor.writeDisplayName(displayName)
            evaluate(ExecutionDetails.create("Display name " + displayName + " was entered")
                    .success(true))
        }

        if (comment != null) {
            callRouteSelectorsPage.callRouteSelectorsEditor.writeComment(comment)
            evaluate(ExecutionDetails.create("Comment " + comment + " was entered")
                    .success(true))
        }

        if (sipPrefix != null) {
            callRouteSelectorsPage.callRouteSelectorsEditor.writeSipPrefix(sipPrefix)
            evaluate(ExecutionDetails.create("Sip prefix " + sipPrefix + " was entered")
                    .success(true))
        }

        if (sipPostfix != null) {
            callRouteSelectorsPage.callRouteSelectorsEditor.writeSipPostfix(sipPostfix)
            evaluate(ExecutionDetails.create("Sip postfix " + sipPostfix + " was entered")
                    .success(true))
        }

        if (sipDomain != null) {
            callRouteSelectorsPage.callRouteSelectorsEditor.writeSipDomain(sipDomain)
            evaluate(ExecutionDetails.create("Sip domain " + sipDomain + " was entered")
                    .success(true))
        }

        if (sipPort != null) {
            callRouteSelectorsPage.callRouteSelectorsEditor.writeSipPort(sipPort)
            evaluate(ExecutionDetails.create("Sip port " + sipport + " was entered")
                    .success(true))
        }

        if (userPart != null) {
            callRouteSelectorsPage.callRouteSelectorsEditor.writeExampleUser(userPart)
            evaluate(ExecutionDetails.create("User part " + userPart + " was entered")
                    .success(true))
        }
    }
}
