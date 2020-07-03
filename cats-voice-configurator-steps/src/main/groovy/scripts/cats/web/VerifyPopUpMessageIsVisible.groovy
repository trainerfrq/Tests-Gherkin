package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage

class VerifyPopUpMessageIsVisible extends WebScriptTemplate {
    public static final String IPARAM_VISIBILITY = "visibility"

    @Override
    protected void script() {
        Boolean isVisible = assertInput(IPARAM_VISIBILITY) as Boolean

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        if(isVisible) {
            evaluate(ExecutionDetails.create("Check if pop-up message is visible")
                    .expected("Pop-up message is visible")
                    .success(configManagementObject.popUpMessageBox.isPopUpMessageDisplayed()))
        }
        else{
            evaluate(ExecutionDetails.create("Check if pop-up message is not visible")
                    .expected("Pop-up message is not visible")
                    .success(!configManagementObject.popUpMessageBox.isPopUpMessageDisplayed()))
        }
    }
}
