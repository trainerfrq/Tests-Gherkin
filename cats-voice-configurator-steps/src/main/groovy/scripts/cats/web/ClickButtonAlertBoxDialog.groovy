package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate

class ClickButtonAlertBoxDialog extends WebScriptTemplate{
    public static final String IPARAM_BUTTON_NAME = "button_name"
    public static final String IPARAM_DIALOG_ALERT_TYPE = "alert_type"

    @Override
    protected void script() {
        String buttonName =  assertInput(IPARAM_BUTTON_NAME) as String
        String alertType =  assertInput(IPARAM_DIALOG_ALERT_TYPE) as String

        String locator = "//button[contains(text(),'"+buttonName+"')]"

        if(alertType.equals("unsaved changes")) {
            locator = "//div[contains(text(),'" + buttonName + "')]"
        }

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()

        WebElement button = driver.findElement(By.xpath(locator))

        button.click()

        evaluate(ExecutionDetails.create("Button " + buttonName + " of alert box dialog was clicked")
                .success(true))
    }
}
