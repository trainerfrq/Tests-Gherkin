package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.CallRouteSelectors.CallRouteSelectorsPage


class VerifyCallRouteSelectorsEntryFields extends WebScriptTemplate {
    public static final String IPARAM_FULL_NAME = "full_name"
    public static final String IPARAM_DISPLAY_NAME = "display_name"
    public static final String IPARAM_COMMENT = "comment"
    public static final String IPARAM_SIP_PREFIX = "sipPrefix"
    public static final String IPARAM_SIP_POSTFIX = "sipPostfix"
    public static final String IPARAM_SIP_DOMAIN = "sipDomain"
    public static final String IPARAM_SIP_PORT = "sipPort"
    public static final String IPARAM_RESULT= "result"

    @Override
    protected void script() {
        String fullName = getInput(IPARAM_FULL_NAME, null)
        String displayName = getInput(IPARAM_DISPLAY_NAME, null)
        String comment = getInput(IPARAM_COMMENT, null)
        String sipPrefix = getInput(IPARAM_SIP_PREFIX, null)
        String sipPostfix = getInput(IPARAM_SIP_POSTFIX, null)
        String sipDomain = getInput(IPARAM_SIP_DOMAIN, null)
        String sipPort = getInput(IPARAM_SIP_PORT, null)
        String resultText = getInput(IPARAM_RESULT, null)

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        CallRouteSelectorsPage callRouteSelectorsPage = new CallRouteSelectorsPage(driver)

        if (fullName != null) {
            evaluate(ExecutionDetails.create("Verifying call route selectors entry full name")
                    .expected(fullName)
                    .received(callRouteSelectorsPage.callRouteSelectorsEditor.getContentFullNameTextArea())
                    .success(callRouteSelectorsPage.callRouteSelectorsEditor.getContentFullNameTextArea().equals(fullName)))
        }

        if (displayName != null) {
            evaluate(ExecutionDetails.create("Verifying call route selectors entry display name")
                    .expected(displayName)
                    .received(callRouteSelectorsPage.callRouteSelectorsEditor.getContentDisplayNameTextArea())
                    .success(callRouteSelectorsPage.callRouteSelectorsEditor.getContentDisplayNameTextArea().equals(displayName)))
        }

        if (comment != null) {
            evaluate(ExecutionDetails.create("Verifying call route selectors entry comment")
                    .expected(comment)
                    .received(callRouteSelectorsPage.callRouteSelectorsEditor.getContentCommentTextArea())
                    .success(callRouteSelectorsPage.callRouteSelectorsEditor.getContentCommentTextArea().equals(comment)))
        }

        if (sipPrefix != null) {
            evaluate(ExecutionDetails.create("Verifying call route selectors entry sip prefix")
                    .expected(sipPrefix)
                    .received(callRouteSelectorsPage.callRouteSelectorsEditor.getSipPrefixTextArea())
                    .success(callRouteSelectorsPage.callRouteSelectorsEditor.getSipPrefixTextArea().equals(sipPrefix)))
        }

        if (sipPostfix != null) {
            evaluate(ExecutionDetails.create("Verifying call route selectors entry sip postfix")
                    .expected(sipPostfix)
                    .received(callRouteSelectorsPage.callRouteSelectorsEditor.getSipPostfixTextArea())
                    .success(callRouteSelectorsPage.callRouteSelectorsEditor.getSipPostfixTextArea().equals(sipPostfix)))
        }

        if (sipDomain != null) {
            evaluate(ExecutionDetails.create("Verifying call route selectors entry sip domain")
                    .expected(sipDomain)
                    .received(callRouteSelectorsPage.callRouteSelectorsEditor.getSipDomainTextArea())
                    .success(callRouteSelectorsPage.callRouteSelectorsEditor.getSipDomainTextArea().equals(sipDomain)))
        }

        if (sipPort != null) {
            evaluate(ExecutionDetails.create("Verifying call route selectors entry sip port")
                    .expected(sipPort)
                    .received(callRouteSelectorsPage.callRouteSelectorsEditor.getSipPortTextArea())
                    .success(callRouteSelectorsPage.callRouteSelectorsEditor.getSipPortTextArea().equals(sipPort)))
        }

        if(resultText != null){
            WebElement resultTextArea = driver.findElement(By.xpath("//div[contains(text(),'"+resultText+"')]"))
            evaluate(ExecutionDetails.create("Verifying call route selectors entry result")
                    .expected(resultText)
                    .success(resultTextArea.isDisplayed()))
        }



    }
}
