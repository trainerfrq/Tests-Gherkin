package scripts.cats.web.GlobalSettingsTelephone

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage

class VerifyPopUpMessage extends WebScriptTemplate {
    public static final String IPARAM_POPUP_MESSAGE = "pop-up_message"

    @Override
    protected void script() {
        String popUp_message = assertInput(IPARAM_POPUP_MESSAGE) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        evaluate(ExecutionDetails.create("Check for pop-up message")
                .expected("Pop-up message was found")
                .success(configManagementObject.popUpMessageBox.isPopUpMessageDisplayed()))

        evaluate(ExecutionDetails.create("Check pop-up contains message")
                .expected(popUp_message)
                .received(configManagementObject.popUpMessageBox.getPopUpMessage())
                .success(popUp_message.equals(configManagementObject.popUpMessageBox.getPopUpMessage())))
    }
}
