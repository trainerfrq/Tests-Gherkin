package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage

class ClickButtonAlertBoxDialog extends WebScriptTemplate{
    public static final String IPARAM_BUTTON_NAME = "button_name"
    public static final String IPARAM_DIALOG_ALERT_TYPE = "alert_type"

    @Override
    protected void script() {
        String buttonName =  assertInput(IPARAM_BUTTON_NAME) as String
        String alertType =  assertInput(IPARAM_DIALOG_ALERT_TYPE) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        if(alertType.equals("Delete")){
            if(buttonName.equals("Yes")){
                configManagementObject.deleteAlertBox.clickYesButton()
            }
            else if(buttonName.equals("No")){
                configManagementObject.deleteAlertBox.clickNoButton()
            }
        }
        else if(alertType.equals("Discard")){
            if(buttonName.equals("Discard changes")){
                configManagementObject.discardAlertBox.clickDiscardChangesButton()
            }
            else if(buttonName.equals("Stay on this page")){
                configManagementObject.discardAlertBox.clickStayOnPageButton()
            }
        }

        evaluate(ExecutionDetails.create("Button " + buttonName + " of alert box dialog was clicked")
                .success(true))
    }
}
