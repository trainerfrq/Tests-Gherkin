package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class VerifyFieldWarningMessage extends WebScriptTemplate {
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_FIELD_NAME = "field_name"
    public static final String IPARAM_WARNING_MESSAGE = "warning_message"

    @Override
    protected void script() {
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String
        String fieldName = assertInput(IPARAM_FIELD_NAME) as String
        String warningMessage = assertInput(IPARAM_WARNING_MESSAGE) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        evaluate(ExecutionDetails.create("Check " + fieldName + " field  warning message is displayed")
                .expected("Warning message is displayed")
                .success(pageObject.getEditor().isFieldErrorMessageDisplayed(fieldName)))

        evaluate(ExecutionDetails.create("Verify " + fieldName + " field  warning message content")
                .expected(warningMessage)
                .received(pageObject.getEditor().getFieldErrorMessage(fieldName))
                .success(pageObject.getEditor().getFieldErrorMessage(fieldName).contains(warningMessage)))
    }
}
