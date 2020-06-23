package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody


class CleanupItem extends WebScriptTemplate {
    public static final String IPARAM_SUB_MENU_NAME = "sub_menu_name"
    public static final String IPARAM_ITEM_NAME = "item_name"

    @Override
    protected void script() {
        String subMenuName = assertInput(IPARAM_SUB_MENU_NAME) as String
        String itemName = assertInput(IPARAM_ITEM_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, subMenuName)

        if (pageObject.getLeftHandSidePanel().isItemDisplayed(itemName)) {
            WebElement searchedItem = pageObject.getLeftHandSidePanel().findItem(itemName)

            evaluate(ExecutionDetails.create("Item " + itemName + " was found in list")
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

            evaluate(ExecutionDetails.create("Delete button of " + itemName + " was clicked")
                    .success(true))

            WebElement yesButton = driver.findElement(By.xpath("//button[contains(text(),'Yes')]"))
            yesButton.click()
            sleep(5000)

        } else {
            evaluate(ExecutionDetails.create("Item " + itemName + " was not found in list. No action taken")
                    .success(true))
        }
    }
}
