package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.general.ConfigManagementPage

class SelectMainMenuItem extends WebScriptTemplate {
    public static final String IPARAM_MAIN_MENU_ITEM_NAME = "main_menu_item_name"

    @Override
    protected void script() {
        String mainMenuItem = assertInput(IPARAM_MAIN_MENU_ITEM_NAME) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)

        evaluate(ExecutionDetails.create("Check for " + mainMenuItem + " menu item")
                .expected(mainMenuItem + " was found")
                .success(configManagementObject.isMenuItemDisplayed(mainMenuItem)))

        configManagementObject.mainLeftHandSidePanel.mainMenu.clickOnMenuItem(mainMenuItem)

        evaluate(ExecutionDetails.create("Menu item " + mainMenuItem + " was clicked")
                .success(true))


    }
}
