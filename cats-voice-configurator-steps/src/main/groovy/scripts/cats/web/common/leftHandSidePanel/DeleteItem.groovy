package scripts.cats.web.common.leftHandSidePanel

import com.frequentis.c4i.test.agent.selenium.WebDriverManager
import com.frequentis.c4i.test.model.ExecutionDetails
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import scripts.agent.selenium.automation.WebScriptTemplate
import scripts.elements.ConfigManagementUtils
import scripts.elements.general.mainPageComponents.ContentBody

class DeleteItem extends WebScriptTemplate {
    public static final String IPARAM_ENTRY_NAME = "entry_name"

    @Override
    protected void script() {
        String entryName = assertInput(IPARAM_ENTRY_NAME) as String

        WebDriver driver = WebDriverManager.getInstance().getWebDriver()
        ContentBody pageObject = ConfigManagementUtils.getSubMenuPageObject(driver, "Phone Book")

        WebElement searchedItem = pageObject.getLeftHandSidePanel().findItem(entryName)

        evaluate(ExecutionDetails.create("Check entry " + entryName + " is in list")
                .expected(entryName + " was found")
                .success(searchedItem != null))

        searchedItem.click()

        evaluate(ExecutionDetails.create("Select entry " + entryName)
                .expected(entryName + " was clicked")
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
