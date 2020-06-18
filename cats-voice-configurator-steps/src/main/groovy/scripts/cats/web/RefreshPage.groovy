package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage
import scripts.elements.general.mainPageComponents.MainRightHandSidePanel

class RefreshPage extends WebScriptTemplate {

    @Override
    protected void script() {
        WebDriver driver = WebDriverManager.getInstance().getWebDriver();
        driver.navigate().refresh();

        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        MainRightHandSidePanel mainRightHandSidePanel = configManagementObject.mainRightHandSidePanel

        evaluate(ExecutionDetails.create("Main right hand panel is displayed")
                .success(mainRightHandSidePanel.rightHandMenuDisplayed))

        String pluginTitleText = mainRightHandSidePanel.rightHandMenuPluginTitleText

        evaluate(ExecutionDetails.create("Main right hand panel is empty")
                .received(pluginTitleText)
                .success(pluginTitleText.equals("")))

    }

}
