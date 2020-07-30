package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage

class VerifyPopUpMessageContent extends WebScriptTemplate {
    public static final String IPARAM_POPUP_MESSAGE = "pop-up_message"

    @Override
    protected void script() {
        String popUpMessage = assertInput(IPARAM_POPUP_MESSAGE) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        evaluate(ExecutionDetails.create("Check pop-up contains message")
                .expected(popUpMessage)
                .received(configManagementObject.popUpMessageBox.getPopUpMessage())
                .success(popUpMessage.equals(configManagementObject.popUpMessageBox.getPopUpMessage())))
    }
}