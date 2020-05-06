package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.configurators.globalSettingsTelephone.GlobalSettingsTelephone

import java.util.concurrent.TimeUnit

class VerifySubConfiguratorsAreVisible  extends WebScriptTemplate {
    public static final String IPARAM_CONFIGURATOR_NAME = "configurator_name"

    @Override
    protected void script() {
        String configuratorName = assertInput(IPARAM_CONFIGURATOR_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS)

        boolean condition = checkSubConfigVisibility(driver,configuratorName)

        evaluate(ExecutionDetails.create("Check if " + configuratorName + " sub-configurators are visible")
                .expected("Sub-configurators are visible")
                .success(condition))

    }

    private static boolean checkSubConfigVisibility(WebDriver driver, String configuratorName) {
        switch (configuratorName) {
            case "Global settings - Telephone":
                GlobalSettingsTelephone globalSettingsTelephone = new GlobalSettingsTelephone(driver)
                return globalSettingsTelephone.isPhoneBookDisplayed()
            default:
                return false
        }
    }
}
