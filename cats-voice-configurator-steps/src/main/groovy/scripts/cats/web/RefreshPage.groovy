package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage
import scripts.elements.general.mainPageComponents.ConfigManagementContent

class RefreshPage extends WebScriptTemplate {

    @Override
    protected void script() {
        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        driver.navigate().refresh();

        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)
        ConfigManagementContent configManagementContent = configManagementObject.configManagementContent

        evaluate(ExecutionDetails.create("Configurator Management content area is displayed")
                .success(configManagementContent.isContentDisplayed()))

        String pluginTitleText = configManagementContent.getContentTitle()

        evaluate(ExecutionDetails.create("Configurator Management content area is empty")
                .received(pluginTitleText)
                .success(pluginTitleText.equals("")))
    }
}
