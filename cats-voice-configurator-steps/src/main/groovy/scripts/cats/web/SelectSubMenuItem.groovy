package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage

class SelectSubMenuItem extends WebScriptTemplate{
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"

    @Override
    protected void script() {
        String subMenuName =  assertInput(IPARAM_SUB_MENU_NAME) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        evaluate(ExecutionDetails.create("Check for " + subMenuName + " sub-menu item")
                .expected(subMenuName + " was found")
                .success(configManagementObject.isSubMenuItemDisplayed(subMenuName)))

        configManagementObject.clickOnSubMenuItem(subMenuName)

        evaluate(ExecutionDetails.create("Sub-menu " + subMenuName + " was clicked")
                .success(true));
    }
}
