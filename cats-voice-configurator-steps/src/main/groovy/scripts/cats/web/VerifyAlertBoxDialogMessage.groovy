package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementGeneral

class VerifyAlertBoxDialogMessage extends WebScriptTemplate {
    public static final String IPARAM_ALERT_BOX_MESSAGE = "alert_box_message"

    @Override
    protected void script() {
        String alertBox_message = assertInput(IPARAM_ALERT_BOX_MESSAGE) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()

        ConfigManagementGeneral configurator = new ConfigManagementGeneral(driver)

        evaluate(ExecutionDetails.create("Check for alert box dialog")
                .expected("Alert box dialog was found")
                .success(configurator.isAlertBoxDisplayed()))

        evaluate(ExecutionDetails.create("Check alert box dialog contains message")
                .expected(alertBox_message)
                .received(configurator.getAlertBoxText())
                .success(configurator.getAlertBoxText().contains(alertBox_message)))
    }
}
