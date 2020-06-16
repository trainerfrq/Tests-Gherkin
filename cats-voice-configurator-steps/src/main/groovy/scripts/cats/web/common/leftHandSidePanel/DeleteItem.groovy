package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class DeleteItem extends WebScriptTemplate {
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_ITEM_NAME = "item_name"

    @Override
    protected void script() {
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String
        String itemName = assertInput(IPARAM_ITEM_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        WebElement searchedItem = pageObject.getLeftHandSidePanel().findItem(itemName)

        evaluate(ExecutionDetails.create("Check item " + itemName + " is in list")
                .expected(itemName + " was found")
                .success(searchedItem != null))

        searchedItem.click()

        evaluate(ExecutionDetails.create("Select item " + itemName)
                .expected(itemName + " was clicked")
                .success(true))

        evaluate(ExecutionDetails.create("Check delete button is displayed")
                .expected("Display button is displayed")
                .success(pageObject.getLeftHandSidePanel().isDeleteButtonDisplayed()))

        pageObject.getLeftHandSidePanel().clickDeleteButton()

        evaluate(ExecutionDetails.create("Click on delete button")
                .expected("Delete button was clicked")
                .success(true))
    }
}
