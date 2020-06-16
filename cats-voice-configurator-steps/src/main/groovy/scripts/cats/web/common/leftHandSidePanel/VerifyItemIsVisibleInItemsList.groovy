package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class VerifyItemIsVisibleInItemsList extends WebScriptTemplate{
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_ITEM_NAME = "item_name"
    public static final String IPARAM_VISIBILITY = "visibility"

    @Override
    protected void script() {
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String
        String itemName = assertInput(IPARAM_ITEM_NAME) as String
        Boolean isVisible = assertInput(IPARAM_VISIBILITY) as Boolean

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        if(isVisible) {
            evaluate(ExecutionDetails.create("Check if " + itemName + " is visible in results list")
                    .expected(itemName + " is visible")
                    .success(pageObject.leftHandSidePanel.isItemDisplayed(itemName)))
        }
        else{
            evaluate(ExecutionDetails.create("Check if " + itemName + " is not visible in results list")
                    .expected(itemName + " is not visible")
                    .success(!pageObject.leftHandSidePanel.isItemDisplayed(itemName)))
        }
    }
}
