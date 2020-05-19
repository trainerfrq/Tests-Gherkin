package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class PressNewButton extends WebScriptTemplate {
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_item_name"

    @Override
    protected void script() {
        String subMenuItem = assertInput(IPARAM_SUB_MENU_NAME) as String;

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuItem)

        evaluate(ExecutionDetails.create("Check for " + subMenuItem + " New button ")
                .expected("New button was found")
                .success(pageObject.isNewButtonDisplayed()))

        pageObject.clickNewButton()

        evaluate(ExecutionDetails.create("New button was clicked")
                .success(true))
    }
}
