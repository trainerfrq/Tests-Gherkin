package scripts.cats.web

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.ConfigManagementPage
import scripts.elements.general.mainPageComponents.ContentBody

class ClickOnMainMenuIfSubMenuIsNotVisible extends WebScriptTemplate {
    public static final String IPARAM_MAIN_MENU_NAME = "main_menu_name"
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"

    @Override
    protected void script() {
        String mainMenuName = assertInput(IPARAM_MAIN_MENU_NAME) as String
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ConfigManagementPage configManagementObject = new ConfigManagementPage(driver)
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        if (!pageObject.getLeftHandSidePanel().isItemDisplayed(subMenuName)) {

            evaluate(ExecutionDetails.create("Sub menu " + subMenuName + " is not visible")
                    .expected(subMenuName + " was not found")
                    .success(!pageObject.getLeftHandSidePanel().isItemDisplayed(subMenuName)))

            configManagementObject.clickOnMenuItem(mainMenuName)

            evaluate(ExecutionDetails.create("Click on menu item " + mainMenuName)
                    .expected(mainMenuName + " was clicked")
                    .success(true))

        } else {
            evaluate(ExecutionDetails.create("Sub menu " + subMenuName + " is visible. No action taken")
                    .expected(subMenuName + " is visible")
                    .success(pageObject.getLeftHandSidePanel().isItemDisplayed(subMenuName)))
        }
    }
}
